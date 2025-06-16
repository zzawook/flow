package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.refresh.v1.GetRefreshUrlRequest
import sg.flow.refresh.v1.GetRefreshUrlResponse
import sg.flow.refresh.v1.RefreshServiceGrpcKt
import sg.flow.refresh.v1.RegisterLinkCompleteWithCodeRequest
import sg.flow.refresh.v1.RegisterLinkCompleteWithCodeResponse
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@GrpcService
class RefreshGrpcService(
    private val finverseQueryService: FinverseQueryService
) : RefreshServiceGrpcKt.RefreshServiceCoroutineImplBase() {

    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    override suspend fun getRefreshUrl(request: GetRefreshUrlRequest): GetRefreshUrlResponse {
        val userId = currentUserId()
        val institutionId = request.institutionId

        var link: String = "";

        if (request.hasAutomaticRefresh()) {
            link = finverseQueryService.generateLinkUrl(userId, institutionId, automaticRefresh=request.automaticRefresh)
        }
        else {
            val link = finverseQueryService.generateLinkUrl(userId, institutionId)
        }

        return GetRefreshUrlResponse.newBuilder().setRefreshUrl(link).build()
    }

    override suspend fun registerLinkCompleteWithCode(request: RegisterLinkCompleteWithCodeRequest): RegisterLinkCompleteWithCodeResponse {
        val userId = currentUserId()
        val code = request.code

        val ticketNumber = finverseQueryService.fetchLoginIdentity(code)

        return RegisterLinkCompleteWithCodeResponse.newBuilder().setSuccess(true).setTicketNumber(ticketNumber).build()
    }
}