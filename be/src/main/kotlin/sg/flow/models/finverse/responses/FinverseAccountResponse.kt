package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDateTime

data class FinverseAccountResponse(
        @JsonProperty("accounts") val accounts: List<FinverseAccountData>? = null
) : FinverseProductResponse()

data class FinverseAccountData(
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("account_number") val accountNumber: String,
        @JsonProperty("account_name") val accountName: String,
        @JsonProperty("account_type") val accountType: String,
        @JsonProperty("balance") val balance: Double,
        @JsonProperty("available_balance") val availableBalance: Double? = null,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("institution_id") val institutionId: String,
        @JsonProperty("institution_name") val institutionName: String,
        @JsonProperty("bank_code") val bankCode: String? = null,
        @JsonProperty("interest_rate") val interestRate: Double? = null,
        @JsonProperty("last_updated") val lastUpdated: LocalDateTime? = null,
        @JsonProperty("status") val status: String? = null,
        @JsonProperty("product_type") val productType: String? = null,
        @JsonProperty("nickname") val nickname: String? = null
)
