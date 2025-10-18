package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant
import java.util.UUID

@JsonIgnoreProperties(ignoreUnknown = true)
data class AppStoreNotificationEvent(
        @JsonProperty("eventId") val eventId: String = UUID.randomUUID().toString(),
        @JsonProperty("timestamp") val timestamp: Instant = Instant.now(),
        @JsonProperty("notificationType") val notificationType: String,
        @JsonProperty("subtype") val subtype: String?,
        @JsonProperty("data") val data: AppStoreNotificationData,
        @JsonProperty("rawPayload") val rawPayload: String
)

@JsonIgnoreProperties(ignoreUnknown = true)
data class AppStoreNotificationData(
        @JsonProperty("signedTransactionInfo") val signedTransactionInfo: String,
        @JsonProperty("signedRenewalInfo") val signedRenewalInfo: String?
)
