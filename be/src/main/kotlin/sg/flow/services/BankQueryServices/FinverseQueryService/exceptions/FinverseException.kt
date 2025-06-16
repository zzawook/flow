package sg.flow.services.BankQueryServices.FinverseQueryService.exceptions

import io.grpc.Status
import io.grpc.StatusRuntimeException

class FinverseException(val detail: String) : StatusRuntimeException(Status.UNKNOWN.withDescription(detail))