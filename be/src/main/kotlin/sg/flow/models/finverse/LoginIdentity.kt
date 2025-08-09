package sg.flow.models.finverse

import sg.flow.entities.Bank
import sg.flow.entities.User

data class LoginIdentity(
    val userId: Int,
    val finverseInstitutionId: String,
    val loginIdentityId: String,
    val loginIdentityRefreshToken: String,
    val refreshAllowed: Boolean
)