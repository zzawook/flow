package sg.flow.services.SubscriptionServices

import java.time.Instant
import sg.flow.entities.utils.Platform

interface TrialService {
    suspend fun canStartTrial(email: String): TrialEligibilityResult
    suspend fun recordTrialUsage(userId: Int, platform: Platform, email: String)
}

sealed class TrialEligibilityResult {
    object Eligible : TrialEligibilityResult()
    data class AlreadyUsed(val firstUsedDate: Instant, val platform: Platform) :
            TrialEligibilityResult()
}
