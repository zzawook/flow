package sg.flow.repositories.trial

import java.time.Instant
import kotlinx.coroutines.reactive.awaitFirstOrNull
import kotlinx.coroutines.reactive.awaitSingle
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.TrialUsageTracking
import sg.flow.entities.utils.Platform
import sg.flow.repositories.utils.TrialTrackingQueryStore

@Repository
class TrialTrackingRepositoryImpl(private val databaseClient: DatabaseClient) :
        TrialTrackingRepository {

    private val logger = LoggerFactory.getLogger(TrialTrackingRepositoryImpl::class.java)

    override suspend fun findByEmail(email: String): TrialUsageTracking? {
        return databaseClient
                .sql(TrialTrackingQueryStore.FIND_BY_EMAIL)
                .bind(0, email)
                .map { row, _ -> mapRowToTrialTracking(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun findByUserId(userId: Int): TrialUsageTracking? {
        return databaseClient
                .sql(TrialTrackingQueryStore.FIND_BY_USER_ID)
                .bind(0, userId)
                .map { row, _ -> mapRowToTrialTracking(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun hasEmailUsedTrial(email: String): Boolean {
        val count =
                databaseClient
                        .sql(TrialTrackingQueryStore.CHECK_EMAIL_EXISTS)
                        .bind(0, email)
                        .map { row -> row.get("count", java.lang.Long::class.java)?.toLong() ?: 0L }
                        .one()
                        .awaitFirstOrNull()
                        ?: 0L

        return count > 0
    }

    override suspend fun save(entity: TrialUsageTracking): TrialUsageTracking {
        return try {
            databaseClient
                    .sql(TrialTrackingQueryStore.CREATE)
                    .bind(0, entity.email)
                    .bind(1, entity.platform.name)
                    .bind(2, entity.firstTrialStartedAt)
                    .bind(3, entity.userId ?: 0)
                    .bind(4, entity.createdAt)
                    .map { row, _ -> mapRowToTrialTracking(row) }
                    .one()
                    .awaitSingle()
        } catch (e: Exception) {
            logger.error("Failed to save trial tracking for email: ${entity.email}", e)
            entity
        }
    }

    override suspend fun findById(id: Long): TrialUsageTracking? {
        // Not commonly used for trial tracking
        return null
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql(TrialTrackingQueryStore.DELETE_ALL).fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            logger.error("Failed to delete all trial tracking records", e)
            false
        }
    }

    private fun mapRowToTrialTracking(row: io.r2dbc.spi.Row): TrialUsageTracking {
        return TrialUsageTracking(
                id = row.get("id", java.lang.Long::class.java)?.toLong(),
                email = row.get("email", String::class.java)!!,
                platform = Platform.valueOf(row.get("platform", String::class.java)!!),
                firstTrialStartedAt = row.get("first_trial_started_at", Instant::class.java)!!,
                userId = row.get("user_id", Integer::class.java)?.toInt(),
                createdAt = row.get("created_at", Instant::class.java) ?: Instant.now()
        )
    }
}
