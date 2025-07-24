package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.refresh.v1.CanStartRefreshSessionRequest
import sg.flow.refresh.v1.CanStartRefreshSessionResponse
import sg.flow.refresh.v1.GetDataRetrievalResultRequest
import sg.flow.refresh.v1.GetDataRetrievalResultResponse
import sg.flow.refresh.v1.GetInstitutionAuthenticationResultRequest
import sg.flow.refresh.v1.GetInstitutionAuthenticationResultResponse
import sg.flow.refresh.v1.GetRefreshUrlRequest
import sg.flow.refresh.v1.GetRefreshUrlResponse
import sg.flow.refresh.v1.RefreshServiceGrpcKt
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@GrpcService
class RefreshGrpcService(
    private val finverseQueryService: FinverseQueryService
) : RefreshServiceGrpcKt.RefreshServiceCoroutineImplBase() {

    private final val ALREADY_HAS_RUNNING_SESSION_MESSAGE = "ALREADY HAS RUNNING REFRESH SESSION"

    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    override suspend fun canStartRefreshSession(request: CanStartRefreshSessionRequest): CanStartRefreshSessionResponse {
        val userId = currentUserId()
        val isRunning = finverseQueryService.hasRunningRefreshSession(userId, request.institutionId)

        var reason = ""
        if (isRunning) {
            reason = ALREADY_HAS_RUNNING_SESSION_MESSAGE
        }

        return CanStartRefreshSessionResponse.newBuilder().setCanStart(! isRunning).setDescription(reason).build()
    }

    override suspend fun getRefreshUrl(request: GetRefreshUrlRequest): GetRefreshUrlResponse {
        val userId = currentUserId()
        val institutionId = request.institutionId

        var link = "";

        if (finverseQueryService.hasRunningRefreshSession(userId, request.institutionId)) {
            return GetRefreshUrlResponse.newBuilder().setRefreshUrl(ALREADY_HAS_RUNNING_SESSION_MESSAGE).build()
        }

        if (request.hasAutomaticRefresh()) {
            link = finverseQueryService.generateLinkUrl(userId, institutionId, automaticRefresh=request.automaticRefresh)
        }
        else {
            link = finverseQueryService.generateLinkUrl(userId, institutionId)
        }

        return GetRefreshUrlResponse.newBuilder().setRefreshUrl(link).build()
    }

    override suspend fun getInstitutionAuthenticationResult(request: GetInstitutionAuthenticationResultRequest): GetInstitutionAuthenticationResultResponse {
        val userId = currentUserId()
        val result = finverseQueryService.getInstitutionAuthenticationResult(userId, request.institutionId)

        return GetInstitutionAuthenticationResultResponse.newBuilder().setSuccess(result.success).setMessage(result.message).build()
    }

    override suspend fun getDataRetrievalResult(request: GetDataRetrievalResultRequest): GetDataRetrievalResultResponse {
        val userId = currentUserId()
        val institutionId = request.institutionId

        val result = finverseQueryService.getUserDataRetrievalResult(userId, institutionId)

        return GetDataRetrievalResultResponse.newBuilder().setSuccess(result.success).setMessage(result.message) .build()
    }

}