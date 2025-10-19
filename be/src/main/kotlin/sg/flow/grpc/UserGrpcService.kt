package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.grpc.exception.InvalidUpdateUserProfileRequestException
import sg.flow.grpc.mapper.DateTimeMapper
import sg.flow.grpc.mapper.UserMapper
import sg.flow.user.v1.UserServiceGrpcKt
import sg.flow.user.v1.UserProfile as ProtoUserProfile
import sg.flow.user.v1.GetUserPreferenceJsonResponse
import sg.flow.user.v1.UpdateUserProfileRequest
import sg.flow.services.UserServices.UserService
import sg.flow.user.v1.GetUserPreferenceJsonRequest
import sg.flow.user.v1.GetUserProfileRequest
import sg.flow.user.v1.SetConstantUserFieldsRequest
import sg.flow.user.v1.SetConstantUserFieldsResponse
import sg.flow.validation.ValidationException
import sg.flow.validation.Validator

@GrpcService
class UserGrpcService(
    private val userService: UserService,
    private val userMapper: UserMapper,
    private val dateTimeMapper: DateTimeMapper
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
        try {
            Validator.validateEmail(request.email)
        } catch (e : ValidationException) {
            throw InvalidUpdateUserProfileRequestException(e.message ?: "Unable to process provided user profile")
        }

        val update = userMapper.toDomain(request)
        val updated = userService.updateUserProfile(currentUserId(), update)
        try {
            val proto = userMapper.toProto(updated)
            return proto
        } catch (e: Exception) {
            e.printStackTrace()
            return ProtoUserProfile.newBuilder().build()
        }

    }

    override suspend fun setConstantUserFields(request: SetConstantUserFieldsRequest): SetConstantUserFieldsResponse {
        val userId = currentUserId()
        val result = userService.setConstantUserFields(userId, dateTimeMapper.toLocalDate(request.dateOfBirth), request.genderIsMale)

        return SetConstantUserFieldsResponse.newBuilder().setSuccess(result).build()
    }
}