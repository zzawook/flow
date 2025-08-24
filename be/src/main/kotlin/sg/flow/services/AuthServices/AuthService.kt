package sg.flow.services.AuthServices

import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet

interface AuthService {
    suspend fun registerUser(email: String, name: String, password: String): TokenSet
    suspend fun getTokenSetForUser(email: String, password: String): TokenSet
    suspend fun getAccessTokenByRefreshToken(request: AccessTokenRefreshRequest): TokenSet?
    suspend fun checkUserExists(email: String): Boolean
    suspend fun signOutUser(accessToken: String): Boolean
}
