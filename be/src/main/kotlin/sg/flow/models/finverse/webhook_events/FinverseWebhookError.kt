package sg.flow.models.finverse.webhook_events

import com.fasterxml.jackson.annotation.JsonProperty

data class FinverseWebhookError(
    @JsonProperty("error_code")
    val error_code: String? = null,

    @JsonProperty("message")
    val message: String? = null,

    @JsonProperty("details")
    val details: String? = null,

    @JsonProperty("type")
    val type: String? = null
)