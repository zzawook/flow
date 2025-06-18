package sg.flow.services.BankQueryServices.FinverseQueryService.exceptions

import io.grpc.Status
import io.grpc.StatusRuntimeException

class FinverseCacheMissException(val detail: String): StatusRuntimeException(Status.NOT_FOUND.withDescription(detail))