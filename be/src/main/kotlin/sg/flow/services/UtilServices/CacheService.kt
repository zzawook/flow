package sg.flow.services.UtilServices

import sg.flow.models.finverse.FinverseDataRetrievalRequest
import java.util.Optional
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential



interface CacheService {
    fun getUserIdByAccessToken(token: String): Optional<Int>
    fun storeAccessToken(userId: Int, accessToken: String)
    suspend fun storeUserIdByLoginIdentityId(loginIdentityId: String, loginIdentityToken: String, userId: Int, institutionId: String)
    suspend fun getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId: String): Optional<UserIdAndInstitutionId>

    suspend fun userHasLoginIdentity(userId: Int, institutionId: String): Boolean

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential?
    
    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String

    suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean

    suspend fun clearRefreshSessionCache(userId: Int, institutionId: String)

    suspend fun startRefreshSession(userId: Int, institutionId: String, request: FinverseDataRetrievalRequest)

    suspend fun updateDataRetrievalRequest(userId: Int, institutionId: String, request: FinverseDataRetrievalRequest)

    suspend fun getDataRetrievalRequest(userId: Int, institutionId: String): FinverseDataRetrievalRequest?

    suspend fun removeDataRetrievalRequest(userId: Int)
} 