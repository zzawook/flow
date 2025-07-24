package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseCacheMissException
import sg.flow.services.UtilServices.CacheService

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
        cacheService.saveLoginIdentityToken(userId, institutionId, loginIdentityId, loginIdentityToken)
    }

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential? {
        return cacheService.getLoginIdentityCredential(userId, institutionId)
    }

    suspend fun getUserId(loginIdentityId: String): Int {
        // Try to get from the cache service using the helper method in Redis implementation
        // For MockCacheServiceImpl, we'll use the existing method
        if (cacheService is sg.flow.services.UtilServices.RedisCacheServiceImpl) {
            return cacheService.getUserIdByLoginIdentityIdFinverse(loginIdentityId)
        } else if (cacheService is sg.flow.services.UtilServices.MockCacheServiceImpl) {
            return cacheService.getUserIdByLoginIdentityIdFinverse(loginIdentityId)
        } else {
            // Fallback: use existing method and convert Optional to Int
            val userIdOptional = cacheService.getUserIdByLoginIdentityId(loginIdentityId)
            return userIdOptional.orElse(-1)
        }
    }

    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        return cacheService.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)
    }

    suspend fun startRefreshSession(userId: Int, institutionId: String) {
        cacheService.startRefreshSession(userId, institutionId)
    }

    suspend fun hasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return cacheService.doesUserHasRunningRefreshSession(userId, institutionId)
    }

    suspend fun finishRefreshSession(userId: Int, institutionId: String) {
        cacheService.clearRefreshSessionCache(userId, institutionId)
    }
}