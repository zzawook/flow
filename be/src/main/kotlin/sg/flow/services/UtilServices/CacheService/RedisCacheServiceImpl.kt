package sg.flow.services.UtilServices.CacheService

import com.fasterxml.jackson.databind.ObjectMapper
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.stereotype.Service
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential
import sg.flow.services.UtilServices.UserIdAndInstitutionId
import java.time.Duration
import java.util.Optional

@Service
class RedisCacheServiceImpl(
    private val redisTemplate: ReactiveRedisTemplate<String, String>,
    private val objectMapper: ObjectMapper
) : CacheService {
    private val logger = LoggerFactory.getLogger(RedisCacheServiceImpl::class.java)

    private val ACCESS_TOKEN_PREFIX = "access_token:"
    private val FINVERSE_USER_INSTITUTION_PREFIX = "finverse:user:"
    private val FINVERSE_LOGIN_IDENTITY_PREFIX = "finverse:login_identity:"
    private val REFRESH_SESSION_PREFIX = "refresh_session:"
    private val COMPLETE_SESSION_PREFIX = "complet_refresh_session:"
    private val PRE_AUTH_SESSION_PREFIX = "preauth:"
    private val POST_AUTH_RESULT_PREFIX = "postauth:"
    private val EMAIL_VERIFICATION_SESSION_PREFIX = "email_verification:"
    private val TOKEN_TTL = Duration.ofHours(1) // 1 hour TTL for tokens
    private val SESSION_TTL = Duration.ofSeconds(90) // 1.5 minutes for refresh sessions
    private val PRE_AUTH_SESSION_TTL = Duration.ofMinutes(5) // 5 minutes for pre-auth sessions

    fun getRefreshSessionPrefix(loginIdentityId: String): String {
        return "$REFRESH_SESSION_PREFIX{$loginIdentityId}"
    }

    fun getCompleteRefreshSessionPrefix(loginIdentityId: String): String {
        return "$COMPLETE_SESSION_PREFIX{$loginIdentityId}"
    }

    fun getPreAuthSessionKey(state: String): String {
        return "$PRE_AUTH_SESSION_PREFIX$state"
    }

    fun getPreAuthSessionFromUserIdKey(userId: Int, institutionId: String): String {
        return PRE_AUTH_SESSION_PREFIX + "user:$userId:$institutionId"
    }

    fun getPostAuthKey(userId: Int, institutionId: String): String {
        return "$POST_AUTH_RESULT_PREFIX$userId:$institutionId"
    }

    fun getEmailVerificationSessionKey(email: String, sessionId: String): String {
        return "$EMAIL_VERIFICATION_SESSION_PREFIX$email:$sessionId"
    }

    fun getEmailVerificationSessionWildcardKey(email: String): String {
        return "$EMAIL_VERIFICATION_SESSION_PREFIX$email:*"
    }

    override fun getUserIdByAccessToken(token: String): Optional<Int> {
        val key = ACCESS_TOKEN_PREFIX + token
        return try {
            val userId = redisTemplate.opsForValue()
                .get(key)
                .block()

            if (userId != null) {
                Optional.of(userId.toInt())
            } else {
                Optional.empty()
            }
        } catch (e: Exception) {
            Optional.empty()
        }
    }

    override fun storeAccessToken(userId: Int, accessToken: String) {
        val key = ACCESS_TOKEN_PREFIX + accessToken
        redisTemplate.opsForValue()
            .set(key, userId.toString(), TOKEN_TTL)
            .block()
    }

    override suspend fun clearAccessToken(token: String) {
        val key = ACCESS_TOKEN_PREFIX + token
        redisTemplate.opsForValue()
            .delete(key)
            .block()
    }

    override suspend fun storeUserIdByLoginIdentityId(loginIdentityId: String, loginIdentityToken: String, userId: Int, institutionId: String, refreshAllowed: Boolean) {
        try {
            clearLoginIdentityCacheFor(userId, institutionId)

            val credential = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)
            val credentialJson = objectMapper.writeValueAsString(credential)

            val loginIdentityUserIdKey = "$FINVERSE_LOGIN_IDENTITY_PREFIX$loginIdentityId"
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            val loginIdentityTokenKey = "${FINVERSE_LOGIN_IDENTITY_PREFIX}${loginIdentityId}:token"
            val userIdAndInstitutionIdStr = objectMapper.writeValueAsString(
                UserIdAndInstitutionId(
                    userId,
                    institutionId
                )
            )

            redisTemplate.opsForValue()
                .set(loginIdentityUserIdKey, userIdAndInstitutionIdStr, TOKEN_TTL)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .set(userInstitutionKey, credentialJson, TOKEN_TTL)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .set(loginIdentityTokenKey, loginIdentityToken, TOKEN_TTL)
                .awaitSingleOrNull()

        } catch (e: Exception) {
            // Log error but don't throw to maintain compatibility
            logger.error("Error saving login identity token to Redis: ${e.message}")
        }
    }

    private suspend fun clearLoginIdentityCacheFor(userId: Int, institutionId: String) {
        val loginIdentityCred = getLoginIdentityCredential(userId, institutionId)

        if (loginIdentityCred != null) {
            val loginIdentityId = loginIdentityCred.loginIdentityId

            val loginIdentityUserIdKey = "$FINVERSE_LOGIN_IDENTITY_PREFIX$loginIdentityId"
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            val loginIdentityTokenKey = "${FINVERSE_LOGIN_IDENTITY_PREFIX}${loginIdentityId}:token"

            redisTemplate.opsForValue()
                .delete(loginIdentityUserIdKey)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .delete(userInstitutionKey)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .delete(loginIdentityTokenKey)
                .awaitSingleOrNull()
        }
    }

    override suspend fun getUserIdAndInstitutionIdByLoginIdentityId(
        loginIdentityId: String
    ): Optional<UserIdAndInstitutionId> {
        val key = FINVERSE_LOGIN_IDENTITY_PREFIX + loginIdentityId

        return try {
            val raw: String? = redisTemplate
                .opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (raw.isNullOrBlank()) {
                Optional.empty()
            } else {
                val dto = objectMapper.readValue(raw, UserIdAndInstitutionId::class.java)
                Optional.of(dto)
            }
        } catch (e: Exception) {
            Optional.empty()
        }
    }

    override suspend fun userHasLoginIdentity(userId: Int, institutionId: String): Boolean {
        val credential = getLoginIdentityCredential(userId, institutionId)
        return credential != null
    }

    override suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential? {
        return try {
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            val credentialJson = redisTemplate.opsForValue()
                .get(userInstitutionKey)
                .awaitSingleOrNull()

            if (credentialJson != null) {
                objectMapper.readValue(credentialJson, FinverseLoginIdentityCredential::class.java)
            } else {
                null
            }
        } catch (e: Exception) {
            logger.error("Error retrieving login identity credential from Redis: ${e.message}")
            null
        }
    }

    override suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        return try {
            val loginIdentityTokenKey = "${FINVERSE_LOGIN_IDENTITY_PREFIX}${loginIdentityId}:token"
            val token = redisTemplate.opsForValue()
                .get(loginIdentityTokenKey)
                .awaitSingleOrNull()

            token ?: ""
        } catch (e: Exception) {
            logger.error("Error retrieving login identity token from Redis: ${e.message}")
            ""
        }
    }

    override suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return try {
            val loginIdentity = getLoginIdentityCredential(userId, institutionId)
            if (loginIdentity == null) {
                return false
            }
            val sessionKey = getRefreshSessionPrefix(loginIdentity.loginIdentityId)
            val session = redisTemplate.opsForHash<String, String>()
                .get(sessionKey, "value")
                .awaitSingleOrNull()

            session != null
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error checking refresh session status from Redis: User ID: $userId, institution Id: $institutionId")
            false
        }
    }

    override suspend fun getInstitutionIdOfRunningRefreshSession(
        userId: Int,
        allInstitutionIds: List<String>
    ): List<String> {
        val result: MutableList<String> = mutableListOf()
        for (institutionId in allInstitutionIds) {
            if (doesUserHasRunningRefreshSession(userId, institutionId)) {
                result.add(institutionId)
            } else {
                result.add("")
            }
        }

        return result
    }

    override suspend fun clearRefreshSession(loginIdentityId: String) {
        try {
            redisTemplate.delete(getRefreshSessionPrefix(loginIdentityId)).awaitSingleOrNull()

        } catch (e: Exception) {
            logger.error("Error clearing refresh session cache from Redis: ${e.message}")
        }
    }


    override suspend fun getRefreshSession(
        loginIdentityId: String
    ): FinverseDataRetrievalRequest? {
        try {
            val sessionKey = getRefreshSessionPrefix(loginIdentityId)
            val sessionJson = redisTemplate.opsForHash<String, String>()
                .get(sessionKey, "value")
                .awaitSingleOrNull()

            return if (sessionJson != null) {
                objectMapper.readValue(sessionJson, FinverseDataRetrievalRequest::class.java)
            } else {
                null
            }
        }
        catch(e: Exception) {
            logger.error("Error retrieving data retrieval request: ${e.message}")
            return null
        }
    }

    override suspend fun storePreAuthSession(userId: Int, institutionId: String, state: String) {
        try {
            clearPreAuthSessionForUser(userId, institutionId)

            val key = getPreAuthSessionKey(state)
            val userIdAndInstitutionIdObj = UserIdAndInstitutionId(userId, institutionId)
            val jsonString = objectMapper.writeValueAsString(userIdAndInstitutionIdObj)

            val fromUserKey = getPreAuthSessionFromUserIdKey(userId, institutionId)

            redisTemplate.opsForValue()
                .set(key, jsonString, PRE_AUTH_SESSION_TTL)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .set(fromUserKey, state, PRE_AUTH_SESSION_TTL)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            logger.error("Error trying to store Pre Auth Session Cache: Error: ${e.message} FOR: $userId, $institutionId, $state")
        }
    }

    override suspend fun getPreAuthSession(state: String): UserIdAndInstitutionId {
        return try {
            val key = getPreAuthSessionKey(state)

            val userIdInstitutionJsonString = redisTemplate.opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (userIdInstitutionJsonString != null) {
                objectMapper.readValue(userIdInstitutionJsonString, UserIdAndInstitutionId::class.java)
            } else {
                UserIdAndInstitutionId(-1, "")
            }
        } catch (e: Exception) {
            logger.error("Failed to get UserId and InstitutionId for given state: ${e.message} FOR: $state")
            return UserIdAndInstitutionId(-1, "")
        }
    }

    override suspend fun checkIfPreAuthExists(userId: Int, institutionId: String): Boolean {
        try {
            val json = getPreAuthStateFor(userId, institutionId)
            return !json.isEmpty()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to check if pre auth exists for user: $userId $institutionId")
            return false
        }
    }

    override suspend fun clearPreAuthSession(state: String) {
        try {
            val key = getPreAuthSessionKey(state)

            val userIdAndInstitutionId = getPreAuthSession(state)
            val fromUserKey = getPreAuthSessionFromUserIdKey(userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)

            redisTemplate.opsForValue()
                .delete(key)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .delete(fromUserKey)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            logger.error("Failed to clear cache for pre auth session: ${e.message} FOR: $state")
        }
    }

    private suspend fun clearPreAuthSessionForUser(userId: Int, institutionId: String) {
        try {
            val state = getPreAuthStateFor(userId, institutionId)

            if (state.isEmpty()) {
                return
            }

            val key = getPreAuthSessionKey(state)

            val userIdAndInstitutionId = getPreAuthSession(state)
            val fromUserKey = getPreAuthSessionFromUserIdKey(userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)

            redisTemplate.opsForValue()
                .delete(key)
                .awaitSingleOrNull()

            redisTemplate.opsForValue()
                .delete(fromUserKey)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            logger.error("Failed to clear cache for user: ${e.message} FOR $userId, $institutionId")
        }
    }

    override suspend fun getPreAuthStateFor(userId: Int, institutionId: String): String {
        try {
            val key = getPreAuthSessionFromUserIdKey(userId, institutionId)

            val userIdInstitutionJsonString = redisTemplate.opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (userIdInstitutionJsonString != null) {
                return userIdInstitutionJsonString
            } else {
                return ""
            }

        } catch (e: Exception) {
            logger.error("Failed to get pre-auth state from user ID and institution ID: ${e.message} FOR $userId, $institutionId")
            return ""
        }
    }

    override suspend fun storeFinalAuth(userId: Int, institutionId: String, authStatus: FinverseAuthenticationStatus) {
        try {
            val key = getPostAuthKey(userId, institutionId)
            val jsonStatus = objectMapper.writeValueAsString(authStatus)

            redisTemplate.opsForValue()
                .set(key, jsonStatus, SESSION_TTL)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to store final authentication result: ${e.message} FOR $userId, $institutionId")
        }
    }

    override suspend fun getFinalAuth(userId: Int, institutionId: String): FinverseAuthenticationStatus? {
        return try {
            val key = getPostAuthKey(userId, institutionId)

            val jsonString = redisTemplate.opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (jsonString != null) {
               objectMapper.readValue(jsonString, FinverseAuthenticationStatus::class.java)
            } else {
                null
            }

        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to get final authentication result: ${e.message} FOR $userId, $institutionId")
            FinverseAuthenticationStatus.FAILED
        }
    }

    override suspend fun clearFinalAuth(userId: Int, institutionId: String) {
        try {
            val key = getPostAuthKey(userId, institutionId)

            redisTemplate.opsForValue()
                .delete(key)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to delete post auth key for $userId:$institutionId")
        }
    }

    override suspend fun storeEmailValidationSessionData(
        email: String,
        sessionId: String,
        payload: String,
        ttl: Duration
    ) {
        try {
            val key = getEmailVerificationSessionKey(email, sessionId)

            redisTemplate.opsForValue()
                .set(key, payload, ttl)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to store email validation session payload: email: $email, sessionId: $sessionId")
        }
    }

    override suspend fun getEmailValidationSessionData(email: String, sessionId: String): String {
        try {
            val key = getEmailVerificationSessionKey(email, sessionId)

            val result = redisTemplate.opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (result == null) {
                return ""
            }
            return result
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to fetch stored email validation session payload: email: $email, sessionID: $sessionId")
            return ""
        }
    }

    override suspend fun removeEmailValidationSessionData(
        email: String,
        sid: String
    ): Boolean {
        try {
            val key = getEmailVerificationSessionKey(email, sid)

            redisTemplate.opsForValue()
                .delete(key)
                .awaitSingleOrNull()

            return true
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error removing stored email validation session payload: email: $email, session ID: $sid")
            return false
        }
    }

    override suspend fun storeFinishedRefreshSession(loginIdentityId: String) {
        try {
            val key = getCompleteRefreshSessionPrefix(loginIdentityId)

            redisTemplate.opsForValue()
                .set(key, "true")
                .awaitSingleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error while storing finished refresh session")
        }
    }

    override suspend fun getFinishedRefreshSession(loginIdentityId: String): Boolean {
        try {
            val key = getCompleteRefreshSessionPrefix(loginIdentityId)

            val result = redisTemplate.opsForValue()
                .get(key)
                .awaitSingleOrNull()

            if (result == null) {
                return false
            }
            return true
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error while fetching finished refresh session")
            return false
        }
    }

    override suspend fun clearFinishedRefreshSession(loginIdentityId: String) {
        try {
            val key = getCompleteRefreshSessionPrefix(loginIdentityId)

            redisTemplate.opsForValue()
                .delete(key)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error while clearing finished refresh session")
            return
        }
    }
}