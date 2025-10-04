package sg.flow.services.UtilServices

import sg.flow.models.finverse.LoginIdentity
import java.util.Optional

interface VaultService {
    suspend fun getUserIdByRefreshToken(token: String): Optional<Int>
    suspend fun storeRefreshToken(userId: Int, refreshToken: String)

    suspend fun saveOrUpdateLoginIdentity(loginIdentity: LoginIdentity)
    suspend fun deleteLoginIdentity(loginIdentity: LoginIdentity)
    suspend fun deleteLoginIdentity(userId: Int, institutionId: String)
    suspend fun getLoginIdentity(userId: Int, institutionId: String): LoginIdentity?
    suspend fun getLoginIdentity(loginIdentityId: String): LoginIdentity?
    suspend fun getRefreshTokenForUserId(userId: Int): Optional<String>
    suspend fun getInstitutionIdsForUserId(userId: Int): List<String>
}
