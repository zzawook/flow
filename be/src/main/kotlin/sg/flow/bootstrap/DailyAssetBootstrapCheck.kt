package sg.flow.bootstrap

import java.time.LocalDate
import java.time.ZoneId
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory
import org.springframework.boot.CommandLineRunner
import org.springframework.core.annotation.Order
import org.springframework.stereotype.Component
import sg.flow.repositories.dailyAsset.DailyAssetRepository
import sg.flow.services.DailyAssetServices.DailyAssetCalculationService

@Component
@Order(3)
class DailyAssetBootstrapCheck(
        private val dailyAssetCalculationService: DailyAssetCalculationService,
        private val dailyAssetRepository: DailyAssetRepository
) : CommandLineRunner {

    private val logger = LoggerFactory.getLogger(DailyAssetBootstrapCheck::class.java)

    override fun run(vararg args: String) {
        logger.info("Daily Asset Bootstrap Check starting...")

        runBlocking {
            try {
                val today = LocalDate.now(ZoneId.of("Asia/Singapore"))
                val missingUsers = dailyAssetRepository.findUsersMissingAssetsForDate(today)

                if (missingUsers.isNotEmpty()) {
                    logger.info(
                            "Found {} users missing today's ({}) asset data. Calculating now...",
                            missingUsers.size,
                            today
                    )
                    val usersProcessed = dailyAssetCalculationService.calculateForDate(today)
                    logger.info(
                            "Bootstrap asset calculation completed: {} users processed",
                            usersProcessed
                    )
                } else {
                    logger.info("All users have asset data for today ({})", today)
                }
            } catch (e: Exception) {
                logger.error("Error during daily asset bootstrap check", e)
            }
        }

        logger.info("Daily Asset Bootstrap Check completed.")
    }
}
