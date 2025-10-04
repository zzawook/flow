package sg.flow.repositories.spendingMedian

import io.r2dbc.spi.Row
import java.time.LocalDateTime
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.SpendingMedianByAgeGroup
import sg.flow.repositories.utils.SpendingMedianQueryStore

@Repository
class SpendingMedianRepositoryImpl(private val databaseClient: DatabaseClient) :
        SpendingMedianRepository {

    private val logger = LoggerFactory.getLogger(SpendingMedianRepositoryImpl::class.java)

    override suspend fun findByAgeGroupAndYearMonth(
            ageGroup: String,
            year: Int,
            month: Int
    ): SpendingMedianByAgeGroup? {
        return runCatching {
                    databaseClient
                            .sql(SpendingMedianQueryStore.FIND_BY_AGE_GROUP_AND_YEAR_MONTH)
                            .bind(0, ageGroup)
                            .bind(1, year)
                            .bind(2, month)
                            .map { row -> mapRowToSpendingMedian(row as Row) }
                            .one()
                            .asFlow()
                            .toList()
                            .firstOrNull()
                }
                .onFailure { e ->
                    logger.error(
                            "Error fetching spending median for age group {} year {} month {}",
                            ageGroup,
                            year,
                            month,
                            e
                    )
                }
                .getOrNull()
    }

    override suspend fun upsertMedian(
            ageGroup: String,
            year: Int,
            month: Int,
            medianSpending: Double,
            userCount: Int,
            transactionCount: Int
    ): Int {
        return try {
            databaseClient
                    .sql(SpendingMedianQueryStore.UPSERT_MEDIAN)
                    .bind(0, ageGroup)
                    .bind(1, year)
                    .bind(2, month)
                    .bind(3, medianSpending)
                    .bind(4, userCount)
                    .bind(5, transactionCount)
                    .fetch()
                    .awaitRowsUpdated()
                    .toInt()
        } catch (e: Exception) {
            logger.error(
                    "Failed to upsert spending median for age group {} year {} month {}",
                    ageGroup,
                    year,
                    month,
                    e
            )
            0
        }
    }

    override suspend fun findMissingMonths(
            startYear: Int,
            startMonth: Int,
            endYear: Int,
            endMonth: Int
    ): List<Pair<Int, Int>> {
        return runCatching {
            databaseClient
                    .sql(SpendingMedianQueryStore.FIND_MISSING_MONTHS)
                    .bind(0, startYear)
                    .bind(1, startMonth)
                    .bind(2, endYear)
                    .bind(3, endMonth)
                    .map { row ->
                        val year = row.get("year", Int::class.java)!!
                        val month = row.get("month", Int::class.java)!!
                        Pair(year, month)
                    }
                    .all()
                    .asFlow()
                    .toList()
        }
                .onFailure { e -> logger.error("Error finding missing months", e) }
                .getOrElse { emptyList() }
    }

    override suspend fun calculateAndStoreMediansForMonth(year: Int, month: Int): Int {
        return try {
            // Execute the complex query to calculate medians for all age groups
            val results =
                    databaseClient
                            .sql(SpendingMedianQueryStore.CALCULATE_MEDIANS_FOR_MONTH)
                            .bind(0, year)
                            .bind(1, month)
                            .map { row ->
                                Triple(
                                        row.get("age_group", String::class.java)!!,
                                        row.get("median_spending", java.math.BigDecimal::class.java)
                                                ?.toDouble()
                                                ?: 0.0,
                                        Triple(
                                                row.get("user_count", java.lang.Long::class.java)
                                                        ?.toInt()
                                                        ?: 0,
                                                row.get(
                                                                "transaction_count",
                                                                java.lang.Long::class.java
                                                        )
                                                        ?.toInt()
                                                        ?: 0,
                                                row.get(
                                                                "median_spending",
                                                                java.math.BigDecimal::class.java
                                                        )
                                                        ?.toDouble()
                                                        ?: 0.0
                                        )
                                )
                            }
                            .all()
                            .asFlow()
                            .toList()

            // Now upsert each result
            var totalUpserted = 0
            results.forEach { (ageGroup, medianSpending, counts) ->
                val (userCount, txCount, _) = counts
                val upserted =
                        upsertMedian(ageGroup, year, month, medianSpending, userCount, txCount)
                totalUpserted += upserted
            }

            logger.info(
                    "Calculated and stored medians for {}-{}: {} age groups processed",
                    year,
                    month,
                    totalUpserted
            )
            totalUpserted
        } catch (e: Exception) {
            logger.error("Failed to calculate medians for year {} month {}", year, month, e)
            0
        }
    }

    private fun mapRowToSpendingMedian(row: Row): SpendingMedianByAgeGroup {
        return SpendingMedianByAgeGroup(
                id = row.get("id", Long::class.java),
                ageGroup = row.get("age_group", String::class.java)!!,
                year = row.get("year", Int::class.java)!!,
                month = row.get("month", Int::class.java)!!,
                medianSpending =
                        row.get("median_spending", java.math.BigDecimal::class.java)?.toDouble()
                                ?: 0.0,
                userCount = row.get("user_count", Int::class.java)!!,
                transactionCount = row.get("transaction_count", Int::class.java)!!,
                calculatedAt = row.get("calculated_at", LocalDateTime::class.java)!!
        )
    }
}
