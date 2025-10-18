package sg.flow.services.SubscriptionServices

import java.time.Instant
import sg.flow.entities.utils.Platform

interface SubscriptionEntitlementService {
    suspend fun checkEntitlement(userId: Int, platform: Platform): EntitlementResult
    suspend fun hasActiveAccess(userId: Int, platform: Platform): Boolean
    suspend fun invalidateCache(userId: Int, platform: Platform)
}

sealed class EntitlementResult {
    data class ActiveTrial(val expiresAt: Instant) : EntitlementResult()
    data class ActiveSubscription(val expiresAt: Instant) : EntitlementResult()
    data class ActiveButCanceled(val accessUntil: Instant) : EntitlementResult()
    object Expired : EntitlementResult()
    object NoSubscription : EntitlementResult()

    fun hasAccess(): Boolean =
            when (this) {
                is ActiveTrial, is ActiveSubscription, is ActiveButCanceled -> true
                is Expired, is NoSubscription -> false
            }

    fun getStatus(): String =
            when (this) {
                is ActiveTrial -> "TRIAL"
                is ActiveSubscription -> "ACTIVE"
                is ActiveButCanceled -> "CANCELED"
                is Expired -> "EXPIRED"
                is NoSubscription -> "NO_SUBSCRIPTION"
            }

    fun getExpirationTime(): Instant? =
            when (this) {
                is ActiveTrial -> expiresAt
                is ActiveSubscription -> expiresAt
                is ActiveButCanceled -> accessUntil
                else -> null
            }
}
