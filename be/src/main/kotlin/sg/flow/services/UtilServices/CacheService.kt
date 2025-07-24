package sg.flow.services.UtilServices

import java.util.Optional
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential

interface CacheService {
    fun getUserIdByAccessToken(token: String): Optional<Int>
    fun storeAccessToken(userId: Int, accessToken: String)
    fun storeUserIdByLoginIdentityId(loginIdentityId: String, userId: Int)
    fun getUserIdByLoginIdentityId(loginIdentityId: String): Optional<Int>
    
    // Finverse-specific caching methods
    suspend fun saveLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String
    )
    
    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential?
    
    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String

    suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean

    suspend fun clearRefreshSessionCache(userId: Int, institutionId: String)

    suspend fun startRefreshSession(userId: Int, institutionId: String)
} 