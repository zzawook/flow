package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant
import java.util.UUID

@JsonIgnoreProperties(ignoreUnknown = true)
data class GooglePlayNotificationEvent(
        @JsonProperty("eventId") val eventId: String = UUID.randomUUID().toString(),
        @JsonProperty("timestamp") val timestamp: Instant = Instant.now(),
        @JsonProperty("notificationType") val notificationType: Int,
        @JsonProperty("subscriptionNotification")
        val subscriptionNotification: SubscriptionNotification?,
        @JsonProperty("rawPayload") val rawPayload: String
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class SubscriptionNotification(
        @JsonProperty("version") val version: String,
        @JsonProperty("notificationType") val notificationType: Int,
        @JsonProperty("purchaseToken") val purchaseToken: String,
        @JsonProperty("subscriptionId") val subscriptionId: String
)
