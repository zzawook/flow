package sg.flow.entities

import java.time.Instant
import org.springframework.data.annotation.Id
import sg.flow.entities.utils.Platform

data class TrialUsageTracking(
        @field:Id val id: Long?,
        val email: String,
        val platform: Platform,
        val firstTrialStartedAt: Instant,
        val userId: Int?,
        val createdAt: Instant = Instant.now()
)
