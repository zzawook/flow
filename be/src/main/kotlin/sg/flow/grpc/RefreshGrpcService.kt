package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.auth.GrpcSecurityContext
import sg.flow.common.v1.CommonBankProto
import sg.flow.grpc.exception.UserCannotLinkBankException
import sg.flow.refresh.v1.CanLinkBankRequest
import sg.flow.refresh.v1.CanLinkBankResponse
import sg.flow.refresh.v1.CanStartRefreshSessionRequest
import sg.flow.refresh.v1.CanStartRefreshSessionResponse
import sg.flow.refresh.v1.GetAllRunningRefreshSessionsRequest
import sg.flow.refresh.v1.GetAllRunningRefreshSessionsResponse
import sg.flow.refresh.v1.GetBanksForLinkRequest
import sg.flow.refresh.v1.GetBanksForLinkResponse
import sg.flow.refresh.v1.GetBanksForRefreshRequest
import sg.flow.refresh.v1.GetBanksForRefreshResponse
import sg.flow.refresh.v1.GetDataRetrievalResultRequest
import sg.flow.refresh.v1.GetDataRetrievalResultResponse
import sg.flow.refresh.v1.GetInstitutionAuthenticationResultRequest
import sg.flow.refresh.v1.GetInstitutionAuthenticationResultResponse
import sg.flow.refresh.v1.GetLoginMemoForBankRequest
import sg.flow.refresh.v1.GetLoginMemoForBankResponse
import sg.flow.refresh.v1.GetRefreshUrlRequest
import sg.flow.refresh.v1.GetRefreshUrlResponse
import sg.flow.refresh.v1.GetRelinkUrlRequest
import sg.flow.refresh.v1.GetRelinkUrlResponse
import sg.flow.refresh.v1.RefreshServiceGrpcKt
import sg.flow.refresh.v1.UpdateLoginMemoForBankRequest
import sg.flow.refresh.v1.UpdateLoginMemoForBankResponse
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService
import sg.flow.services.LoginMemoServices.LoginMemoService
import sg.flow.services.UserServices.UserService

@GrpcService
class RefreshGrpcService(
    private val finverseQueryService: FinverseQueryService,
    private val userService : UserService,
    private val loginMemoService: LoginMemoService
) : RefreshServiceGrpcKt.RefreshServiceCoroutineImplBase() {

    private final val ALREADY_HAS_RUNNING_SESSION_MESSAGE = "ALREADY HAS RUNNING REFRESH SESSION"

    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    private suspend fun getFinverseInstitutionId(institutionId: Long): String {
        return finverseQueryService.getFinverseInstitutionId(institutionId)
    }

    override suspend fun canStartRefreshSession(request: CanStartRefreshSessionRequest): CanStartRefreshSessionResponse {
        val userId = currentUserId()
        val finverseInstitutionId = finverseQueryService.getFinverseInstitutionId(request.institutionId)
        val isRunning = finverseQueryService.hasRunningRefreshSession(userId, finverseInstitutionId)

        var reason = ""
        if (isRunning) {
            reason = ALREADY_HAS_RUNNING_SESSION_MESSAGE
        }

        return CanStartRefreshSessionResponse.newBuilder().setCanStart(! isRunning).setDescription(reason).build()
    }

    override suspend fun getBanksForRefresh(request: GetBanksForRefreshRequest): GetBanksForRefreshResponse {
        val userId = currentUserId()
        val country = request.countryCode
        val banks = finverseQueryService.getBanksForRefresh(userId, country)

        val resp = GetBanksForRefreshResponse.newBuilder()
        banks.forEach { bank ->
            resp.addBanks(
            CommonBankProto.Bank.newBuilder()
                .setName(bank.name)
                .setBankCode(bank.bankCode)
                .setId(bank.id ?: -1)
                .build()
            )
        }
        return resp.build()
    }

    override suspend fun getBanksForLink(request: GetBanksForLinkRequest): GetBanksForLinkResponse {
        val userId = currentUserId()
        val country = request.countryCode
        val banks = finverseQueryService.getBanksForLink(userId, country)

        val resp = GetBanksForLinkResponse.newBuilder()
        banks.forEach { bank ->
            if (! finverseQueryService.hasRunningRefreshSession(userId, bank.finverseId ?: bank.bankCode)) {
                resp.addBanks(
                    CommonBankProto.Bank.newBuilder()
                        .setName(bank.name)
                        .setBankCode(bank.bankCode)
                        .setId(bank.id ?: -1)
                        .build()
                )
            }
        }

        return resp.build()
    }


    override suspend fun getRefreshUrl(request: GetRefreshUrlRequest): GetRefreshUrlResponse {
        val userId = currentUserId()
        if (!userService.canLinkBank(userId)) {
            throw UserCannotLinkBankException("")
        }
        val institutionId = request.institutionId
        val finverseInstitutionId = finverseQueryService.getFinverseInstitutionId(institutionId)

        if (finverseQueryService.hasRunningRefreshSession(userId, finverseInstitutionId)) {
            return GetRefreshUrlResponse.newBuilder().setRefreshUrl(ALREADY_HAS_RUNNING_SESSION_MESSAGE).build()
        }

        val link = finverseQueryService.refresh(userId, finverseInstitutionId)

        return GetRefreshUrlResponse.newBuilder().setRefreshUrl(link).build()
    }

    override suspend fun getRelinkUrl(request: GetRelinkUrlRequest): GetRelinkUrlResponse {
        val userId = currentUserId()

        if (!userService.canLinkBank(userId)) {
            throw UserCannotLinkBankException("")
        }

        val institutionId = request.institutionId
        val finverseInstitutionId = finverseQueryService.getFinverseInstitutionId(institutionId)

        if (finverseQueryService.hasRunningRefreshSession(userId, finverseInstitutionId)) {
            return GetRelinkUrlResponse.newBuilder().setRelinkUrl(ALREADY_HAS_RUNNING_SESSION_MESSAGE).build()
        }
        val link = finverseQueryService.relink(userId, finverseInstitutionId)

        return GetRelinkUrlResponse.newBuilder().setRelinkUrl(link).build()
    }

    override suspend fun getInstitutionAuthenticationResult(request: GetInstitutionAuthenticationResultRequest): GetInstitutionAuthenticationResultResponse {
        val userId = currentUserId()
        val finverseInstitutionId = finverseQueryService.getFinverseInstitutionId(request.institutionId)
        val result = finverseQueryService.getInstitutionAuthenticationResult(userId, finverseInstitutionId)
        return GetInstitutionAuthenticationResultResponse.newBuilder().setSuccess(result.success).setMessage(result.message).build()
    }

    override suspend fun getDataRetrievalResult(request: GetDataRetrievalResultRequest): GetDataRetrievalResultResponse {
        val userId = currentUserId()
        val institutionId = request.institutionId
        val finverseInstitutionId = finverseQueryService.getFinverseInstitutionId(institutionId)

        val result = finverseQueryService.getUserDataRetrievalResult(userId, finverseInstitutionId)

        return GetDataRetrievalResultResponse.newBuilder().setSuccess(result.success).setMessage(result.message) .build()
    }

    override suspend fun canLinkBank(request: CanLinkBankRequest): CanLinkBankResponse {
        val userId = currentUserId()

        val result = userService.canLinkBank(userId);
        return CanLinkBankResponse.newBuilder().setCanLink(result).build()
    }

    override suspend fun getLoginMemoForBank(request: GetLoginMemoForBankRequest): GetLoginMemoForBankResponse {
        val userId = currentUserId()

        val result = loginMemoService.getLoginMemo(userId, request.institutionId.toString())
        return GetLoginMemoForBankResponse.newBuilder().setLoginMemo(result).build()
    }

    override suspend fun updateLoginMemoForBank(request: UpdateLoginMemoForBankRequest): UpdateLoginMemoForBankResponse {
        val userId = currentUserId()

        val result = loginMemoService.setLoginMemo(userId, request.institutionId.toString(), request.loginMemo)
        return UpdateLoginMemoForBankResponse.newBuilder().setSuccess(result).build()
    }

    override suspend fun getAllRunningRefreshSessions(request: GetAllRunningRefreshSessionsRequest): GetAllRunningRefreshSessionsResponse {
        val userId = currentUserId()

        val result = finverseQueryService.getAllInstitutionIdThatHasRunningRefreshSessions(userId).map { res -> res.toLong() }
        return GetAllRunningRefreshSessionsResponse.newBuilder().addAllInstitutionIds(result).build()
    }
}