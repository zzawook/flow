package sg.flow.models.finverse.webhook_events

import com.fasterxml.jackson.annotation.JsonAlias
import java.time.Instant

data class LinkSucceededEvent(
    @JsonAlias("login_identity_id") val loginIdentityId: String,
    val timestamp: Instant
) : FinverseWebhookEvent()
