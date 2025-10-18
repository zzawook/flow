package sg.flow.services.SubscriptionServices

import java.time.Instant
import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType

interface SubscriptionService {
    suspend fun startTrial(userId: Int, platform: Platform): TrialStartResult
    suspend fun linkPurchase(
            userId: Int,
            platform: Platform,
            purchaseData: PurchaseData
    ): LinkPurchaseResult
    suspend fun handleSubscriptionEvent(
            userId: Int,
            platform: Platform,
            eventType: SubscriptionEventType,
            eventData: Map<String, Any>
    )
    suspend fun getSubscriptionStatus(userId: Int, platform: Platform): UserSubscription?
}

sealed class TrialStartResult {
    data class Success(val trialEndDate: Instant) : TrialStartResult()
    data class AlreadyUsed(
            val message: String,
            val firstUsedDate: Instant,
            val platform: Platform
    ) : TrialStartResult()
    data class AlreadySubscribed(val message: String) : TrialStartResult()
}

data class PurchaseData(
        val platform: Platform,
        val expiresDate: Instant,
        val originalTransactionId: String?,
        val productId: String,
        val purchaseToken: String? = null,
        val orderId: String? = null
)

sealed class LinkPurchaseResult {
    data class Success(val subscription: UserSubscription) : LinkPurchaseResult()
    data class Failure(val message: String) : LinkPurchaseResult()
}
