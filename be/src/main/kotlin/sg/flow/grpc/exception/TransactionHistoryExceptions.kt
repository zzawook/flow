package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class InvalidTransactionIdException(override val message: String): StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Provided transaction ID is invalid: $message"))

