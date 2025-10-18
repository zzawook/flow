package sg.flow.entities

import java.time.Instant
import org.springframework.data.annotation.Id
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.entities.utils.SubscriptionStatus

data class SubscriptionEvent(
        @field:Id val id: Long?,
        val userId: Int,
        val platform: Platform,
        val eventType: SubscriptionEventType,
        val oldStatus: SubscriptionStatus?,
        val newStatus: SubscriptionStatus?,
        val notificationType: String?,
        val transactionId: String?,
        val rawNotification: String,
        val errorMessage: String?,
        val processedAt: Instant = Instant.now()
)
