package sg.flow.services.UtilServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.util.Optional
import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.springframework.context.annotation.Profile
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.stereotype.Service
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import java.time.Duration

@Service
//@Profile("prod")
class RedisCacheServiceImpl(
    private val redisTemplate: ReactiveRedisTemplate<String, String>,
    private val objectMapper: ObjectMapper
) : CacheService {
    
    private val ACCESS_TOKEN_PREFIX = "access_token:"
    private val FINVERSE_USER_INSTITUTION_PREFIX = "finverse:user:"
    private val FINVERSE_LOGIN_IDENTITY_USER_PREFIX = "finverse:login_identity:"
    private val FINVERSE_LOGIN_IDENTITY_TOKEN_PREFIX = "finverse:login_identity:"
    private val REFRESH_SESSION_PREFIX = "refresh_session:"
    private val TOKEN_TTL = Duration.ofHours(1) // 1 hour TTL for tokens
    private val SESSION_TTL = Duration.ofSeconds(90) // 1.5 minutes for refresh sessions

    fun getRefreshSessionPrefix(userId: Int, institutionId: String): String {
        return "$REFRESH_SESSION_PREFIX$userId:$institutionId:"
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

    override suspend fun storeUserIdByLoginIdentityId(loginIdentityId: String, loginIdentityToken: String, userId: Int, institutionId: String) {
        try {
            val credential = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)
            val credentialJson = objectMapper.writeValueAsString(credential)

            val loginIdentityUserId = "$FINVERSE_LOGIN_IDENTITY_USER_PREFIX$loginIdentityId"
            val userIdAndInstitutionIdStr = objectMapper.writeValueAsString(UserIdAndInstitutionId(
                userId,
                institutionId
            ))

            redisTemplate.opsForValue()
                .set(loginIdentityUserId, userIdAndInstitutionIdStr, TOKEN_TTL)
                .awaitSingleOrNull()

            // Store user-institution mapping to credential
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            redisTemplate.opsForValue()
                .set(userInstitutionKey, credentialJson, TOKEN_TTL)
                .awaitSingleOrNull()

            // Store reverse mapping: loginIdentityId -> userId
            val loginIdentityUserKey = "${FINVERSE_LOGIN_IDENTITY_USER_PREFIX}${loginIdentityId}:user_id:${institutionId}"
            redisTemplate.opsForValue()
                .set(loginIdentityUserKey, userId.toString(), TOKEN_TTL)
                .awaitSingleOrNull()

            // Store loginIdentityId -> token mapping
            val loginIdentityTokenKey = "${FINVERSE_LOGIN_IDENTITY_TOKEN_PREFIX}${loginIdentityId}:token"
            redisTemplate.opsForValue()
                .set(loginIdentityTokenKey, loginIdentityToken, TOKEN_TTL)
                .awaitSingleOrNull()

        } catch (e: Exception) {
            // Log error but don't throw to maintain compatibility
            println("Error saving login identity token to Redis: ${e.message}")
        }
    }

    override suspend fun getUserIdAndInstitutionIdByLoginIdentityId(
        loginIdentityId: String
    ): Optional<UserIdAndInstitutionId> {
        val key = FINVERSE_LOGIN_IDENTITY_USER_PREFIX + loginIdentityId

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
            println("Error retrieving login identity credential from Redis: ${e.message}")
            null
        }
    }

    override suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        return try {
            val loginIdentityTokenKey = "${FINVERSE_LOGIN_IDENTITY_TOKEN_PREFIX}${loginIdentityId}:token"
            val token = redisTemplate.opsForValue()
                .get(loginIdentityTokenKey)
                .awaitSingleOrNull()
            
            token ?: ""
        } catch (e: Exception) {
            println("Error retrieving login identity token from Redis: ${e.message}")
            ""
        }
    }

    override suspend fun doesUserHasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return try {
            val sessionKey = getRefreshSessionPrefix(userId, institutionId)
            val session = redisTemplate.opsForValue()
                .get(sessionKey)
                .awaitSingleOrNull()
            
            session != null
        } catch (e: Exception) {
            println("Error checking refresh session status from Redis: ${e.message}")
            false
        }
    }

    override suspend fun clearRefreshSessionCache(userId: Int, institutionId: String) {
        try {
            val keysToDelete = mutableListOf<String>()

            // Add the refresh session key for this specific user-institution pair
            keysToDelete.add(getRefreshSessionPrefix(userId, institutionId))
            
            // Delete all keys in batch
            if (keysToDelete.isNotEmpty()) {
                redisTemplate.delete(*keysToDelete.toTypedArray()).awaitSingleOrNull()
                println("Cleared ${keysToDelete.size} cache entries for user $userId, institution $institutionId refresh session")
            }
            
        } catch (e: Exception) {
            println("Error clearing refresh session cache from Redis: ${e.message}")
        }
    }
    
    // Helper method to mark a refresh session as started for a specific user-institution pair
    override suspend fun startRefreshSession(userId: Int, institutionId: String, request: FinverseDataRetrievalRequest) {
        try {
            val dataRequestKey = getRefreshSessionPrefix(userId, institutionId)
            val jsonString = objectMapper.writeValueAsString(request)
            redisTemplate.opsForValue()
                .set(dataRequestKey, jsonString, SESSION_TTL)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            println("Error starting refresh session in Redis: ${e.message}")
        }
    }

    override suspend fun updateDataRetrievalRequest(
        userId: Int,
        institutionId: String,
        request: FinverseDataRetrievalRequest
    ) {
        startRefreshSession(userId, institutionId, request)
    }

    override suspend fun getDataRetrievalRequest(
        userId: Int,
        institutionId: String
    ): FinverseDataRetrievalRequest? {
        try {
            val sessionKey = getRefreshSessionPrefix(userId, institutionId)
            val sessionJson = redisTemplate.opsForValue()
                .get(sessionKey)
                .awaitSingleOrNull()

            return if (sessionJson != null) {
                objectMapper.readValue(sessionJson, FinverseDataRetrievalRequest::class.java)
            } else {
                null
            }
        }
        catch(e: Exception) {
            println("Error retrieving data retrieval request: ${e.message}")
            return null
        }
    }

    override suspend fun removeDataRetrievalRequest(userId: Int) {
        TODO("Not yet implemented")
    }
}
