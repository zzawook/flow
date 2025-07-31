package sg.flow.models.transaction

import com.fasterxml.jackson.annotation.JsonProperty

data class BedrockAnalysisResponse(val results: List<BedrockTransactionResult>)

data class BedrockTransactionResult(
        @JsonProperty("transaction_id") val transactionId: Long,
        @JsonProperty("category") val category: String?,
        @JsonProperty("friendly_description") val friendlyDescription: String?,
        @JsonProperty("extracted_card_number") val extractedCardNumber: String?,
        @JsonProperty("revised_transaction_date") val revisedTransactionDate: String?,
        @JsonProperty("confidence") val confidence: Double = 0.0
)
