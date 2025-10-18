package sg.flow.entities

import java.time.Instant
import org.springframework.data.annotation.Id
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionStatus

data class UserSubscription(
        @field:Id val id: Long?,
        val userId: Int,
        val platform: Platform,
        val subscriptionStatus: SubscriptionStatus,

        // Trial period tracking
        val trialStartDate: Instant?,
        val trialEndDate: Instant?,

        // Active subscription period
        val currentPeriodStart: Instant?,
        val currentPeriodEnd: Instant?,
        val autoRenewing: Boolean = true,

        // EXPIRED status metadata
        val expiredAt: Instant?,
        val expirationReason: String?,

        // CANCELED status metadata
        val canceledAt: Instant?,
        val cancellationReason: String?,

        // iOS-specific fields
        val iosOriginalTransactionId: String?,
        val iosProductId: String?,
        val iosEnvironment: String?,

        // Android-specific fields
        val androidPurchaseToken: String?,
        val androidProductId: String?,
        val androidOrderId: String?,

        // Metadata
        val createdAt: Instant = Instant.now(),
        val updatedAt: Instant = Instant.now()
)
