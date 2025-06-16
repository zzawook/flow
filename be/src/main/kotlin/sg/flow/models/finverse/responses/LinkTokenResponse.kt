package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonAlias

data class LinkTokenResponse(
    @JsonAlias("link_url") val linkUrl: String,
    @JsonAlias("link_token") val linkToken: String?
)
