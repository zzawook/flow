package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonAlias
import com.fasterxml.jackson.annotation.JsonIgnoreProperties

@JsonIgnoreProperties
data class FinverseLoginIdentityResponse(
    @param:JsonAlias("login_identity") val loginIdentity: LoginIdentity,
)

@JsonIgnoreProperties
data class LoginIdentity(
    @param:JsonAlias("refresh") val refresh: Refresh,
)

@JsonIgnoreProperties
data class Refresh(
    @param:JsonAlias("refresh_allowed") val refreshAllowed: Boolean
)