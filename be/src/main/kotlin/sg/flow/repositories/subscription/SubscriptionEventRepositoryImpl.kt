package sg.flow.repositories.subscription

import java.time.Instant
import kotlinx.coroutines.reactive.awaitSingle
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.SubscriptionEvent
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionEventType
import sg.flow.entities.utils.SubscriptionStatus
import sg.flow.repositories.utils.SubscriptionEventQueryStore

@Repository
class SubscriptionEventRepositoryImpl(private val databaseClient: DatabaseClient) :
        SubscriptionEventRepository {

    private val logger = LoggerFactory.getLogger(SubscriptionEventRepositoryImpl::class.java)

    override suspend fun save(entity: SubscriptionEvent): SubscriptionEvent {
        return try {
            databaseClient
                    .sql(SubscriptionEventQueryStore.CREATE)
                    .bind(0, entity.userId)
                    .bind(1, entity.platform.name)
                    .bind(2, entity.eventType.name)
                    .bind(3, entity.oldStatus?.name)
                    .bind(4, entity.newStatus?.name)
                    .bind(5, entity.notificationType)
                    .bind(6, entity.transactionId)
                    .bind(7, entity.rawNotification)
                    .bind(8, entity.errorMessage)
                    .bind(9, entity.processedAt)
                    .map { row, _ -> mapRowToEvent(row) }
                    .one()
                    .awaitSingle()
        } catch (e: Exception) {
            logger.error("Failed to save subscription event for userId: ${entity.userId}", e)
            entity
        }
    }

    override suspend fun findByUserId(userId: Int, limit: Int): List<SubscriptionEvent> {
        return databaseClient
                .sql(SubscriptionEventQueryStore.FIND_BY_USER_ID)
                .bind(0, userId)
                .bind(1, limit)
                .map { row, _ -> mapRowToEvent(row) }
                .all()
                .collectList()
                .awaitSingle()
    }

    override suspend fun findByPlatform(platform: Platform, limit: Int): List<SubscriptionEvent> {
        return databaseClient
                .sql(SubscriptionEventQueryStore.FIND_BY_PLATFORM)
                .bind(0, platform.name)
                .bind(1, limit)
                .map { row, _ -> mapRowToEvent(row) }
                .all()
                .collectList()
                .awaitSingle()
    }

    override suspend fun findByEventType(
            eventType: SubscriptionEventType,
            limit: Int
    ): List<SubscriptionEvent> {
        return databaseClient
                .sql(SubscriptionEventQueryStore.FIND_BY_EVENT_TYPE)
                .bind(0, eventType.name)
                .bind(1, limit)
                .map { row, _ -> mapRowToEvent(row) }
                .all()
                .collectList()
                .awaitSingle()
    }

    override suspend fun findById(id: Long): SubscriptionEvent? {
        // Not commonly used for events
        return null
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql(SubscriptionEventQueryStore.DELETE_ALL).fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            logger.error("Failed to delete all subscription events", e)
            false
        }
    }

    private fun mapRowToEvent(row: io.r2dbc.spi.Row): SubscriptionEvent {
        val oldStatusStr = row.get("old_status", String::class.java)
        val newStatusStr = row.get("new_status", String::class.java)

        return SubscriptionEvent(
                id = row.get("id", java.lang.Long::class.java)?.toLong(),
                userId = row.get("user_id", Integer::class.java)!!.toInt(),
                platform = Platform.valueOf(row.get("platform", String::class.java)!!),
                eventType =
                        SubscriptionEventType.valueOf(row.get("event_type", String::class.java)!!),
                oldStatus = oldStatusStr?.let { SubscriptionStatus.valueOf(it) },
                newStatus = newStatusStr?.let { SubscriptionStatus.valueOf(it) },
                notificationType = row.get("notification_type", String::class.java),
                transactionId = row.get("transaction_id", String::class.java),
                rawNotification = row.get("raw_notification", String::class.java) ?: "{}",
                errorMessage = row.get("error_message", String::class.java),
                processedAt = row.get("processed_at", Instant::class.java) ?: Instant.now()
        )
    }
}
