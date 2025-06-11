package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class RequestedAccountNotBelongException(val userId: Int, val accountId: Long) : StatusRuntimeException(Status.UNAUTHENTICATED.withDescription("Requested account does not belong to the user: Account: $accountId, User: $userId"))

class AccountDoesNotExistException(val accountId: Long) : StatusRuntimeException(Status.NOT_FOUND.withDescription("Account does not exist: $accountId"))

class InvalidAccountIdException(override val message: String) : StatusRuntimeException(Status.INVALID_ARGUMENT.withDescription("Provided accountId is invalid: $message"))