package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService

import sg.flow.auth.v1.AuthServiceGrpcKt              // generated from auth_service.proto
import sg.flow.auth.v1.AccessTokenRefreshRequest
import sg.flow.auth.v1.CheckUserExistsRequest
import sg.flow.auth.v1.CheckUserExistsResponse
import sg.flow.auth.v1.SignInRequest
import sg.flow.auth.v1.SignUpRequest
import sg.flow.auth.v1.TokenSet
import sg.flow.grpc.exception.InvalidRefreshTokenException
import sg.flow.grpc.exception.InvalidSignupCredentialException
import sg.flow.grpc.mapper.AuthMapper
import sg.flow.services.AuthServices.AuthService
import sg.flow.validation.ValidationException
import sg.flow.validation.Validator                        // validation helper we built earlier

@GrpcService
class AuthGrpcService(
        private val authService: AuthService,
        private val authMapper: AuthMapper,
) : AuthServiceGrpcKt.AuthServiceCoroutineImplBase() {

        override suspend fun signIn(request: SignInRequest): TokenSet {
                try {
                        Validator.validateUsername(request.email)
                        Validator.validatePassword(request.password)
                } catch (e: ValidationException) {
                        throw InvalidSignupCredentialException(e.message ?: "")
                }
                val tokenSet = authService.getTokenSetForUser(request.email, request.password)
                return TokenSet.newBuilder().
                                setAccessToken(tokenSet.accessToken)
                                .setRefreshToken(tokenSet.refreshToken)
                                .build()
        }

        override suspend fun checkUserExists(request: CheckUserExistsRequest): CheckUserExistsResponse {
                try {
                        Validator.validateUsername(request.email)
                } catch (e: ValidationException) {
                        throw InvalidSignupCredentialException(e.message ?: "")
                }
                val result = authService.checkUserExists(request.email)
                return CheckUserExistsResponse.newBuilder().setExists(result).build()
        }

        override suspend fun signUp(request: SignUpRequest): TokenSet {
                try {
                        Validator.validateUsername(request.email)
                        Validator.validatePassword(request.password)
                } catch (e: ValidationException) {
                        throw InvalidSignupCredentialException(e.message ?: "")
                }


                val token = authService.registerUser(
                        request.email, request.name, request.password
                )
                return authMapper.toProto(token)
        }

        override suspend fun getAccessTokenByRefreshToken(
                request: AccessTokenRefreshRequest
        ): TokenSet {
                try {
                        Validator.validateRefreshToken(request.refreshToken)
                } catch (e: ValidationException) {
                        throw InvalidRefreshTokenException(e.message ?: "")
                }


                val token = authService.getAccessTokenByRefreshToken(
                        sg.flow.models.auth.AccessTokenRefreshRequest(request.refreshToken)
                ) ?: throw Status.NOT_FOUND
                        .withDescription("Refresh token not found")
                        .asRuntimeException()

                return authMapper.toProto(token)
        }
}