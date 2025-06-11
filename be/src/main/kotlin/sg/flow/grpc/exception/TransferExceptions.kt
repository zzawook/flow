package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class InvalidAccountNumberKeywordException(override val message: String) : StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription(message))

class InvalidContactKeywordException(override val message: String) : StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription(message))

class InvalidTransferRequestException(override val message: String) : StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription(message))