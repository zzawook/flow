package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class InvalidAccessTokenException(override val message: String): StatusRuntimeException(Status.UNAUTHENTICATED.withDescription("Invalid Access Token Provided: $message"))

class InvalidTimestampRangeException(override val message: String): StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Timestamp range deduced by provided start and end timestamp is invalid: $message"))

class InvalidYearMonthDayException(override val message: String): StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Provided year and/or month and/or day is invalid: $message"))