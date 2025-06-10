package sg.flow.grpc

import io.grpc.Status
import org.springframework.grpc.server.service.GrpcService
import sg.flow.account.v1.AccountServiceGrpcKt.AccountServiceCoroutineImplBase
import sg.flow.account.v1.GetAccountsRequest
import sg.flow.account.v1.GetAccountsResponse
import sg.flow.account.v1.GetAccountsWithTransactionHistoryRequest
import sg.flow.account.v1.GetAccountsWithTransactionHistoryResponse
import sg.flow.account.v1.GetAccountRequest
import sg.flow.account.v1.GetAccountWithTransactionHistoryRequest
import sg.flow.auth.GrpcSecurityContext
import sg.flow.grpc.mapper.AccountMapper
import sg.flow.grpc.mapper.TransactionHistoryMapper
import sg.flow.common.v1.BriefAccount as ProtoBriefAccount
import sg.flow.account.v1.AccountWithTransactionHistory as ProtoAccountWithTransactionHistory
import sg.flow.models.account.BriefAccount as DomainBriefAccount
import sg.flow.models.account.AccountWithTransactionHistory as DomainAccountWithTransactionHistory
import sg.flow.services.AccountServices.AccountService

@GrpcService
class AccountGrpcService(
    private val accountService: AccountService,
    private val accountMapper: AccountMapper,
    private val txHistoryMapper: TransactionHistoryMapper
) : AccountServiceCoroutineImplBase() {

    private fun currentUserId(): Int {
        val user = GrpcSecurityContext.USER_DETAILS.get()
            ?: throw Status.UNAUTHENTICATED.withDescription("No user in context").asRuntimeException()
        return user.userId
    }

    override suspend fun getAccounts(request: GetAccountsRequest): GetAccountsResponse {
        val userId = currentUserId()
        val domainList: List<DomainBriefAccount> =
            accountService.getBriefAccounts(userId)

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
        domainList.forEach { domainAcct ->
            resp.addAccounts(txHistoryMapper.toProto(domainAcct))
        }
        return resp.build()
    }

    override suspend fun getAccount(request: GetAccountRequest): ProtoBriefAccount {
        val userId = currentUserId()
        val accountId = request.accountId

        val domain = try {
            accountService.getBriefAccount(userId, accountId)
        } catch (e: IllegalArgumentException) {
            when (e.message) {
                "Account does not belong to user" ->
                    throw Status.PERMISSION_DENIED.withDescription(e.message).asRuntimeException()
                "Account not found" ->
                    throw Status.NOT_FOUND.withDescription(e.message).asRuntimeException()
                else ->
                    throw Status.UNKNOWN.withDescription(e.message).asRuntimeException()
            }
        }

        return accountMapper.toProto(domain)
    }

    override suspend fun getAccountWithTransactionHistory(
        request: GetAccountWithTransactionHistoryRequest
    ): ProtoAccountWithTransactionHistory {
        val userId = currentUserId()
        val accountId = request.accountId

        val domain = try {
            accountService.getAccountWithTransactionHistory(userId, accountId)
        } catch (e: IllegalArgumentException) {
            when (e.message) {
                "Account does not belong to user" ->
                    throw Status.PERMISSION_DENIED.withDescription(e.message).asRuntimeException()
                "Account not found" ->
                    throw Status.NOT_FOUND.withDescription(e.message).asRuntimeException()
                else ->
                    throw Status.UNKNOWN.withDescription(e.message).asRuntimeException()
            }
        }

        return txHistoryMapper.toProto(domain)
    }
}