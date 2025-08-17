package sg.flow.grpc

data class UserIdAndPasswordHash(
    final val userId: Int,
    final val passwordHash: String,
)