package sg.flow.models.subscription

data class PurchaseValidationResult(
        val isValid: Boolean,
        val error: String? = null,
        val productId: String? = null,
        val expiresDate: java.time.Instant? = null,
        val orderId: String? = null
)
