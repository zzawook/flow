package sg.flow.models.finverse.webhook_events

import com.fasterxml.jackson.annotation.JsonAlias

data class StatementReadyEvent(
    @JsonAlias("login_identity_id") val loginIdentityId: String,
    @JsonAlias("statement_url") val statementUrl: String
) : FinverseWebhookEvent()
