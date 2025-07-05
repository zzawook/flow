package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import java.time.LocalDateTime

data class FinverseBalanceHistoryResponse(
        @JsonProperty("balance_history")
        val balanceHistory: List<FinverseBalanceHistoryData>? = null,
        @JsonProperty("account_id") val accountId: String? = null
) : FinverseProductResponse()

data class FinverseBalanceHistoryData(
        @JsonProperty("date") val date: LocalDate,
        @JsonProperty("datetime") val datetime: LocalDateTime? = null,
        @JsonProperty("balance") val balance: Double,
        @JsonProperty("available_balance") val availableBalance: Double? = null,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("account_id") val accountId: String? = null,
        @JsonProperty("period_type") val periodType: String? = null
)
