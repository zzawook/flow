package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient
import reactor.core.publisher.Mono
import sg.flow.entities.Account
import sg.flow.entities.TransactionHistory
import sg.flow.entities.User
import sg.flow.models.finverse.responses.*

/**
 * Example service demonstrating how to use the Finverse DTOs and mappers with WebClient for actual
 * API integration
 */
//@Service
class FinverseApiUsageExample(
        private val finverseWebClient: WebClient,
        private val responseProcessor: FinverseResponseProcessor
) {
//
//    /** Example: Fetch and process accounts from Finverse API */
//    fun fetchAndProcessAccounts(loginIdentityId: String): Mono<List<Account>> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/accounts/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseAccountResponse::class.java)
//                .map { response -> responseProcessor.processAccountsResponse(response) }
//                .onErrorReturn(emptyList())
//    }
//
//    /** Example: Fetch and process transactions from Finverse API */
//    fun fetchAndProcessTransactions(loginIdentityId: String): Mono<List<TransactionHistory>> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/transactions/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseTransactionResponse::class.java)
//                .map { response -> responseProcessor.processTransactionsResponse(response) }
//                .onErrorReturn(emptyList())
//    }
//
//    /** Example: Fetch and process account numbers from Finverse API */
//    fun fetchAndProcessAccountNumbers(loginIdentityId: String): Mono<List<Account>> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/account_numbers/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseAccountNumberResponse::class.java)
//                .map { response -> responseProcessor.processAccountNumbersResponse(response) }
//                .onErrorReturn(emptyList())
//    }
//
//    /** Example: Fetch and process identity information from Finverse API */
//    fun fetchAndProcessIdentity(loginIdentityId: String): Mono<User?> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/identity/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseIdentityResponse::class.java)
//                .map { response -> responseProcessor.processIdentityResponse(response) }
//                .onErrorReturn(null)
//    }
//
//    /** Example: Fetch balance history from Finverse API */
//    fun fetchBalanceHistory(loginIdentityId: String): Mono<List<FinverseBalanceHistoryData>> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/balance_history/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseBalanceHistoryResponse::class.java)
//                .map { response -> responseProcessor.processBalanceHistoryResponse(response) }
//                .onErrorReturn(emptyList())
//    }
//
//    /** Example: Fetch income estimation from Finverse API */
//    fun fetchIncomeEstimation(loginIdentityId: String): Mono<FinverseIncomeEstimationData?> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/income/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseIncomeEstimationResponse::class.java)
//                .map { response -> responseProcessor.processIncomeEstimationResponse(response) }
//                .onErrorReturn(null)
//    }
//
//    /** Example: Fetch statements from Finverse API */
//    fun fetchStatements(loginIdentityId: String): Mono<List<FinverseStatementData>> {
//        return finverseWebClient
//                .get()
//                .uri("/api/v1/products/statements/{loginIdentityId}", loginIdentityId)
//                .retrieve()
//                .bodyToMono(FinverseStatementsResponse::class.java)
//                .map { response -> responseProcessor.processStatementsResponse(response) }
//                .onErrorReturn(emptyList())
//    }
//
//    /** Example: Fetch multiple products concurrently */
//    fun fetchAllUserData(loginIdentityId: String): Mono<UserFinancialData> {
//        val accountsMono = fetchAndProcessAccounts(loginIdentityId)
//        val transactionsMono = fetchAndProcessTransactions(loginIdentityId)
//        val identityMono = fetchAndProcessIdentity(loginIdentityId)
//        val balanceHistoryMono = fetchBalanceHistory(loginIdentityId)
//
//        return Mono.zip(accountsMono, transactionsMono, identityMono, balanceHistoryMono).map {
//                tuple ->
//            UserFinancialData(
//                    accounts = tuple.t1,
//                    transactions = tuple.t2,
//                    identity = tuple.t3,
//                    balanceHistory = tuple.t4
//            )
//        }
//    }
}

/** Aggregated user financial data from multiple Finverse endpoints */
data class UserFinancialData(
        val accounts: List<Account>,
        val transactions: List<TransactionHistory>,
        val identity: User?,
        val balanceHistory: List<FinverseBalanceHistoryData>
)
