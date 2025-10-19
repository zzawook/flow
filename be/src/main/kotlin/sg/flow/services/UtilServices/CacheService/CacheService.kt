package sg.flow.services.UtilServices.CacheService

import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential
import sg.flow.services.UtilServices.UserIdAndInstitutionId
import java.time.Duration
import java.util.Optional

interface CacheService {
    fun getUserIdByAccessToken(token: String): Optional<Int>
    fun storeAccessToken(userId: Int, accessToken: String)
    suspend fun clearAccessToken(token: String)
    suspend fun storeUserIdByLoginIdentityId(loginIdentityId: String, loginIdentityToken: String, userId: Int, institutionId: String, refreshAllowed: Boolean)
    suspend fun getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId: String): Optional<UserIdAndInstitutionId>

    suspend fun userHasLoginIdentity(userId: Int, institutionId: String): Boolean

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential?

    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String

    suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean

    suspend fun getInstitutionIdOfRunningRefreshSession(userId: Int, allInstitutionIds: List<String>): List<String>

    suspend fun clearRefreshSession(loginIdentityId: String)

    suspend fun getRefreshSession(loginIdentityId: String): FinverseDataRetrievalRequest?

    suspend fun storePreAuthSession(userId: Int, institutionId: String, state: String)

    suspend fun getPreAuthSession(state: String): UserIdAndInstitutionId

    suspend fun checkIfPreAuthExists(userId: Int, institutionId: String): Boolean

    suspend fun clearPreAuthSession(state: String)

    suspend fun getPreAuthStateFor(userId: Int, institutionId: String): String

    suspend fun storeFinalAuth(userId: Int, institutionId: String, authStatus: FinverseAuthenticationStatus)

    suspend fun getFinalAuth(userId: Int, institutionId: String): FinverseAuthenticationStatus?

    suspend fun clearFinalAuth(userId: Int, institutionId: String)

    suspend fun storeEmailValidationSessionData(email: String, sessionId: String, payload: String, ttl: Duration)

    suspend fun getEmailValidationSessionData(email: String, sessionId: String): String

    suspend fun removeEmailValidationSessionData(email: String, sid: String): Boolean

    suspend fun storeFinishedRefreshSession(loginIdentityId: String)

    suspend fun getFinishedRefreshSession(loginIdentityId: String): Boolean

    suspend fun clearFinishedRefreshSession(loginIdentityId: String)
}