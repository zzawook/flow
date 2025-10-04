package sg.flow.services.TransactionHistoryServices

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import java.time.LocalDate
import java.time.YearMonth
import kotlin.math.abs
import kotlin.math.max
import kotlin.math.min
import kotlin.math.roundToInt
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import sg.flow.configs.RecurringSpendingProperties
import sg.flow.entities.RecurringSpendingMonthly
import sg.flow.entities.TransactionHistory
import sg.flow.repositories.recurring.RecurringSpendingRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.repositories.user.UserRepository

@Service
class RecurringSpendingAnalysisService(
        private val transactionHistoryRepository: TransactionHistoryRepository,
        private val recurringSpendingRepository: RecurringSpendingRepository,
        private val userRepository: UserRepository,
        private val properties: RecurringSpendingProperties
) {

    private val logger = LoggerFactory.getLogger(RecurringSpendingAnalysisService::class.java)

    @Scheduled(cron = "0 0 0 * *")
    fun analyzeAllUsers() {
        val userIds = userRepository.getAllUserIds()
        for (userId in userIds) {
            CoroutineScope(Dispatchers.Default).launch {
                analyzeUser(userId)
            }
        }
    }

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
        val recordsToUpsert = mutableListOf<RecurringSpendingMonthly>()
        val months = monthsInRange(YearMonth.from(sinceDate), YearMonth.from(LocalDate.now()))

        groups.forEach { (merchantKey, txns) ->
            val bands = bandTransactionsByAmount(txns)
            bands.forEach { band ->
                val sorted = band.sortedBy { it.transactionDate }
                val sequences = extractSequences(sorted)

                sequences.forEach { seq ->
                    months.forEach { ym ->
                        val anyInMonth = seq.txns.any { YearMonth.from(it.transactionDate) == ym }
                        if (anyInMonth || properties.includeExpectedMonths) {
                            recordsToUpsert.add(
                                RecurringSpendingMonthly(
                                        id = null,
                                        userId = userId,
                                        merchantKey = merchantKey,
                                        sequenceKey = seq.sequenceKey,
                                        displayName = seq.displayName,
                                        brandName = seq.brandName,
                                        brandDomain = seq.brandDomain,
                                        category = seq.category,
                                        year = ym.year,
                                        month = ym.monthValue,
                                        expectedAmount = abs(seq.expectedAmount),
                                        amountStddev = seq.amountStddev?.let { abs(it) },
                                        occurrenceCount = seq.txns.size,
                                        lastTransactionDate = seq.lastDate,
                                        intervalDays = seq.intervalDays,
                                        periodLabel = labelForInterval(seq.intervalDays),
                                        nextTransactionDate = predictedNextDateForMonth(seq.txns, ym, seq.intervalDays),
                                        confidence = seq.confidence,
                                        transactionIds = seq.txns.mapNotNull { it.id }
                                )
                            )
                        }
                    }
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

    private fun consecutiveDiffDays(sorted: List<TransactionHistory>): List<Int> {
        val diffs = mutableListOf<Int>()
        for (i in 1 until sorted.size) {
            val prev = sorted[i - 1].transactionDate
            val cur = sorted[i].transactionDate
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

    private fun dominantBrandDomain(list: List<TransactionHistory>): String? {
        val grouped =
                list
                        .mapNotNull { it.brandDomain?.takeIf { d -> d.isNotBlank() } }
                        .groupingBy { it }
                        .eachCount()
        return grouped.maxByOrNull { it.value }?.key
    }

    private fun deriveDisplayName(list: List<TransactionHistory>): String? {
        val descs =
                list.map { th ->
                    val fd = th.friendlyDescription
                    fd.ifBlank { th.description }
                }
        if (descs.isEmpty()) return null
        return descs.groupingBy { normalizeKey(it) }.eachCount().maxByOrNull { it.value }?.key
    }

    private fun computeCompositeConfidence(
        txns: List<TransactionHistory>,
        intervalDays: Int,
        category: String?
    ): Double {
        val amounts = txns.map { abs(it.amount) }
        val mean = amounts.average().takeIf { !it.isNaN() && it > 0 } ?: return 0.0
        val std = kotlin.math.sqrt(amounts.map { (it - mean) * (it - mean) }.average())
        val cv = std / mean
        val amountScore = kotlin.math.exp(-properties.alphaAmountTightness * cv).coerceIn(0.0, 1.0)

        val deltas = consecutiveDiffDays(txns.sortedBy { it.transactionDate })
        val medInt = if (intervalDays > 0) intervalDays else medianInt(deltas)
        val mad = median(deltas.map { abs(it - medInt).toDouble() })
        val rmad = if (medInt > 0) mad / medInt else Double.MAX_VALUE
        var periodScore = kotlin.math.exp(-properties.betaPeriodRegularity * rmad).coerceIn(0.0, 1.0)
        if (properties.canonicalPeriods.any { abs(medInt - it) <= (it * 0.1).roundToInt() }) {
            periodScore = (periodScore + properties.canonicalBoost).coerceAtMost(1.0)
        }

        val n = txns.size
        val occScore = if (n < properties.minOccurrences) 0.0 else 1 - kotlin.math.exp(-properties.gammaOccurrenceSaturation * (n - properties.minOccurrences))

        val lastDate = txns.maxOfOrNull { it.transactionDate } ?: LocalDate.MIN
        val expectedNext = if (lastDate != LocalDate.MIN && medInt > 0) lastDate.plusDays(medInt.toLong()) else null
        val overdueDays = expectedNext?.let { d -> max(0L, LocalDate.now().toEpochDay() - d.toEpochDay()) } ?: 0L
        val recencyScore = kotlin.math.exp(-properties.deltaRecencyDecay * (overdueDays.toDouble() / max(1.0, medInt.toDouble())))

        val observedMonths = txns.mapNotNull { it.transactionDate?.let { d -> YearMonth.from(d) } }.toSet()
        val start = txns.minOfOrNull { it.transactionDate } ?: LocalDate.now()
        val startYm = YearMonth.from(start)
        val endYm = YearMonth.from(lastDate)
        val expectedMonths = monthsInRange(startYm, endYm).toSet()
        val alignScore = if (expectedMonths.isEmpty()) 0.0 else observedMonths.intersect(expectedMonths).size.toDouble() / expectedMonths.size

        val wA = properties.weightAmount
        val wP = properties.weightPeriod
        val wO = properties.weightOccurrences
        val wR = properties.weightRecency
        val wX = properties.weightAlignment
        val base = (wA * amountScore + wP * periodScore + wO * occScore + wR * recencyScore + wX * alignScore).coerceIn(0.0, 1.0)
        val catW = category?.let { properties.categoryWeights.getOrDefault(it, 1.0) } ?: 1.0
        return (base * catW).coerceAtMost(0.99)
    }

    private data class SequenceCandidate(
        val txns: List<TransactionHistory>,
        val intervalDays: Int,
        val expectedAmount: Double,
        val amountStddev: Double?,
        val category: String?,
        val brandName: String?,
        val brandDomain: String?,
        val displayName: String?,
        val lastDate: LocalDate?,
        val confidence: Double,
        val sequenceKey: String
    )

    private fun extractSequences(sorted: List<TransactionHistory>): List<SequenceCandidate> {
        val results = mutableListOf<SequenceCandidate>()
        var remaining = sorted
        var count = 0
        while (remaining.size >= properties.minOccurrences && count < properties.maxSequencesPerGroup) {
            val candidate = fitOneSequence(remaining)
            if (candidate == null || candidate.confidence < properties.confidenceThreshold) break
            results.add(candidate)
            val ids = candidate.txns.mapNotNull { it.id }.toSet()
            remaining = remaining.filter { it.id !in ids }
            count++
            if (!properties.enableMultiPattern) break
        }
        return results
    }

    private fun fitOneSequence(sorted: List<TransactionHistory>): SequenceCandidate? {
        if (sorted.size < properties.minOccurrences) return null
        val base = sorted.sortedBy { it.transactionDate }
        val medInt = medianIntervalDays(base)
        if (medInt < properties.minPeriodDays || medInt > properties.maxPeriodDays) return null
        val trimmed = trimByIntervalMad(base, medInt)
        if (trimmed.size < properties.minOccurrences) return null
        val subseq = longestConsistentSubsequence(trimmed, medInt)
        if (subseq.size < properties.minOccurrences) return null
        val expectedAmount = medianAmount(subseq)
        val amountStddev = stdDevAmount(subseq)
        val category = dominantCategory(subseq)
        val brand = dominantBrand(subseq)
        val brandDomain = dominantBrandDomain(subseq)
        val display = brand ?: deriveDisplayName(subseq)
        val conf = computeCompositeConfidence(subseq, medInt, category)
        val lastDate = subseq.last().transactionDate
        val seqKey = makeSequenceKey(subseq, medInt)
        return SequenceCandidate(subseq, medInt, expectedAmount, amountStddev, category, brand, brandDomain, display, lastDate, conf, seqKey)
    }

    private fun trimByIntervalMad(list: List<TransactionHistory>, medianInterval: Int): List<TransactionHistory> {
        val deltas = consecutiveDiffDays(list)
        if (deltas.isEmpty()) return list
        val mad = median(deltas.map { abs(it - medianInterval).toDouble() })
        val tol = properties.intervalMadMultiplier * mad
        if (mad == 0.0) return list
        val kept = mutableListOf<TransactionHistory>()
        kept.add(list.first())
        for (i in 1 until list.size) {
            val diff = (list[i].transactionDate.toEpochDay() - list[i - 1].transactionDate.toEpochDay()).toInt()
            if (abs(diff - medianInterval) <= tol) kept.add(list[i])
        }
        return if (kept.size >= properties.minOccurrences) kept else list
    }

    private fun longestConsistentSubsequence(list: List<TransactionHistory>, medianInterval: Int): List<TransactionHistory> {
        if (list.isEmpty()) return list
        val tol = max(1.0, properties.intervalMadMultiplier).toDouble()
        val acc = mutableListOf<TransactionHistory>()
        var last: TransactionHistory? = null
        list.forEach { t ->
            if (last == null) {
                acc.add(t)
                last = t
            } else {
                val diff = (t.transactionDate.toEpochDay() - last.transactionDate.toEpochDay()).toInt()
                if (abs(diff - medianInterval) <= max(tol, medianInterval * 0.15)) {
                    acc.add(t)
                    last = t
                }
            }
        }
        return acc
    }

    private fun bandTransactionsByAmount(txns: List<TransactionHistory>): List<List<TransactionHistory>> {
        if (txns.isEmpty()) return emptyList()
        val amounts = txns.map { abs(it.amount) }
        val mean = amounts.average()
        val std = kotlin.math.sqrt(amounts.map { (it - mean) * (it - mean) }.average())
        val cv = if (mean > 0) std / mean else 0.0
        if (cv < 0.1 || txns.size < 6) return listOf(txns)
        val medianAmt = median(amounts)
        val low = mutableListOf<TransactionHistory>()
        val high = mutableListOf<TransactionHistory>()
        txns.forEach { if (abs(it.amount) <= medianAmt) low.add(it) else high.add(it) }
        return listOf(low, high).filter { it.isNotEmpty() }
    }

    private fun makeSequenceKey(txns: List<TransactionHistory>, intervalDays: Int): String {
        val medianAmt = median(txns.map { abs(it.amount) })
        val roundedAmt = kotlin.math.round(medianAmt)
        val intervalBucket = (intervalDays / 5) * 5
        return "${roundedAmt.toLong()}-${intervalBucket}d"
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
        val base = sorted.first().transactionDate
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
