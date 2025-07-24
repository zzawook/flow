package sg.flow.services.UtilServices

import java.util.Optional
import java.util.concurrent.ConcurrentHashMap
import org.springframework.stereotype.Service
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential

//@Service
class MockCacheServiceImpl : CacheService {
    private val tokenToUserId: MutableMap<String, Int> = ConcurrentHashMap()
    private val loginIdentityToUserId: MutableMap<String, Int> = ConcurrentHashMap()
    
    // Finverse-specific storage
    private val userInstitutionToCredential: MutableMap<String, FinverseLoginIdentityCredential> = ConcurrentHashMap()
    private val loginIdentityToToken: MutableMap<String, String> = ConcurrentHashMap()
    
    // Refresh session storage - now per user-institution pair
    private val refreshSessions: MutableMap<String, Boolean> = ConcurrentHashMap()

    override fun getUserIdByAccessToken(token: String): Optional<Int> =
            Optional.ofNullable(tokenToUserId[token])

    override fun storeAccessToken(userId: Int, accessToken: String) {
        tokenToUserId[accessToken] = userId
    }

    override fun storeUserIdByLoginIdentityId(loginIdentityId: String, userId: Int) {
        loginIdentityToUserId[loginIdentityId] = userId
    }

    override fun getUserIdByLoginIdentityId(loginIdentityId: String): Optional<Int> {
        return Optional.ofNullable(loginIdentityToUserId[loginIdentityId])
    }

    override suspend fun saveLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String
    ) {
        val key = "${userId}:${institutionId}"
        val credential = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)
        userInstitutionToCredential[key] = credential
        
        // Store reverse mappings
        loginIdentityToUserId[loginIdentityId] = userId
        loginIdentityToToken[loginIdentityId] = loginIdentityToken
    }

    override suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential? {
        val key = "${userId}:${institutionId}"
        return userInstitutionToCredential[key]
    }

    override suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        return loginIdentityToToken[loginIdentityId] ?: ""
    }

    override suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        val sessionKey = "${userId}:${institutionId}"
        return refreshSessions[sessionKey] ?: false
    }

    override suspend fun clearRefreshSessionCache(userId: Int, institutionId: String) {
        val sessionKey = "${userId}:${institutionId}"
        val userInstitutionKey = "${userId}:${institutionId}"
        
        // Remove refresh session marker for this specific user-institution pair
        refreshSessions.remove(sessionKey)
        
        // Clear Finverse data for this specific user-institution pair
        val credential = userInstitutionToCredential.remove(userInstitutionKey)
        
        // If we had a credential, clean up the reverse mappings
        credential?.let { cred ->
            loginIdentityToUserId.remove(cred.loginIdentityId)
            loginIdentityToToken.remove(cred.loginIdentityId)
        }
        
        println("Cleared cache entries for user $userId, institution $institutionId refresh session")
    }
    
    // Helper method for FinverseAuthCache compatibility
    suspend fun getUserIdByLoginIdentityIdFinverse(loginIdentityId: String): Int {
        return loginIdentityToUserId[loginIdentityId] ?: -1
    }
    
    // Helper method to mark a refresh session as started for a specific user-institution pair
    override suspend fun startRefreshSession(userId: Int, institutionId: String) {
        val sessionKey = "${userId}:${institutionId}"
        refreshSessions[sessionKey] = true
    }
}
