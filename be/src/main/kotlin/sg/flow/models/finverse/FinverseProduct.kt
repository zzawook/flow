package sg.flow.models.finverse

import org.springframework.web.reactive.function.client.WebClient
import sg.flow.models.finverse.responses.*
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataIngest
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseResponseProcessor

sealed class FinverseProduct(val productName: String, val apiEndpoint: String) {
    /** Every product must implement its own fetch logic (or share a default). */
    abstract fun fetch(
        loginIdentityId: String,
        finverseResponseProcessor: FinverseResponseProcessor,
        finverseWebclient: WebClient
    )

    object ACCOUNTS : FinverseProduct("ACCOUNTS", "accounts") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
                    .retrieve()
                    .bodyToMono(FinverseAccountResponse::class.java)
                    .block()
            
            response?.let { finverseResponseProcessor.processAccountsResponse(response) }
        }
    }

    object ACCOUNT_NUMBERS : FinverseProduct("ACCOUNT_NUMBERS", "account_numbers") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            // custom logic if needed, or just call the base URL
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
                    .retrieve()
                    .bodyToMono(FinverseAccountNumberResponse::class.java)
                    .block()

            response?.let { finverseResponseProcessor.processAccountNumbersResponse(response) }
        }
    }

    object ONLINE_TRANSACTIONS : FinverseProduct("ONLINE_TRANSACTIONS", "transactions") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            // perhaps use a query param or header specific to online vs. historical
            val response = finverseWebclient
                    .get()
                    .uri { builder ->
                        builder.path("/api/v1/products/$apiEndpoint/$loginIdentityId")
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
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri { builder ->
                        builder.path("/api/v1/products/$apiEndpoint/$loginIdentityId")
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
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
                    .retrieve()
                    .bodyToMono(FinverseIdentityResponse::class.java)
                    .block()

            response?.let { finverseResponseProcessor.processIdentityResponse(response) }
        }
    }

    object BALANCE_HISTORY : FinverseProduct("BALANCE_HISTORY", "balance_history") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
                    .retrieve()
                    .bodyToMono(FinverseBalanceHistoryResponse::class.java)
                    .block()

            response?.let { finverseResponseProcessor.processBalanceHistoryResponse(response) }
        }
    }

    object INCOME_ESTIMATION : FinverseProduct("INCOME_ESTIMATION", "income") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
                    .retrieve()
                    .bodyToMono(FinverseIncomeEstimationResponse::class.java)
                    .block()

            response?.let { finverseResponseProcessor.processIncomeEstimationResponse(response) }
        }
    }

    object STATEMENTS : FinverseProduct("STATEMENTS", "statements") {
        override fun fetch(
                loginIdentityId: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclient: WebClient
        ) {
            val response = finverseWebclient
                    .get()
                    .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
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
