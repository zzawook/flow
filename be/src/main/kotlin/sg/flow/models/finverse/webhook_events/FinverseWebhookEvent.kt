package sg.flow.models.finverse.webhook_events

import com.fasterxml.jackson.annotation.JsonAlias
import com.fasterxml.jackson.annotation.JsonProperty

data class FinverseWebhookEvent(
    @JsonProperty("login_identity_id")
    val loginIdentityId: String,

    @JsonProperty("event_type")
    val event_type: String,

    @JsonProperty("event_time")
    val event_time: String,

    // incoming JSON often has `"error": {}` so make it nullable and give it a default
    @JsonProperty("error")
    val error: FinverseWebhookError? = null
)