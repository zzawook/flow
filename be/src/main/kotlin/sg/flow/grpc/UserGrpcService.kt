package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.grpc.mapper.UserMapper
import sg.flow.user.v1.UserServiceGrpcKt
import sg.flow.user.v1.UserProfile as ProtoUserProfile
import sg.flow.user.v1.GetUserPreferenceJsonResponse
import sg.flow.user.v1.UpdateUserProfileRequest
import sg.flow.services.UserServices.UserService
import sg.flow.user.v1.GetUserPreferenceJsonRequest
import sg.flow.user.v1.GetUserProfileRequest

@GrpcService
class UserGrpcService(
    private val userService: UserService,
    private val userMapper: UserMapper
) : UserServiceGrpcKt.UserServiceCoroutineImplBase() {

    /* ── helper to get authenticated userId ── */
    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    /* ── RPCs ──────────────────────────────── */

    override suspend fun getUserProfile(request: GetUserProfileRequest): ProtoUserProfile {
        val userProfile = userService.getUserProfile(currentUserId())
        return userMapper.toProto(userProfile)
    }


    override suspend fun getUserPreferenceJson(request: GetUserPreferenceJsonRequest): GetUserPreferenceJsonResponse =
        GetUserPreferenceJsonResponse.newBuilder()
            .setPreferenceJson(userService.getUserPreferenceJson(currentUserId()))
            .build()

    override suspend fun updateUserProfile(
        request: UpdateUserProfileRequest
    ): ProtoUserProfile {
        val update = userMapper.toDomain(request)
        val updated = userService.updateUserProfile(currentUserId(), update)
        return userMapper.toProto(updated)
    }
}