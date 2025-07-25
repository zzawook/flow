package sg.flow.services.UtilServices

import sg.flow.models.finverse.FinverseDataRetrievalRequest
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


suspend fun userHasLoginIdentity(userId: Int, institutionId: String): Boolean

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential?
    
    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String

    suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean

    suspend fun clearRefreshSessionCache(userId: Int, institutionId: String)

    suspend fun startRefreshSession(userId: Int, institutionId: String)
// Data Retrieval Request management methods
suspend fun storeDataRetrievalRequest(userId: Int, request: FinverseDataRetrievalRequest)

suspend fun getDataRetrievalRequest(userId: Int): FinverseDataRetrievalRequest?

suspend fun removeDataRetrievalRequest(userId: Int)

suspend fun getAllIncompleteDataRetrievalRequests(): Map<Int, FinverseDataRetrievalRequest>

suspend fun updateDataRetrievalRequest(userId: Int, request: FinverseDataRetrievalRequest)

} 