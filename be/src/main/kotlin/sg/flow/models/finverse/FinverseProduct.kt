package sg.flow.models.finverse

import org.springframework.web.reactive.function.client.WebClient
import sg.flow.models.finverse.responses.*
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseResponseProcessor
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

sealed class FinverseProduct(val productName: String, val apiEndpoint: String) {
    /** Every product must implement its own fetch logic (or share a default). */
    abstract suspend fun fetch(
            loginIdentityId: String,
            finverseResponseProcessor: FinverseResponseProcessor,
            finverseWebclient: WebClient
    )

    object ACCOUNTS : FinverseProduct("ACCOUNTS", "accounts") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint/$loginIdentityId")
                            .retrieve()
                            .bodyToMono(FinverseAccountResponse::class.java)
                            .block()

            val accountList = response?.let { finverseResponseProcessor.processAccountsResponseIntoAccountList(response) }

            if (accountList == null) {
                throw FinverseException("ACCOUNT LIST FAILED TO PARSE")
            }

            for (account in accountList) {
                val accountNumber = FinverseProduct.ACCOUNT_NUMBERS.fetchAccountNumberForAccountId(
                    finverseWebclient,
                    account.finverseId ?: "", // WILL ALWAYS HAVE FINVERSE ID
                    loginIdentityId
                )

                account.accountNumber = accountNumber
            }

            finverseResponseProcessor.processAccountList(accountList)
        }
    }

    object ACCOUNT_NUMBERS : FinverseProduct("ACCOUNT_NUMBERS", "account_numbers") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            // DOES NOT HAVE EXPLICIT FETCH METHOD FOR ACCOUNT NUMBERS
        }

        suspend fun fetchAccountNumberForAccountId(
                finverseWebClient: WebClient,
                accountId: String,
                loginIdentityId: String
        ): String {
            val response =
                    finverseWebClient
                            .get()
                            .uri("/$apiEndpoint/$accountId")
                            .headers { it -> it.setBearerAuth(loginIdentityId) }
                            .retrieve()
                            .bodyToMono(FinverseAccountNumberResponse::class.java)
                            .block()

            if (response == null) {
                throw FinverseException("ACCOUNT NUMBER NOT FETCHED")
            }

            return response.accountNumber.accountNumberRaw
        }
    }

    object ONLINE_TRANSACTIONS : FinverseProduct("ONLINE_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            // perhaps use a query param or header specific to online vs. historical
            val response =
                    finverseWebclient
                            .get()
                            .uri { builder ->
                                builder.path("/$apiEndpoint/$loginIdentityId")
                                        .queryParam("type", "online")
                                        .build()
                            }
                            .retrieve()
                            .bodyToMono(FinverseTransactionResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object HISTORICAL_TRANSACTIONS : FinverseProduct("HISTORICAL_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri { builder ->
                                builder.path("/$apiEndpoint/$loginIdentityId")
                                        .queryParam("type", "history")
                                        .build()
                            }
                            .retrieve()
                            .bodyToMono(FinverseTransactionResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object IDENTITY : FinverseProduct("IDENTITY", "identity") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint/$loginIdentityId")
                            .retrieve()
                            .bodyToMono(FinverseIdentityResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processIdentityResponse(response) }
        }
    }

    object BALANCE_HISTORY : FinverseProduct("BALANCE_HISTORY", "balance_history") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint/$loginIdentityId")
                            .retrieve()
                            .bodyToMono(FinverseBalanceHistoryResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processBalanceHistoryResponse(response) }
        }
    }

    object INCOME_ESTIMATION : FinverseProduct("INCOME_ESTIMATION", "income") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint/$loginIdentityId")
                            .retrieve()
                            .bodyToMono(FinverseIncomeEstimationResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processIncomeEstimationResponse(response) }
        }
    }

    object STATEMENTS : FinverseProduct("STATEMENTS", "statements") {
        override suspend fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint/$loginIdentityId")
                            .retrieve()
                            .bodyToMono(FinverseStatementsResponse::class.java)
                            .block()

            response?.let { finverseResponseProcessor.processStatementsResponse(response) }
        }
    }

    companion object {
        /** A helper to iterate all products, if needed. */
        val all: List<FinverseProduct> =
                listOf(
                        ACCOUNTS,
                        ACCOUNT_NUMBERS,
                        ONLINE_TRANSACTIONS,
                        HISTORICAL_TRANSACTIONS,
                        IDENTITY,
                        BALANCE_HISTORY,
                        INCOME_ESTIMATION,
                        STATEMENTS
                )
    }
}
