package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext

import sg.flow.auth.v1.AuthServiceGrpcKt              // generated from auth_service.proto
import sg.flow.auth.v1.AccessTokenRefreshRequest
import sg.flow.auth.v1.CheckEmailVerifiedRequest
import sg.flow.auth.v1.CheckEmailVerifiedResponse
import sg.flow.auth.v1.CheckUserExistsRequest
import sg.flow.auth.v1.CheckUserExistsResponse
import sg.flow.auth.v1.MonitorEmailVerifiedRequest
import sg.flow.auth.v1.MonitorEmailVerifiedResponse
import sg.flow.auth.v1.SendVerificationEmailRequest
import sg.flow.auth.v1.SendVerificationEmailResponse
import sg.flow.auth.v1.SignInRequest
import sg.flow.auth.v1.SignOutRequest
import sg.flow.auth.v1.SignOutResponse
import sg.flow.auth.v1.SignUpRequest
import sg.flow.auth.v1.TokenSet
import sg.flow.grpc.exception.InvalidRefreshTokenException
import sg.flow.grpc.exception.InvalidSignupCredentialException
import sg.flow.grpc.mapper.AuthMapper
import sg.flow.services.AuthServices.AuthService
import sg.flow.validation.ValidationException
import sg.flow.validation.Validator                        // validation helper we built earlier
import java.time.LocalDate
import java.time.ZoneId
import java.time.format.DateTimeFormatter
import java.util.Date

@GrpcService
class AuthGrpcService(
        private val authService: AuthService,
        private val authMapper: AuthMapper,
) : AuthServiceGrpcKt.AuthServiceCoroutineImplBase() {

        private fun currentUserId(): Int {
                val user = GrpcSecurityContext.USER_DETAILS.get()
                        ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
                return user.userId
        }

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

        override suspend fun signOut(request: SignOutRequest): SignOutResponse {
                val result = authService.signOutUser(
                        request.accessToken
                )
                return SignOutResponse.newBuilder().setSuccess(result).build()
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

        override suspend fun sendVerificationEmail(request: SendVerificationEmailRequest): SendVerificationEmailResponse {
                return SendVerificationEmailResponse.newBuilder().setSuccess(authService.sendVerificationEmail(request.email)).build()
        }

        override suspend fun checkEmailVerified(request: CheckEmailVerifiedRequest): CheckEmailVerifiedResponse {
                return CheckEmailVerifiedResponse.newBuilder().setVerified(authService.checkEmailVerified(request.email)).build()
        }

        override suspend fun monitorEmailVerified(request: MonitorEmailVerifiedRequest): MonitorEmailVerifiedResponse {
                return MonitorEmailVerifiedResponse.newBuilder().setVerified(authService.monitorEmailVerified((request.email))).build()
        }
}