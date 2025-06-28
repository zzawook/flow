package sg.flow.models.finverse

import org.springframework.web.reactive.function.client.WebClient
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataIngest

enum class FinverseProduct(
    val productName: String,
    val apiEndpoint: String,
) {
    ACCOUNTS("ACCOUNTS", "accounts"),
    ACCOUNT_NUMBERS("ACCOUNT_NUMBERS", "account_numbers"),
    ONLINE_TRANSACTIONS("ONLINE_TRANSACTIONS", "transactions"),
    HISTORICAL_TRANSACTIONS("HISTORICAL_TRANSACTIONS", "transactions"),
    IDENTITY("IDENTITY", "identity"),
    BALANCE_HISTORY("BALANCE_HISTORY", "balance_history"),
    INCOME_ESTIMATION("INCOME_ESTIMATION", "income"),
    STATEMENTS("STATEMENTS", "statements");

    fun fetch(loginIdentityId: String, finverseDataIngestor: FinverseDataIngest, finverseWebclient: WebClient) {
        finverseWebclient.get()
        .uri("/api/v1/products/$apiEndpoint/$loginIdentityId")
    }


}
