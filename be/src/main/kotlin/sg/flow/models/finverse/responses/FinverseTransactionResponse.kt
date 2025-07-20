package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseTransactionResponse(
        @JsonProperty("transactions") val transactions: List<FinverseTransactionData>
) : FinverseProductResponse()

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseTransactionData(
        @JsonProperty("transaction_id") val transactionId: String,
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("amount") val amount: FinverseTransactionAmount,
        @JsonProperty("transaction_date") val transactionDate: LocalDate?,
        @JsonProperty("transaction_time") val transactionTime: LocalDateTime? = null,
        @JsonProperty("datetime") val datetime: LocalDateTime? = null,
        @JsonProperty("description") val description: String,
        @JsonProperty("transaction_reference") val reference: String? = null,
        @JsonProperty("is_pending") val isPending: Boolean,
        @JsonProperty("posted_date") val postedDate: LocalDate? = null,
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseTransactionAmount(
        @JsonProperty("raw") val raw: String,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("value") val value: Double,
)
