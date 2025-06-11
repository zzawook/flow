package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class InvalidSignupCredentialException(override val message: String): StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Invalid Sign Up Credentials: $message"))

class InvalidRefreshTokenException(override val message: String): StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Invalid Refresh Token: $message"))