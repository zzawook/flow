package sg.flow.models.finverse

data class LoginIdentity(
    val userId: Int,
    val finverseInstitutionId: String,
    val loginIdentityId: String,
    val loginIdentityRefreshToken: String,
    val refreshAllowed: Boolean
)