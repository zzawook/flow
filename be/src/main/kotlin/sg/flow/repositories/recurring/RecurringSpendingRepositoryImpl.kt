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
                                .bind(2, rec.sequenceKey)
                                .bind(3, rec.displayName)
                                .bind(4, rec.brandName)
                                .bind(5, rec.category)
                                .bind(6, rec.year)
                                .bind(7, rec.month)
                                .bind(8, rec.expectedAmount)
                                .bind(9, rec.amountStddev)
                                .bind(10, rec.occurrenceCount)
                                .let { s ->
                                    rec.lastTransactionDate?.let { s.bind(11, it) }
                                            ?: s.bindNull(11, java.time.LocalDate::class.java)
                                }
                                .let { s ->
                                    rec.intervalDays?.let { s.bind(12, it) }
                                            ?: s.bindNull(12, Int::class.java)
                                }
                                .bind(13, rec.periodLabel)
                                .let { s ->
                                    rec.nextTransactionDate?.let { s.bind(14, it) }
                                            ?: s.bindNull(14, java.time.LocalDate::class.java)
                                }
                                .bind(15, rec.confidence)
                                .let { s ->
                                    val arr: Array<Long>? = rec.transactionIds?.toTypedArray()
                                    if (arr != null) s.bind(16, arr)
                                    else s.bindNull(16, Array<Long>::class.java)
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
