package sg.flow.models.subscription

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty

@JsonIgnoreProperties(ignoreUnknown = true)
data class AppleReceiptResponse(
        val status: Int,
        val environment: String?,
        @JsonProperty("latest_receipt_info") val latestReceiptInfo: List<AppleReceiptInfo>?
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class AppleReceiptInfo(
        @JsonProperty("original_transaction_id") val originalTransactionId: String,
        @JsonProperty("product_id") val productId: String,
        @JsonProperty("expires_date_ms") val expiresDateMs: String
)

data class ReceiptValidationResult(
        val isValid: Boolean,
        val error: String? = null,
        val transactionId: String? = null,
        val productId: String? = null,
        val expiresDate: java.time.Instant? = null,
        val environment: String? = null
)
