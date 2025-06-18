package sg.flow.models.finverse

import org.springframework.web.reactive.function.client.WebClient
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataIngest

enum class FinverseProduct(
    val productName: String,
    val apiEndpoint: String,
) {
    ACCOUNTS("ACCOUNTS", "/accounts"),
    ACCOUNT_NUMBERS("ACCOUNT_NUMBERS", "Account Numbers"),
    TRANSACTIONS("TRANSACTIONS", "Transactions"),
    IDENTITY("IDENTITY", "Identity"),
    BALANCE_HISTORY("BALANCE_HISTORY", "Balance History"),
    INCOME_ESTIMATION("INCOME_ESTIMATION", "Income Estimation"),
    STATEMENTS("STATEMENTS", "Statements");

    fun fetch(loginIdentityId: String, finverseDataIngestor: FinverseDataIngest, finverseWebclient: WebClient) {
        finverseWebclient.get()
        .uri("/api/v1/products/$productName/$loginIdentityId")
    }
}
