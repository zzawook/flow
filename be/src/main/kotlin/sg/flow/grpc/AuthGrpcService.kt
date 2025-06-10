package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService

import sg.flow.auth.v1.AuthServiceGrpcKt              // generated from auth_service.proto
import sg.flow.auth.v1.AuthRequest
import sg.flow.auth.v1.AccessTokenRefreshRequest
import sg.flow.auth.v1.TokenSet
import sg.flow.grpc.mapper.AuthMapper
import sg.flow.services.AuthServices.AuthService
import sg.flow.validation.Validator                        // validation helper we built earlier

@GrpcService
class AuthGrpcService(
        private val authService: AuthService,
        private val authMapper: AuthMapper,
) : AuthServiceGrpcKt.AuthServiceCoroutineImplBase() {

        override suspend fun signUp(request: AuthRequest): TokenSet {
                Validator.notBlank(request.username, "Username")
                Validator.lengthBetween(request.username, 1, 100, "Username")
                Validator.notBlank(request.password, "Password")
                Validator.lengthBetween(request.password, 6, 100, "Password")

                val token = authService.registerUser(
                        sg.flow.models.auth.AuthRequest(request.username, request.password)
                )
                return authMapper.toProto(token)
        }

        override suspend fun getAccessTokenByRefreshToken(
                request: AccessTokenRefreshRequest
        ): TokenSet {
                Validator.exactLength(request.refreshToken, 64, "Refresh token")

                val token = authService.getAccessTokenByRefreshToken(
                        sg.flow.models.auth.AccessTokenRefreshRequest(request.refreshToken)
                ) ?: throw Status.NOT_FOUND
                        .withDescription("Refresh token not found")
                        .asRuntimeException()

                return authMapper.toProto(token)
        }
}