package sg.flow.repositories.subscription

import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.repositories.Repository

interface SubscriptionRepository : Repository<UserSubscription, Long> {
    suspend fun findByUserIdAndPlatform(userId: Int, platform: Platform): UserSubscription?
    suspend fun findByUserId(userId: Int): List<UserSubscription>
    suspend fun findByIosTransactionId(transactionId: String): UserSubscription?
    suspend fun findByAndroidPurchaseToken(purchaseToken: String): UserSubscription?
    suspend fun updateSubscription(subscription: UserSubscription): Boolean
    suspend fun updateStatus(subscriptionId: Long, newStatus: String): Boolean
}
