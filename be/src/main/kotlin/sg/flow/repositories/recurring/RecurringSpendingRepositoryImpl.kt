package sg.flow.repositories.recurring

import io.r2dbc.spi.Row
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.RecurringSpendingMonthly
import sg.flow.repositories.utils.RecurringSpendingQueryStore
import sg.flow.repositories.utils.TransactionHistoryQueryStore
import java.time.LocalDate

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
                                .bind(17, rec.brandDomain)
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

    override suspend fun findRecurringTransactionsForUserId(userId: Int): List<RecurringSpendingMonthly> {
        return runCatching {
            databaseClient.sql(RecurringSpendingQueryStore.FIND_RECURRING_TRANSACTIONS_FOR_USER)
                .bind(0, userId)
                .map {row -> mapRowToRecurringSpendingMonthly(row as Row)}
                .all()
                .asFlow()
                .toList()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error(
                    "Error fetching recurring transaction for user ID $userId"
                )
            }
            .getOrElse { emptyList() }
    }

    private fun mapRowToRecurringSpendingMonthly(row: Row) : RecurringSpendingMonthly {
        val recurringSpending = RecurringSpendingMonthly(
            id = row.get("id", Long::class.java) ?: -1L,
            userId = row.get("user_id", Int::class.java)!!,
            merchantKey = row.get("merchant_key", String::class.java)!!,
            sequenceKey = row.get("sequence_key", String::class.java)!!,
            displayName = row.get("display_name", String::class.java) ?: "",
            brandName = row.get("brand_name", String::class.java) ?: "",
            brandDomain = row.get("brand_domain", String::class.java),
            category = row.get("category", String::class.java)!!,
            year = row.get("year", Int::class.java)!!,
            month = row.get("month", Int::class.java)!!,
            expectedAmount = row.get("expected_amount", Double::class.java)!!,
            amountStddev = row.get("amount_stddev", Double::class.java) ?: 0.0,
            occurrenceCount = row.get("occurrence_count", Int::class.java)!!,
            lastTransactionDate = row.get("last_transaction_date", LocalDate::class.java) ?: LocalDate.MIN,
            intervalDays = row.get("interval_days", Int::class.java) ?: -1,
            periodLabel = row.get("period_label", String::class.java) ?: "",
            confidence = row.get("confidence", Double::class.java)!!,
            nextTransactionDate = row.get("next_transaction_date", LocalDate::class.java) ?: LocalDate.MIN,
            transactionIds = row.get("transaction_ids", Array<Long>::class.java)?.toList().orEmpty(),
        )
        return recurringSpending
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
