package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonAlias

data class CustomerTokenResponse(
    @JsonAlias("access_token") val accessToken: String,
    @JsonAlias("expires_in") val expiresIn: Long,
    @JsonAlias("token_type") val tokenType: String
)
