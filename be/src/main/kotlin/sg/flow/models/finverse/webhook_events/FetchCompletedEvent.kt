package sg.flow.models.finverse.webhook_events

import com.fasterxml.jackson.annotation.JsonAlias

data class FetchCompletedEvent(
    @JsonAlias("login_identity_id") val loginIdentityId: String,
    @JsonAlias("records_fetched") val recordCount: Int
) : FinverseWebhookEvent()
