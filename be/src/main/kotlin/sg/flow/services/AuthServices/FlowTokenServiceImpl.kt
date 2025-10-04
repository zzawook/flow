package sg.flow.services.AuthServices

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.stereotype.Service
import sg.flow.models.auth.FlowUserDetails
import sg.flow.models.auth.TokenSet
import sg.flow.services.UserServices.UserService
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.JwtTokenProvider
import sg.flow.services.UtilServices.VaultService
import java.time.Duration
import java.util.UUID
import kotlin.time.Clock
import kotlin.time.ExperimentalTime
import kotlin.time.Instant

@Service
class FlowTokenServiceImpl(
        private val cacheService: CacheService,
        private val vaultService: VaultService,
        private val userService: UserService,
        private val jwtTokenProvider: JwtTokenProvider,
) : FlowTokenService {

    override suspend fun getUserDetailByAccessToken(accessToken: String): FlowUserDetails? =
            withContext(Dispatchers.IO) {
                val userId =
                        cacheService
                                .getUserIdByAccessToken(accessToken).orElse(null)
                                ?: return@withContext null

                val profile = userService.getUserProfile(userId)
                FlowUserDetails(
                        userId = userId,
                        name = profile.name,
                        authoritiesSet = listOf(SimpleGrantedAuthority("ROLE_USER"))
                )
            }

    override suspend fun getAccessTokenByRefreshToken(refreshToken: String): TokenSet? =
            withContext(Dispatchers.IO) {
                val userId =
                        vaultService.getUserIdByRefreshToken(refreshToken).orElse(null)
                                ?: return@withContext null
                generateAndStoreRefreshTokenAndAccessToken(userId)
            }

    override suspend fun generateAndStoreAccessToken(refreshToken: String): TokenSet? =
            withContext(Dispatchers.IO) {
                val userId =
                        vaultService.getUserIdByRefreshToken(refreshToken).orElse(null)
                                ?: return@withContext null
                generateAndStoreRefreshTokenAndAccessToken(userId)
            }

    override suspend fun generateAndStoreRefreshTokenAndAccessToken(userId: Int): TokenSet? =
            withContext(Dispatchers.IO) {
                val refreshToken = jwtTokenProvider.generateRefreshToken(userId)
                val accessToken = jwtTokenProvider.generateAccessToken(refreshToken)

                cacheService.storeAccessToken(userId, accessToken)
                vaultService.storeRefreshToken(userId, refreshToken)

                TokenSet(accessToken = accessToken, refreshToken = refreshToken)
            }

    override suspend fun revokeAccessToken(accessToken: String): Boolean {
        cacheService.clearAccessToken(accessToken)
        return true
    }

    override suspend fun generateAndStoreEmailVerificationToken(email: String): String {
        return withContext(Dispatchers.IO) {
            val sessionId = UUID.randomUUID().toString()
            val jti = UUID.randomUUID().toString()
            val token = jwtTokenProvider.generateEmailVerificationToken(email, sessionId, jti)

            val payload =
                """
                    {
                        "email": "$email",
                        "jti": "$jti"
                    }
                """.trimIndent()
            val ttl = Duration.ofMinutes(5)
            cacheService.storeEmailValidationSessionData(email, sessionId, payload, ttl)

            token
        }
    }

    override suspend fun validateEmailVerificationToken(token: String): String {
        return withContext(Dispatchers.IO) {
            val validatedResult = jwtTokenProvider.validateEmailVerificationToken(token)

            val email = validatedResult["email"]!!
            val sid = validatedResult["sid"]!!
            val jti = validatedResult["jti"]!!

            val jsonPayload = cacheService.getEmailValidationSessionData(email, sid)

            if (checkEmailSidAndJtiNull(email, sid, jti) || (! checkPayloadCOntainsEmailAndJti(jsonPayload, email, jti))) {
                return@withContext ""
            }

            cacheService.removeEmailValidationSessionData(email, sid)

            email
        }
    }

    private fun checkEmailSidAndJtiNull(email: String, sid: String, jti: String): Boolean {
        return email == "null claim" || sid == "null claim" || jti == "null claim"
    }

    private fun checkPayloadCOntainsEmailAndJti(jsonPayload: String, email: String, jti: String): Boolean {
        return !jsonPayload.contains("\"email\":\"${email}\"") || !jsonPayload.contains("\"jti\":\"${jti}\"")
    }
}
