package sg.flow.services.DailyAssetServices

import java.time.LocalDate
import java.time.ZoneId
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory
import org.springframework.scheduling.annotation.Scheduled
import org.springframework.stereotype.Service
import sg.flow.configs.DailyAssetProperties
import sg.flow.repositories.dailyAsset.DailyAssetRepository

@Service
class DailyAssetCalculationService(
        private val dailyAssetRepository: DailyAssetRepository,
        private val properties: DailyAssetProperties
) {

    private val logger = LoggerFactory.getLogger(DailyAssetCalculationService::class.java)
    private val sgtZone = ZoneId.of("Asia/Singapore")

    /**
     * Scheduled task that runs at midnight SGT every day. Calculates and stores the total asset
     * value for all users.
     */
    @Scheduled(cron = "0 0 0 * * *")
    fun calculateDailyAssets() {
        if (!properties.enabled) {
            logger.debug("Daily asset calculation is disabled")
            return
        }

        runBlocking {
            try {
                logger.info("Starting scheduled daily asset calculation")

                val today = LocalDate.now(sgtZone)

                // Calculate and store assets for today
                logger.info("Calculating daily assets for date: {}", today)
                val usersProcessed = dailyAssetRepository.calculateAndStoreDailyAssetsForDate(today)

                logger.info(
                        "Completed scheduled daily asset calculation: {} users processed",
                        usersProcessed
                )
            } catch (e: Exception) {
                logger.error("Error during scheduled daily asset calculation", e)
            }
        }
    }

    /**
     * Manual trigger for calculating daily assets for a specific date. Useful for testing or manual
     * recalculation.
     */
    suspend fun calculateForDate(date: LocalDate): Int {
        logger.info("Manually calculating daily assets for date: {}", date)
        return dailyAssetRepository.calculateAndStoreDailyAssetsForDate(date)
    }
}
