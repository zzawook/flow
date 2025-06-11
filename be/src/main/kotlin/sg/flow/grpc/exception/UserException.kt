package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class InvalidUpdateUserProfileRequestException(override val message: String?) : StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Provided User Update Request is invalid: $message"))