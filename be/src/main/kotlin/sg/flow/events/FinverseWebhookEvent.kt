package sg.flow.events

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import com.fasterxml.jackson.annotation.JsonProperty
import java.time.Instant

@JsonIgnoreProperties(ignoreUnknown = true)
data class FinverseWebhookEvent(
    @JsonProperty("eventId")
    val eventId: String = java.util.UUID.randomUUID().toString(),
    
    @JsonProperty("timestamp")
    val timestamp: Instant = Instant.now(),
    
    @JsonProperty("eventType")
    val eventType: String,
    
    @JsonProperty("loginIdentityId")
    val loginIdentityId: String,
    
    @JsonProperty("rawWebhookPayload")
    val rawWebhookPayload: sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
) 