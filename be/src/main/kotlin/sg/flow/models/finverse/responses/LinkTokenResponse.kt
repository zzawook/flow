package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonAlias
import java.time.LocalDateTime

data class LinkTokenResponse(
    @JsonAlias("link_url") val linkUrl: String,
    @JsonAlias("access_token") val linkToken: String?,
    @JsonAlias("expires_in") val expiresIn: Int?,
    @JsonAlias("issued_at") val issuedAt: LocalDateTime?,
    @JsonAlias("login_identity_id") val loginIdentityId: String?,
    @JsonAlias("token_type") val tokenType: String?,
)
