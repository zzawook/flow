package sg.flow.services.SubscriptionServices

import java.time.Instant
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.TrialUsageTracking
import sg.flow.entities.utils.Platform
import sg.flow.repositories.trial.TrialTrackingRepository

@Service
class TrialServiceImpl(private val trialTrackingRepo: TrialTrackingRepository) : TrialService {

    private val logger = LoggerFactory.getLogger(TrialServiceImpl::class.java)

    override suspend fun canStartTrial(email: String): TrialEligibilityResult {
        val existingTrial = trialTrackingRepo.findByEmail(email)

        return if (existingTrial != null) {
            logger.info("Email $email already used trial on ${existingTrial.platform}")
            TrialEligibilityResult.AlreadyUsed(
                    firstUsedDate = existingTrial.firstTrialStartedAt,
                    platform = existingTrial.platform
            )
        } else {
            TrialEligibilityResult.Eligible
        }
    }

    override suspend fun recordTrialUsage(userId: Int, platform: Platform, email: String) {
        try {
            val tracking =
                    TrialUsageTracking(
                            id = null,
                            email = email,
                            platform = platform,
                            firstTrialStartedAt = Instant.now(),
                            userId = userId
                    )

            trialTrackingRepo.save(tracking)
            logger.info("Recorded trial usage for email=$email, userId=$userId, platform=$platform")
        } catch (e: Exception) {
            logger.error("Failed to record trial usage for email=$email", e)
            // Don't throw - this shouldn't block trial creation
        }
    }
}
