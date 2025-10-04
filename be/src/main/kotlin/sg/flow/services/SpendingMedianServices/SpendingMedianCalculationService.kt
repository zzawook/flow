package sg.flow.services.SpendingMedianServices

import java.time.LocalDate
import java.time.ZoneId
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import sg.flow.configs.SpendingMedianProperties
import sg.flow.repositories.spendingMedian.SpendingMedianRepository

@Service
class SpendingMedianCalculationService(
        private val spendingMedianRepository: SpendingMedianRepository,
        private val properties: SpendingMedianProperties
) {

    private val logger = LoggerFactory.getLogger(SpendingMedianCalculationService::class.java)
    private val sgtZone = ZoneId.of("Asia/Singapore")

    /**
     * Scheduled task that runs every hour at minute 0. Calculates spending medians for the current
     * month and backfills missing historical months.
     */
    @Scheduled(cron = "0 10 * * * *")
    fun calculateSpendingMedians() {
        if (!properties.enabled) {
            logger.debug("Spending median calculation is disabled")
            return
        }

        runBlocking {
            try {
                logger.info("Starting scheduled spending median calculation")

                val now = LocalDate.now(sgtZone)
                val currentYear = now.year
                val currentMonth = now.monthValue

                // Calculate current month
                logger.info(
                        "Calculating medians for current month: {}-{}",
                        currentYear,
                        currentMonth
                )
                val currentMonthUpdated =
                        spendingMedianRepository.calculateAndStoreMediansForMonth(
                                currentYear,
                                currentMonth
                        )
                logger.info("Updated {} age groups for current month", currentMonthUpdated)

                // Backfill missing historical months
                backfillMissingMonths(currentYear, currentMonth)

                logger.info("Completed scheduled spending median calculation")
            } catch (e: Exception) {
                logger.error("Error during scheduled spending median calculation", e)
            }
        }
    }

    /** Backfills missing months up to the configured number of months in the past. */
    private suspend fun backfillMissingMonths(currentYear: Int, currentMonth: Int) {
        try {
            // Calculate start date for backfill
            val startDate =
                    LocalDate.of(currentYear, currentMonth, 1)
                            .minusMonths(properties.backfillMonths.toLong())

            val startYear = startDate.year
            val startMonth = startDate.monthValue

            logger.info(
                    "Checking for missing months from {}-{} to {}-{}",
                    startYear,
                    startMonth,
                    currentYear,
                    currentMonth
            )

            // Find missing months
            val missingMonths =
                    spendingMedianRepository.findMissingMonths(
                            startYear,
                            startMonth,
                            currentYear,
                            currentMonth
                    )

            if (missingMonths.isEmpty()) {
                logger.info("No missing months found for backfill")
                return
            }

            logger.info("Found {} missing months to backfill", missingMonths.size)

            // Calculate medians for each missing month
            var backfilled = 0
            missingMonths.forEach { (year, month) ->
                try {
                    logger.info("Backfilling medians for {}-{}", year, month)
                    val updated =
                            spendingMedianRepository.calculateAndStoreMediansForMonth(year, month)
                    if (updated > 0) {
                        backfilled++
                        logger.info("Backfilled {}-{}: {} age groups", year, month, updated)
                    }
                } catch (e: Exception) {
                    logger.error("Failed to backfill medians for {}-{}", year, month, e)
                }
            }

            logger.info("Backfill completed: {} months processed", backfilled)
        } catch (e: Exception) {
            logger.error("Error during backfill process", e)
        }
    }

    /**
     * Manual trigger for calculating a specific month (useful for testing or manual recalculation).
     */
    suspend fun calculateForMonth(year: Int, month: Int): Int {
        logger.info("Manually calculating medians for {}-{}", year, month)
        return spendingMedianRepository.calculateAndStoreMediansForMonth(year, month)
    }
}
