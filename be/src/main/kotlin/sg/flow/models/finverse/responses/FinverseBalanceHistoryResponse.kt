package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import java.time.LocalDateTime

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseBalanceHistoryResponse(
        @JsonProperty("balance_history") val balanceHistory: List<FinverseBalanceHistoryData>? = null,
        @JsonProperty("account_id") val accountId: String? = null
) : FinverseProductResponse()

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseBalanceHistoryData(
        @JsonProperty("date") val date: LocalDate,
        @JsonProperty("amount") val amount: Double,
        @JsonProperty("currency") val currency: String,
)
