package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseTimeoutEvent(
        @JsonProperty("eventId") val eventId: String = java.util.UUID.randomUUID().toString(),
        @JsonProperty("timestamp") val timestamp: Instant = Instant.now(),
        @JsonProperty("userId") val userId: Int,
        @JsonProperty("loginIdentityId") val loginIdentityId: String,
        @JsonProperty("institutionId") val institutionId: String,
        @JsonProperty("timeoutType") val timeoutType: TimeoutType,
        @JsonProperty("requestStartTime") val requestStartTime: Instant
)

enum class TimeoutType {
    THREE_MINUTE_WARNING, // Auto-fetch incomplete products + clear refresh session
    FIVE_MINUTE_EXPIRY // Remove from memory completely
}
