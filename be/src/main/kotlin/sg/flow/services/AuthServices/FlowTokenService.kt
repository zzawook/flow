package sg.flow.services.AuthServices

import com.nimbusds.oauth2.sdk.token.AccessToken
import sg.flow.models.auth.FlowUserDetails
import sg.flow.models.auth.TokenSet
import javax.accessibility.Accessible

interface FlowTokenService {
    suspend fun getUserDetailByAccessToken(accessToken: String): FlowUserDetails?
    suspend fun getAccessTokenByRefreshToken(refreshToken: String): TokenSet?
    suspend fun generateAndStoreAccessToken(refreshToken: String): TokenSet?
    suspend fun generateAndStoreRefreshTokenAndAccessToken(userId: Int): TokenSet?
    suspend fun revokeAccessToken(accessToken: String): Boolean
}
