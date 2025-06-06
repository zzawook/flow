package sg.flow.services.AuthServices

import sg.flow.models.auth.FlowUserDetails
import sg.flow.models.auth.TokenSet

interface FlowTokenService {
    suspend fun getUserDetailByAccessToken(accessToken: String): FlowUserDetails?
    suspend fun getAccessTokenByRefreshToken(refreshToken: String): TokenSet?
    suspend fun generateAndStoreAccessToken(refreshToken: String): TokenSet?
    suspend fun generateAndStoreRefreshToken(userId: Int): TokenSet?
}
