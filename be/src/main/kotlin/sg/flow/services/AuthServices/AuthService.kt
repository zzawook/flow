package sg.flow.services.AuthServices

import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet

interface AuthService {
    suspend fun registerUser(request: AuthRequest): TokenSet
    suspend fun getAccessTokenByRefreshToken(request: AccessTokenRefreshRequest): TokenSet?
}
