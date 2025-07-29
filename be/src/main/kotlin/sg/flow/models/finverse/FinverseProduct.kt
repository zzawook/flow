package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonValue
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.awaitBody
import sg.flow.models.finverse.responses.*
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseResponseProcessor
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

sealed class FinverseProduct(@JsonValue val productName: String, val apiEndpoint: String) {
    /** Every product must implement its own fetch logic (or share a default). */
    abstract suspend fun fetch(
            loginIdentityId: String,
            loginIdentityToken: String,
            finverseResponseProcessor: FinverseResponseProcessor,
            finverseWebclient: WebClient
    )

    object ACCOUNTS : FinverseProduct("ACCOUNTS", "accounts") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseAccountResponse =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            val accountList = response.let { finverseResponseProcessor.processAccountsResponseIntoAccountList(response) }

            for (account in accountList) {
                val accountNumber = ACCOUNT_NUMBERS.fetchAccountNumberForAccountId(
                    finverseWebclient,
                    account.finverseId ?: "", // WILL ALWAYS HAVE FINVERSE ID
                    loginIdentityId,
                    loginIdentityToken
                )

                account.accountNumber = accountNumber
            }

            finverseResponseProcessor.processAccountList(accountList)
        }
    }

    object ACCOUNT_NUMBERS : FinverseProduct("ACCOUNT_NUMBERS", "account_numbers") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            ACCOUNTS.fetch(
                loginIdentityId,
                loginIdentityToken,
                finverseResponseProcessor,
                finverseWebclient
            )
        }

        suspend fun fetchAccountNumberForAccountId(
                finverseWebClient: WebClient,
                accountId: String,
                loginIdentityId: String,
                loginIdentityToken: String
        ): String {
            val response: FinverseAccountNumberResponse =
                    finverseWebClient
                            .get()
                            .uri("/$apiEndpoint/$accountId")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            return response.accountNumber.accountNumberRaw
        }
    }

    object ONLINE_TRANSACTIONS : FinverseProduct("ONLINE_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            // perhaps use a query param or header specific to online vs. historical
            val response: FinverseTransactionResponse =
                    finverseWebclient
                            .get()
                            .uri { builder ->
                                builder.path("/$apiEndpoint")
                                        .queryParam("type", "online")
                                        .build()
                            }
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object HISTORICAL_TRANSACTIONS : FinverseProduct("HISTORICAL_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseTransactionResponse =
                    finverseWebclient
                            .get()
                            .uri { builder ->
                                builder.path("/$apiEndpoint")
                                        .queryParam("type", "history")
                                        .build()
                            }
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object IDENTITY : FinverseProduct("IDENTITY", "identity") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseIdentityResponse =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processIdentityResponse(response) }
        }
    }

    object BALANCE_HISTORY : FinverseProduct("BALANCE_HISTORY", "balance_history") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseBalanceHistoryResponse =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processBalanceHistoryResponse(response) }
        }
    }

    object INCOME_ESTIMATION : FinverseProduct("INCOME_ESTIMATION", "income") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseIncomeEstimationResponse =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processIncomeEstimationResponse(response) }
        }
    }

    object STATEMENTS : FinverseProduct("STATEMENTS", "statements") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response: FinverseStatementsResponse =
                    finverseWebclient
                            .get()
                            .uri("/$apiEndpoint")
                            .headers { it -> it.setBearerAuth(loginIdentityToken) }
                            .retrieve()
                            .awaitBody()

            response.let { finverseResponseProcessor.processStatementsResponse(response) }
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

        val supported: List<FinverseProduct>
            get() = listOf(
                ACCOUNTS,
                ACCOUNT_NUMBERS,
                ONLINE_TRANSACTIONS,
//                HISTORICAL_TRANSACTIONS
            )

        @JsonCreator
        @JvmStatic
        fun fromString(name: String): FinverseProduct = when(name) {
            ACCOUNTS.productName             -> ACCOUNTS
            ACCOUNT_NUMBERS.productName      -> ACCOUNT_NUMBERS
            ONLINE_TRANSACTIONS.productName  -> ONLINE_TRANSACTIONS
            HISTORICAL_TRANSACTIONS.productName -> HISTORICAL_TRANSACTIONS
            IDENTITY.productName             -> IDENTITY
            BALANCE_HISTORY.productName      -> BALANCE_HISTORY
            INCOME_ESTIMATION.productName    -> INCOME_ESTIMATION
            STATEMENTS.productName           -> STATEMENTS
            else -> throw IllegalArgumentException("Unknown FinverseProduct: $name")
        }
    }
}
