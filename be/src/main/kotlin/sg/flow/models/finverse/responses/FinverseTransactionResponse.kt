package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime

data class FinverseTransactionResponse(
        @JsonProperty("transactions") val transactions: List<FinverseTransactionData>? = null,
        @JsonProperty("account_id") val accountId: String? = null,
        @JsonProperty("has_more") val hasMore: Boolean? = null,
        @JsonProperty("next_cursor") val nextCursor: String? = null
) : FinverseProductResponse()

data class FinverseTransactionData(
        @JsonProperty("transaction_id") val transactionId: String,
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("amount") val amount: Double,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("date") val date: LocalDate,
        @JsonProperty("time") val time: LocalTime? = null,
        @JsonProperty("datetime") val datetime: LocalDateTime? = null,
        @JsonProperty("description") val description: String,
        @JsonProperty("transaction_type") val transactionType: String,
        @JsonProperty("transaction_category") val transactionCategory: String? = null,
        @JsonProperty("merchant_name") val merchantName: String? = null,
        @JsonProperty("reference") val reference: String? = null,
        @JsonProperty("status") val status: String,
        @JsonProperty("balance_after") val balanceAfter: Double? = null,
        @JsonProperty("running_balance") val runningBalance: Double? = null,
        @JsonProperty("posted_date") val postedDate: LocalDate? = null,
        @JsonProperty("card_number") val cardNumber: String? = null,
        @JsonProperty("location") val location: String? = null,
        @JsonProperty("tags") val tags: List<String>? = null
)
