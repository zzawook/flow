package sg.flow.repositories.loginIdentity

import sg.flow.models.finverse.LoginIdentity

interface LoginIdentityRepository {
    suspend fun saveOrUpdateLoginIdentity(loginIdentity: LoginIdentity)

    suspend fun updateLoginIdentity(newLoginIdentity: LoginIdentity)

    suspend fun updateLoginIdentity(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityRefreshToken: String,
        refreshAllowed: Boolean
    )

    suspend fun deleteLoginIdentity(loginIdentity: LoginIdentity)

    suspend fun deleteLoginIdentity(userId: Int, institutionId: String)

    suspend fun getLoginIdentity(userId: Int, institutionId: String): LoginIdentity?

    suspend fun getLoginIdentity(loginIdentityId: String): LoginIdentity?

}