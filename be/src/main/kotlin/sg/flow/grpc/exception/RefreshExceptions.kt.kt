package sg.flow.grpc.exception

import io.grpc.Status
import io.grpc.StatusRuntimeException

class UserCannotLinkBankException(override val message: String?) : StatusRuntimeException(Status.PERMISSION_DENIED.withDescription("User cannot link bank: $message"))