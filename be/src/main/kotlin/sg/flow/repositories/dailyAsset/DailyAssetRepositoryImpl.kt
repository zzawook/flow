package sg.flow.repositories.dailyAsset

import io.r2dbc.spi.Row
import java.time.LocalDate
import java.time.LocalDateTime
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.DailyUserAsset
import sg.flow.repositories.utils.DailyAssetQueryStore

@Repository
class DailyAssetRepositoryImpl(private val databaseClient: DatabaseClient) : DailyAssetRepository {

    private val logger = LoggerFactory.getLogger(DailyAssetRepositoryImpl::class.java)

    override suspend fun calculateAndStoreDailyAssetsForDate(date: LocalDate): Int {
        return try {
            val rowsAffected =
                    databaseClient
                            .sql(DailyAssetQueryStore.CALCULATE_AND_UPSERT_DAILY_ASSETS_FOR_DATE)
                            .bind(0, date)
                            .fetch()
                            .awaitRowsUpdated()

            logger.info(
                    "Calculated and stored daily assets for date {}: {} users processed",
                    date,
                    rowsAffected
            )
            rowsAffected.toInt()
        } catch (e: Exception) {
            logger.error("Failed to calculate daily assets for date {}", date, e)
            0
        }
    }

    override suspend fun findByUserAndDate(userId: Int, date: LocalDate): DailyUserAsset? {
        return runCatching {
                    databaseClient
                            .sql(DailyAssetQueryStore.FIND_BY_USER_AND_DATE)
                            .bind(0, userId)
                            .bind(1, date)
                            .map { row -> mapRowToDailyUserAsset(row as Row) }
                            .one()
                            .asFlow()
                            .toList()
                            .firstOrNull()
                }
                .onFailure { e ->
                    logger.error(
                            "Error fetching daily asset for user {} on date {}",
                            userId,
                            date,
                            e
                    )
                }
                .getOrNull()
    }

    override suspend fun findByUserAndDateRange(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): List<DailyUserAsset> {
        return runCatching {
            databaseClient
                    .sql(DailyAssetQueryStore.FIND_BY_USER_AND_DATE_RANGE)
                    .bind(0, userId)
                    .bind(1, startDate)
                    .bind(2, endDate)
                    .map { row -> mapRowToDailyUserAsset(row as Row) }
                    .all()
                    .asFlow()
                    .toList()
        }
                .onFailure { e ->
                    logger.error(
                            "Error fetching daily assets for user {} from {} to {}",
                            userId,
                            startDate,
                            endDate,
                            e
                    )
                }
                .getOrElse { emptyList() }
    }

    override suspend fun findUsersMissingAssetsForDate(date: LocalDate): List<Int> {
        return runCatching {
            databaseClient
                    .sql(DailyAssetQueryStore.FIND_USERS_MISSING_ASSETS_FOR_DATE)
                    .bind(0, date)
                    .map { row -> row.get("id", Int::class.java)!! }
                    .all()
                    .asFlow()
                    .toList()
        }
                .onFailure { e ->
                    logger.error("Error finding users missing assets for date {}", date, e)
                }
                .getOrElse { emptyList() }
    }

    private fun mapRowToDailyUserAsset(row: Row): DailyUserAsset {
        return DailyUserAsset(
                id = row.get("id", Long::class.java),
                userId = row.get("user_id", Int::class.java)!!,
                assetDate = row.get("asset_date", LocalDate::class.java)!!,
                totalAssetValue =
                        row.get("total_asset_value", java.math.BigDecimal::class.java)?.toDouble()
                                ?: 0.0,
                accountCount = row.get("account_count", Int::class.java)!!,
                calculatedAt = row.get("calculated_at", LocalDateTime::class.java)!!
        )
    }
}
