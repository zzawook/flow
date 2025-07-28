package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseCacheMissException
import sg.flow.services.UtilServices.CacheService
import sg.flow.services.UtilServices.UserIdAndInstitutionId

@Component
class FinverseAuthCache(
    private val cacheService: CacheService
) {

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

    suspend fun hasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return cacheService.doesUserHasRunningRefreshSession(userId, institutionId)
    }

    suspend fun finishRefreshSession(userId: Int, institutionId: String) {
        cacheService.clearRefreshSessionCache(userId, institutionId)
    }
}