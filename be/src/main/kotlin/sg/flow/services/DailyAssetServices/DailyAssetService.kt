package sg.flow.services.DailyAssetServices

import java.time.LocalDate
import java.time.ZoneId
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.DailyUserAsset
import sg.flow.repositories.dailyAsset.DailyAssetRepository

@Service
class DailyAssetService(private val dailyAssetRepository: DailyAssetRepository) {

    private val logger = LoggerFactory.getLogger(DailyAssetService::class.java)
    private val sgtZone = ZoneId.of("Asia/Singapore")

    /** Get daily assets for a user within a date range (inclusive) */
    suspend fun getAssetsByDateRange(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): List<DailyUserAsset> {
        logger.debug("Fetching assets for user {} from {} to {}", userId, startDate, endDate)
        return dailyAssetRepository.findByUserAndDateRange(userId, startDate, endDate)
    }

    /** Get last 7 days of asset values for a user (including today) */
    suspend fun getLast7DaysAssets(userId: Int): List<DailyUserAsset> {
        val today = LocalDate.now(sgtZone)
        val sevenDaysAgo = today.minusDays(6) // 6 days ago + today = 7 days

        logger.debug("Fetching last 7 days assets for user {}", userId)
        return dailyAssetRepository.findByUserAndDateRange(userId, sevenDaysAgo, today)
    }

    /**
     * Get end-of-month asset values for the last 6 months. Returns assets from the last day of each
     * of the past 6 months.
     */
    suspend fun getLast6MonthsEndOfMonthAssets(userId: Int): List<DailyUserAsset> {
        val today = LocalDate.now(sgtZone)
        val endOfMonthDates = mutableListOf<LocalDate>()

        // Calculate end-of-month dates for the last 6 months
        for (i in 1..6) {
            val monthStart = today.minusMonths(i.toLong()).withDayOfMonth(1)
            val endOfMonth = monthStart.withDayOfMonth(monthStart.lengthOfMonth())
            endOfMonthDates.add(endOfMonth)
        }

        logger.debug(
                "Fetching end-of-month assets for user {} for dates: {}",
                userId,
                endOfMonthDates
        )

        // Fetch assets for each end-of-month date
        val results = mutableListOf<DailyUserAsset>()
        for (date in endOfMonthDates) {
            val asset = dailyAssetRepository.findByUserAndDate(userId, date)
            if (asset != null) {
                results.add(asset)
            }
        }

        // Return in chronological order (oldest to newest)
        return results.sortedBy { it.assetDate }
    }
}
