package sg.flow.services.BankQueryServices.FinverseQueryService

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.services.UtilServices.CacheService
import sg.flow.services.UtilServices.UserIdAndInstitutionId

@Component
class FinverseAuthCache(
    private val cacheService: CacheService
) {
    private val logger = LoggerFactory.getLogger(FinverseAuthCache::class.java)

    suspend fun saveLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String
    ) {
        cacheService.storeUserIdByLoginIdentityId(loginIdentityId, loginIdentityToken, userId, institutionId)
    }

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential? {
        return cacheService.getLoginIdentityCredential(userId, institutionId)
    }

    suspend fun userHasLoginIdentity(userId: Int, institutionId: String): Boolean {
        return cacheService.userHasLoginIdentity(userId, institutionId)
    }

    suspend fun getUserId(loginIdentityId: String): Int {
        val userIdAndInstitutionIdOptional = cacheService.getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId)
        if (userIdAndInstitutionIdOptional.isEmpty) {
            return -1
        }
        return userIdAndInstitutionIdOptional.get().userId
    }

    suspend fun getUserIdAndInstitutionId(loginIdentityId: String): UserIdAndInstitutionId {
        val userIdAndInstitutionIdOptional = cacheService.getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId)
        if (userIdAndInstitutionIdOptional.isEmpty) {
            logger.error("FAILED TO GET USER ID AND INSTITUTION ID FROM GIVEN LOGIN IDENTITY ID: $loginIdentityId")
            return UserIdAndInstitutionId(-1, "")
        }
        return userIdAndInstitutionIdOptional.get()
    }

    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        return cacheService.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)
    }

    suspend fun startRefreshSession(userId: Int, institutionId: String, request: FinverseDataRetrievalRequest) {
        cacheService.startRefreshSession(userId, institutionId, request)
    }

    suspend fun getRefreshSession(userId: Int, institutionId: String): FinverseDataRetrievalRequest? {
        return cacheService.getDataRetrievalRequest(userId, institutionId)
    }

    suspend fun hasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return cacheService.doesUserHasRunningRefreshSession(userId, institutionId)
    }

    suspend fun finishRefreshSession(userId: Int, institutionId: String) {
        cacheService.clearRefreshSessionCache(userId, institutionId)
    }

    suspend fun updateRefreshSession(userId: Int, institutionId: String, newRequest: FinverseDataRetrievalRequest) {
        cacheService.updateDataRetrievalRequest(userId, institutionId, newRequest)
    }

    suspend fun startPreAuthSession(userId: Int, institutionId: String, state: String) {
        cacheService.storePreAuthSession(userId, institutionId, state)
    }

    suspend fun getUserIdAndInstitutionIdFromState(state: String): UserIdAndInstitutionId {
        return cacheService.getPreAuthSession(state)
    }

    suspend fun clearPreAuthSession(state: String) {
        cacheService.clearPreAuthSession(state)
    }

    suspend fun storePostAuthResult(userId: Int, institutionId: String, authStatus: FinverseAuthenticationStatus) {
        cacheService.storeFinalAuth(userId, institutionId, authStatus)
    }
}