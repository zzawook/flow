package sg.flow.services.AuthServices

import org.springframework.web.server.ServerWebExchange
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import java.time.LocalDate
import java.util.Date

interface AuthService {
    suspend fun registerUser(email: String, name: String, password: String): TokenSet
    suspend fun getTokenSetForUser(email: String, password: String): TokenSet
    suspend fun getAccessTokenByRefreshToken(request: AccessTokenRefreshRequest): TokenSet?
    suspend fun checkUserExists(email: String): Boolean
    suspend fun signOutUser(accessToken: String): Boolean
    suspend fun sendVerificationEmail(email: String): Boolean
    suspend fun verifyEmail(token: String): Boolean
    suspend fun checkEmailVerified(email: String): Boolean
    suspend fun monitorEmailVerified(email: String): Boolean
}
