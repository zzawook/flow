package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonValue
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.awaitBody
import sg.flow.models.finverse.responses.*
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseResponseProcessor
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseWebclientService
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

sealed class FinverseProduct(@JsonValue val productName: String, val apiEndpoint: String) {
    /** Every product must implement its own fetch logic (or share a default). */
    abstract suspend fun fetch(
            loginIdentityId: String,
            loginIdentityToken: String,
            finverseResponseProcessor: FinverseResponseProcessor,
            finverseWebclientService: FinverseWebclientService
    )

    object ACCOUNTS : FinverseProduct("ACCOUNTS", "accounts") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseAccountResponse = finverseWebclientService.fetchAccount(loginIdentityToken)

            val accountList = response.let { finverseResponseProcessor.processAccountsResponseIntoAccountList(response) }

            for (account in accountList) {
                val accountNumber = ACCOUNT_NUMBERS.fetchAccountNumberForAccountId(
                    finverseWebclientService,
                    account.finverseId ?: "", // WILL ALWAYS HAVE FINVERSE ID
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
                finverseWebclientService: FinverseWebclientService
        ) {
            ACCOUNTS.fetch(
                loginIdentityId,
                loginIdentityToken,
                finverseResponseProcessor,
                finverseWebclientService
            )
        }

        suspend fun fetchAccountNumberForAccountId(
                finverseWebclientService: FinverseWebclientService,
                accountId: String,
                loginIdentityToken: String
        ): String {
            val response: FinverseAccountNumberResponse = finverseWebclientService.fetchAccountNumberForAccountId(loginIdentityToken, accountId)

            return response.accountNumber.accountNumberRaw
        }
    }

    object ONLINE_TRANSACTIONS : FinverseProduct("ONLINE_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            // perhaps use a query param or header specific to online vs. historical
            val response: FinverseTransactionResponse = finverseWebclientService.fetchOnlineTransaction(loginIdentityToken)

            response.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object HISTORICAL_TRANSACTIONS : FinverseProduct("HISTORICAL_TRANSACTIONS", "transactions") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseTransactionResponse = finverseWebclientService.fetchHistoricalTransaction(loginIdentityToken)

            response.let { finverseResponseProcessor.processTransactionsResponse(response) }
        }
    }

    object IDENTITY : FinverseProduct("IDENTITY", "identity") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseIdentityResponse = finverseWebclientService.fetchIdentity(loginIdentityToken)

            response.let { finverseResponseProcessor.processIdentityResponse(response) }
        }
    }

    object BALANCE_HISTORY : FinverseProduct("BALANCE_HISTORY", "balance_history") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseBalanceHistoryResponse = finverseWebclientService.fetchBalanceHistory(loginIdentityToken)

            response.let { finverseResponseProcessor.processBalanceHistoryResponse(response) }
        }
    }

    object INCOME_ESTIMATION : FinverseProduct("INCOME_ESTIMATION", "income") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseIncomeEstimationResponse = finverseWebclientService.fetchIncomeStatement(loginIdentityToken)

            response.let { finverseResponseProcessor.processIncomeEstimationResponse(response) }
        }
    }

    object STATEMENTS : FinverseProduct("STATEMENTS", "statements") {
        override suspend fun fetch(
                loginIdentityId: String,
                loginIdentityToken: String,
                finverseResponseProcessor: FinverseResponseProcessor,
                finverseWebclientService: FinverseWebclientService
        ) {
            val response: FinverseStatementsResponse = finverseWebclientService.fetchStatement(loginIdentityToken)

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
