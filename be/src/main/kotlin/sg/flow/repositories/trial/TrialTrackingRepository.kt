package sg.flow.repositories.trial

import sg.flow.entities.TrialUsageTracking
import sg.flow.repositories.Repository

interface TrialTrackingRepository : Repository<TrialUsageTracking, Long> {
    suspend fun findByEmail(email: String): TrialUsageTracking?
    suspend fun findByUserId(userId: Int): TrialUsageTracking?
    suspend fun hasEmailUsedTrial(email: String): Boolean
}
