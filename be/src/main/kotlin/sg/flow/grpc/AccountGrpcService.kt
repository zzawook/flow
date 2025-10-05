package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.account.v1.AccountServiceGrpcKt.AccountServiceCoroutineImplBase
import sg.flow.account.v1.AccountWithTransactionHistory as ProtoAccountWithTransactionHistory
import sg.flow.account.v1.GetAccountRequest
import sg.flow.account.v1.GetAccountWithTransactionHistoryRequest
import sg.flow.account.v1.GetAccountsRequest
import sg.flow.account.v1.GetAccountsResponse
import sg.flow.account.v1.GetAccountsWithTransactionHistoryRequest
import sg.flow.account.v1.GetAccountsWithTransactionHistoryResponse
import sg.flow.account.v1.GetDailyAssetsRequest
import sg.flow.account.v1.GetDailyAssetsResponse
import sg.flow.account.v1.GetLast6MonthsEndOfMonthAssetsRequest
import sg.flow.account.v1.GetLast6MonthsEndOfMonthAssetsResponse
import sg.flow.account.v1.GetLast7DaysAssetsRequest
import sg.flow.account.v1.GetLast7DaysAssetsResponse
import sg.flow.auth.GrpcSecurityContext
import sg.flow.common.v1.Account as ProtoAccount
import sg.flow.grpc.exception.InvalidAccountIdException
import sg.flow.grpc.exception.InvalidTimestampRangeException
import sg.flow.grpc.mapper.AccountMapper
import sg.flow.grpc.mapper.DateTimeMapper
import sg.flow.grpc.mapper.TransactionHistoryMapper
import sg.flow.models.account.AccountWithTransactionHistory as DomainAccountWithTransactionHistory
import sg.flow.models.account.BriefAccount as DomainAccount
import sg.flow.services.AccountServices.AccountService
import sg.flow.services.DailyAssetServices.DailyAssetService
import sg.flow.validation.ValidationException
import sg.flow.validation.Validator

@GrpcService
class AccountGrpcService(
        private val accountService: AccountService,
        private val accountMapper: AccountMapper,
        private val txHistoryMapper: TransactionHistoryMapper,
        private val dailyAssetService: DailyAssetService,
        private val dateTimeMapper: DateTimeMapper
) : AccountServiceCoroutineImplBase() {

    private fun currentUserId(): Int {
        val user =
                GrpcSecurityContext.USER_DETAILS.get()
                        ?: throw Status.UNAUTHENTICATED
                                .withDescription("No user in context")
                                .asRuntimeException()
        return user.userId
    }

    override suspend fun getAccounts(request: GetAccountsRequest): GetAccountsResponse {
        val userId = currentUserId()
        val domainList: List<DomainAccount> = accountService.getAccounts(userId)

        val respBuilder = GetAccountsResponse.newBuilder()
        domainList.forEach { domainAcct ->
            respBuilder.addAccounts(accountMapper.toProto(domainAcct))
        }

        return respBuilder.build()
    }

    override suspend fun getAccountsWithTransactionHistory(
            request: GetAccountsWithTransactionHistoryRequest
    ): GetAccountsWithTransactionHistoryResponse {
        val userId = currentUserId()
        val domainList: List<DomainAccountWithTransactionHistory> =
                accountService.getAccountWithTransactionHistory(userId)

        val resp = GetAccountsWithTransactionHistoryResponse.newBuilder()
        domainList.forEach { domainAcct -> resp.addAccounts(txHistoryMapper.toProto(domainAcct)) }
        return resp.build()
    }

    override suspend fun getAccount(request: GetAccountRequest): ProtoAccount {
        try {
            Validator.validateAccountId(request.accountId)
        } catch (e: ValidationException) {
            throw InvalidAccountIdException(e.message ?: "Invalid accountId")
        }

        val userId = currentUserId()
        val accountId = request.accountId

        val domain =
                try {
                    accountService.getAccount(userId, accountId)
                } catch (e: IllegalArgumentException) {
                    when (e.message) {
                        "Account does not belong to user" ->
                                throw Status.PERMISSION_DENIED
                                        .withDescription(e.message)
                                        .asRuntimeException()
                        "Account not found" ->
                                throw Status.NOT_FOUND
                                        .withDescription(e.message)
                                        .asRuntimeException()
                        else -> throw Status.UNKNOWN.withDescription(e.message).asRuntimeException()
                    }
                }

        return accountMapper.toProto(domain)
    }

    override suspend fun getAccountWithTransactionHistory(
            request: GetAccountWithTransactionHistoryRequest
    ): ProtoAccountWithTransactionHistory {
        try {
            Validator.validateAccountId(request.accountId)
        } catch (e: ValidationException) {
            throw InvalidAccountIdException(e.message ?: "Invalid accountId")
        }

        val userId = currentUserId()
        val accountId = request.accountId

        val domain =
                try {
                    accountService.getAccountWithTransactionHistory(userId, accountId)
                } catch (e: IllegalArgumentException) {
                    when (e.message) {
                        "Account does not belong to user" ->
                                throw Status.PERMISSION_DENIED
                                        .withDescription(e.message)
                                        .asRuntimeException()
                        "Account not found" ->
                                throw Status.NOT_FOUND
                                        .withDescription(e.message)
                                        .asRuntimeException()
                        else -> throw Status.UNKNOWN.withDescription(e.message).asRuntimeException()
                    }
                }

        return txHistoryMapper.toProto(domain)
    }

    override suspend fun getDailyAssets(request: GetDailyAssetsRequest): GetDailyAssetsResponse {
        try {
            Validator.validateTimestamp(request.startDate)
            Validator.validateTimestamp(request.endDate)
            Validator.validateStartTimestampIsNotAfterEndTimestamp(
                    request.startDate,
                    request.endDate
            )
        } catch (e: ValidationException) {
            throw InvalidTimestampRangeException(
                    e.message
                            ?: "Could not validate timestamp range by provided start and end timestamp"
            )
        }

        val userId = currentUserId()
        val startDate = dateTimeMapper.toLocalDate(request.startDate)
        val endDate = dateTimeMapper.toLocalDate(request.endDate)

        val assets = dailyAssetService.getAssetsByDateRange(userId, startDate, endDate)

        return accountMapper.toProtoDailyAssetsResponse(assets)
    }

    override suspend fun getLast7DaysAssets(
            request: GetLast7DaysAssetsRequest
    ): GetLast7DaysAssetsResponse {
        val userId = currentUserId()
        val assets = dailyAssetService.getLast7DaysAssets(userId)
        return accountMapper.toProtoLast7DaysResponse(assets)
    }

    override suspend fun getLast6MonthsEndOfMonthAssets(
            request: GetLast6MonthsEndOfMonthAssetsRequest
    ): GetLast6MonthsEndOfMonthAssetsResponse {
        val userId = currentUserId()
        val assets = dailyAssetService.getLast6MonthsEndOfMonthAssets(userId)
        return accountMapper.toProtoLast6MonthsResponse(assets)
    }
}
