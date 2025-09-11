package sg.flow.services.TransactionHistoryServices

import java.time.LocalDate
import java.time.YearMonth
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.configs.RecurringSpendingProperties
import sg.flow.entities.RecurringSpendingMonthly
import sg.flow.entities.TransactionHistory
import sg.flow.repositories.recurring.RecurringSpendingRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@Service
class RecurringSpendingAnalysisService(
        private val transactionHistoryRepository: TransactionHistoryRepository,
        private val recurringSpendingRepository: RecurringSpendingRepository,
        private val properties: RecurringSpendingProperties
) {

    private val logger = LoggerFactory.getLogger(RecurringSpendingAnalysisService::class.java)

    /**
     * Analyze a user's past transactions and persist recurring spending results per month. Returns
     * the number of upserted rows.
     */
    suspend fun analyzeUser(userId: Int): Int {
        if (!properties.enabled) return 0

        val sinceDate =
                LocalDate.now().minusMonths(properties.lookbackMonths.toLong()).withDayOfMonth(1)
        val all =
                transactionHistoryRepository.findTransactionsForUserSinceDate(userId, sinceDate)
                        .filter { it.amount < 0.0 } // expenses only

        if (all.isEmpty()) return 0

        val groups = groupTransactions(all)
        val recurringGroups = groups.filterValues { isRecurring(it) }

        val recordsToUpsert = mutableListOf<RecurringSpendingMonthly>()
        val months = monthsInRange(YearMonth.from(sinceDate), YearMonth.from(LocalDate.now()))

        recurringGroups.forEach { (merchantKey, txns) ->
            val sorted = txns.sortedBy { it.transactionDate }
            val intervalDays = medianIntervalDays(sorted)
            val lastDate = sorted.last().transactionDate
            val nextDate = lastDate?.plusDays(intervalDays.toLong())
            val periodLabel = labelForInterval(intervalDays)
            val expectedAmount = medianAmount(sorted)
            val amountStddev = stdDevAmount(sorted)
            val category = dominantCategory(sorted)
            val brandName = dominantBrand(sorted)
            val displayName = brandName ?: deriveDisplayName(sorted)
            val confidence = computeConfidence(sorted, intervalDays, expectedAmount, category)
            val txnIds = sorted.mapNotNull { it.id }

            months.forEach { ym ->
                val anyInMonth =
                        sorted.any {
                            it.transactionDate?.let { d -> YearMonth.from(d) == ym } ?: false
                        }

                if (anyInMonth || properties.includeExpectedMonths) {
                    recordsToUpsert.add(
                            RecurringSpendingMonthly(
                                    id = null,
                                    userId = userId,
                                    merchantKey = merchantKey,
                                    displayName = displayName,
                                    brandName = brandName,
                                    category = category,
                                    year = ym.year,
                                    month = ym.monthValue,
                                    expectedAmount = abs(expectedAmount),
                                    amountStddev = amountStddev?.let { abs(it) },
                                    occurrenceCount = sorted.size,
                                    lastTransactionDate = lastDate,
                                    intervalDays = intervalDays,
                                    periodLabel = periodLabel,
                                    nextTransactionDate =
                                            predictedNextDateForMonth(sorted, ym, intervalDays),
                                    confidence = confidence,
                                    transactionIds = txnIds
                            )
                    )
                }
            }
        }

        if (recordsToUpsert.isEmpty()) return 0

        // Clean old rows from the same time window to avoid stale data then upsert
        val startYm = months.first()
        recurringSpendingRepository.deleteForUserFrom(userId, startYm.year, startYm.monthValue)
        return recurringSpendingRepository.upsertAll(recordsToUpsert)
    }

    private fun groupTransactions(
            all: List<TransactionHistory>
    ): Map<String, List<TransactionHistory>> {
        return all.groupBy { merchantGroupingKey(it) }
    }

    private fun merchantGroupingKey(t: TransactionHistory): String {
        val primary =
                t.brandName?.takeIf { it.isNotBlank() }
                        ?: t.friendlyDescription.takeIf { it.isNotBlank() } ?: t.description
        return normalizeKey(primary)
    }

    private fun normalizeKey(s: String?): String {
        if (s.isNullOrBlank()) return "unknown"
        val cleaned =
                s.lowercase()
                        .replace("[^a-z0-9 ]".toRegex(), " ")
                        .replace("\\s+".toRegex(), " ")
                        .trim()
        // shorten long keys to reduce accidental splits while keeping core tokens
        return cleaned.split(" ").take(6).joinToString(" ")
    }

    private fun isRecurring(list: List<TransactionHistory>): Boolean {
        if (list.size < properties.minOccurrences) return false
        val sorted = list.sortedBy { it.transactionDate }
        val interval = medianIntervalDays(sorted)
        if (interval <= 0 || interval > properties.maxPeriodDays) return false

        val withinAmount = isAmountConsistent(sorted)
        if (!withinAmount) return false

        val periodOk = isIntervalConsistent(sorted, interval)
        return periodOk
    }

    private fun isAmountConsistent(list: List<TransactionHistory>): Boolean {
        val amounts = list.map { abs(it.amount) }
        val median = median(amounts)
        val tol = properties.amountSimilarityTolerancePct
        return amounts.all { abs(it - median) / max(1.0, median) <= tol }
    }

    private fun isIntervalConsistent(
            sorted: List<TransactionHistory>,
            medianInterval: Int
    ): Boolean {
        val tolPct = properties.periodTolerancePct
        val low = (medianInterval * (1.0 - tolPct)).roundToInt()
        val high = (medianInterval * (1.0 + tolPct)).roundToInt()
        val diffs = consecutiveDiffDays(sorted)
        return diffs.all { it in low..high }
    }

    private fun consecutiveDiffDays(sorted: List<TransactionHistory>): List<Int> {
        val diffs = mutableListOf<Int>()
        for (i in 1 until sorted.size) {
            val prev = sorted[i - 1].transactionDate
            val cur = sorted[i].transactionDate
            if (prev != null && cur != null)
                    diffs.add((cur.toEpochDay() - prev.toEpochDay()).toInt())
        }
        return diffs
    }

    private fun medianIntervalDays(sorted: List<TransactionHistory>): Int {
        val diffs = consecutiveDiffDays(sorted)
        if (diffs.isEmpty()) return 0
        return medianInt(diffs)
    }

    private fun medianAmount(list: List<TransactionHistory>): Double {
        return median(list.map { it.amount })
    }

    private fun stdDevAmount(list: List<TransactionHistory>): Double? {
        val v = list.map { it.amount }
        if (v.isEmpty()) return null
        val m = v.average()
        val variance = v.map { (it - m) * (it - m) }.average()
        return kotlin.math.sqrt(variance)
    }

    private fun dominantCategory(list: List<TransactionHistory>): String? {
        val grouped =
                list
                        .mapNotNull { it.transactionCategory.takeIf { cat -> cat.isNotBlank() } }
                        .groupingBy { it }
                        .eachCount()
        if (grouped.isEmpty()) return null
        return grouped.maxByOrNull { it.value }?.key
    }

    private fun dominantBrand(list: List<TransactionHistory>): String? {
        val grouped =
                list
                        .mapNotNull { it.brandName?.takeIf { b -> b.isNotBlank() } }
                        .groupingBy { it }
                        .eachCount()
        return grouped.maxByOrNull { it.value }?.key
    }

    private fun deriveDisplayName(list: List<TransactionHistory>): String? {
        val descs =
                list.map { th ->
                    val fd = th.friendlyDescription
                    if (fd.isNotBlank()) fd else th.description
                }
        if (descs.isEmpty()) return null
        return descs.groupingBy { normalizeKey(it) }.eachCount().maxByOrNull { it.value }?.key
    }

    private fun computeConfidence(
            list: List<TransactionHistory>,
            intervalDays: Int,
            medianAmount: Double,
            category: String?
    ): Double {
        var c = properties.defaultConfidence
        val amountOk = isAmountConsistent(list)
        val intervalOk = isIntervalConsistent(list.sortedBy { it.transactionDate }, intervalDays)
        if (amountOk) c += 0.15
        if (intervalOk) c += 0.15
        if (category != null) {
            c *= properties.categoryWeights.getOrDefault(category, 1.0)
        }
        return min(0.99, c)
    }

    private fun monthsInRange(start: YearMonth, end: YearMonth): List<YearMonth> {
        val out = mutableListOf<YearMonth>()
        var cur = start
        while (!cur.isAfter(end)) {
            out.add(cur)
            cur = cur.plusMonths(1)
        }
        return out
    }

    private fun labelForInterval(intervalDays: Int): String {
        return when {
            intervalDays in 25..35 -> "MONTHLY"
            intervalDays in 55..70 -> "BI_MONTHLY"
            intervalDays in 80..100 -> "QUARTERLY"
            else -> "CUSTOM_${intervalDays}D"
        }
    }

    private fun median(values: List<Double>): Double {
        if (values.isEmpty()) return 0.0
        val s = values.sorted()
        val mid = s.size / 2
        return if (s.size % 2 == 0) (s[mid - 1] + s[mid]) / 2.0 else s[mid]
    }

    private fun medianInt(values: List<Int>): Int {
        if (values.isEmpty()) return 0
        val s = values.sorted()
        val mid = s.size / 2
        return if (s.size % 2 == 0) ((s[mid - 1] + s[mid]) / 2.0).roundToInt() else s[mid]
    }

    private fun predictedNextDateForMonth(
            sorted: List<TransactionHistory>,
            yearMonth: YearMonth,
            intervalDays: Int
    ): LocalDate? {
        if (sorted.isEmpty() || intervalDays <= 0) return null
        val base = sorted.first().transactionDate ?: return null
        // advance from base by intervalDays until we reach or pass the target yearMonth window
        var d = base
        val endOfTarget = yearMonth.atEndOfMonth()
        while (d.isBefore(endOfTarget)) {
            d = d.plusDays(intervalDays.toLong())
        }
        // If d falls inside the target month, use it; else try one step back
        return if (YearMonth.from(d) == yearMonth) d
        else {
            val prev = d.minusDays(intervalDays.toLong())
            if (YearMonth.from(prev) == yearMonth) prev else null
        }
    }
}
