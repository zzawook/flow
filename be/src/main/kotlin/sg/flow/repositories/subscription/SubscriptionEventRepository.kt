package sg.flow.repositories.subscription

import sg.flow.entities.SubscriptionEvent
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.repositories.Repository

interface SubscriptionEventRepository : Repository<SubscriptionEvent, Long> {
    suspend fun findByUserId(userId: Int, limit: Int = 50): List<SubscriptionEvent>
    suspend fun findByPlatform(platform: Platform, limit: Int = 100): List<SubscriptionEvent>
    suspend fun findByEventType(
            eventType: SubscriptionEventType,
            limit: Int = 100
    ): List<SubscriptionEvent>
}
