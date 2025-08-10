package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonAlias

data class FinverseAuthTokenResponse(
    @JsonAlias("access_token") val loginIdentityToken: String,
    @JsonAlias("expires_in") val expiresIn: Int,
    @JsonAlias("issued_at") val issuedAt: String,
    @JsonAlias("login_identity_id") val loginIdentityId: String,
    @JsonAlias("refresh_token") val refreshToken: String,
    @JsonAlias("token_type") val tokenType: String,
)
