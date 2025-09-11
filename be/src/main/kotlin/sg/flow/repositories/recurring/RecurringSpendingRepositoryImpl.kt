package sg.flow.repositories.recurring

import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.RecurringSpendingMonthly

@Repository
class RecurringSpendingRepositoryImpl(private val databaseClient: DatabaseClient) :
        RecurringSpendingRepository {

    private val logger = LoggerFactory.getLogger(RecurringSpendingRepositoryImpl::class.java)

    override suspend fun upsertAll(records: List<RecurringSpendingMonthly>): Int {
        if (records.isEmpty()) return 0

        var total = 0
        records.chunked(50).forEach { batch ->
            batch.forEach { rec ->
                val rows =
                        databaseClient
                                .sql(RecurringSpendingQueryStore.UPSERT_RECURRING_SPENDING_MONTHLY)
                                .bind(0, rec.userId)
                                .bind(1, rec.merchantKey)
                                .bind(2, rec.displayName)
                                .bind(3, rec.brandName)
                                .bind(4, rec.category)
                                .bind(5, rec.year)
                                .bind(6, rec.month)
                                .bind(7, rec.expectedAmount)
                                .bind(8, rec.amountStddev)
                                .bind(9, rec.occurrenceCount)
                                .let { s ->
                                    rec.lastTransactionDate?.let { s.bind(10, it) }
                                            ?: s.bindNull(10, java.time.LocalDate::class.java)
                                }
                                .let { s ->
                                    rec.intervalDays?.let { s.bind(11, it) }
                                            ?: s.bindNull(11, Int::class.java)
                                }
                                .bind(12, rec.periodLabel)
                                .let { s ->
                                    rec.nextTransactionDate?.let { s.bind(13, it) }
                                            ?: s.bindNull(13, java.time.LocalDate::class.java)
                                }
                                .bind(14, rec.confidence)
                                .let { s ->
                                    val arr: Array<Long>? = rec.transactionIds?.toTypedArray()
                                    if (arr != null) s.bind(15, arr)
                                    else s.bindNull(15, Array<Long>::class.java)
                                }
                                .fetch()
                                .awaitRowsUpdated()

                total += rows.toInt()
            }
        }
        return total
    }

    override suspend fun deleteForUserFrom(userId: Int, startYear: Int, startMonth: Int): Boolean {
        return try {
            databaseClient
                    .sql(RecurringSpendingQueryStore.DELETE_FOR_USER_MONTH_RANGE)
                    .bind(0, userId)
                    .bind(1, startYear)
                    .bind(2, startMonth)
                    .fetch()
                    .awaitRowsUpdated()
            true
        } catch (e: Exception) {
            logger.error(
                    "Failed to delete recurring spending for user {} from {}-{}",
                    userId,
                    startYear,
                    startMonth,
                    e
            )
            false
        }
    }
}
