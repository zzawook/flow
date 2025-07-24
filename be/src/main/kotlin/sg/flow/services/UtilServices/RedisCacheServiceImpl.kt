package sg.flow.services.UtilServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.util.Optional
import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.springframework.context.annotation.Profile
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.stereotype.Service
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityCredential
import java.time.Duration

@Service
//@Profile("prod")
class RedisCacheServiceImpl(
    private val redisTemplate: ReactiveRedisTemplate<String, String>,
    private val objectMapper: ObjectMapper
) : CacheService {
    
    private val ACCESS_TOKEN_PREFIX = "access_token:"
    private val LOGIN_IDENTITY_PREFIX = "login_identity:"
    private val FINVERSE_USER_INSTITUTION_PREFIX = "finverse:user:"
    private val FINVERSE_LOGIN_IDENTITY_USER_PREFIX = "finverse:login_identity:"
    private val FINVERSE_LOGIN_IDENTITY_TOKEN_PREFIX = "finverse:login_identity:"
    private val REFRESH_SESSION_PREFIX = "refresh_session:"
    private val TOKEN_TTL = Duration.ofHours(24) // 24 hour TTL for tokens
    private val SESSION_TTL = Duration.ofMinutes(30) // 30 minutes for refresh sessions
    
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

    override fun storeUserIdByLoginIdentityId(loginIdentityId: String, userId: Int) {
        val key = LOGIN_IDENTITY_PREFIX + loginIdentityId
        redisTemplate.opsForValue()
            .set(key, userId.toString(), TOKEN_TTL)
            .block()
    }

    override fun getUserIdByLoginIdentityId(loginIdentityId: String): Optional<Int> {
        val key = LOGIN_IDENTITY_PREFIX + loginIdentityId
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

    override suspend fun saveLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String
    ) {
        try {
            val credential = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)
            val credentialJson = objectMapper.writeValueAsString(credential)
            
            // Store user-institution mapping to credential
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            redisTemplate.opsForValue()
                .set(userInstitutionKey, credentialJson, TOKEN_TTL)
                .awaitSingleOrNull()
            
            // Store reverse mapping: loginIdentityId -> userId
            val loginIdentityUserKey = "${FINVERSE_LOGIN_IDENTITY_USER_PREFIX}${loginIdentityId}:user_id"
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
            val sessionKey = "${REFRESH_SESSION_PREFIX}${userId}:institution:${institutionId}"
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
            // Clear the specific user-institution credential
            val userInstitutionKey = "${FINVERSE_USER_INSTITUTION_PREFIX}${userId}:institution:${institutionId}"
            val credentialJson = redisTemplate.opsForValue().get(userInstitutionKey).awaitSingleOrNull()
            
            val keysToDelete = mutableListOf<String>()
            keysToDelete.add(userInstitutionKey)
            
            // If we have the credential, clean up related login identity keys
            if (credentialJson != null) {
                try {
                    val credential = objectMapper.readValue(credentialJson, FinverseLoginIdentityCredential::class.java)
                    val loginIdentityId = credential.loginIdentityId
                    
                    // Add related keys to deletion list
                    keysToDelete.add("${FINVERSE_LOGIN_IDENTITY_USER_PREFIX}${loginIdentityId}:user_id")
                    keysToDelete.add("${FINVERSE_LOGIN_IDENTITY_TOKEN_PREFIX}${loginIdentityId}:token")
                } catch (e: Exception) {
                    println("Error parsing credential JSON during cleanup: ${e.message}")
                }
            }
            
            // Add the refresh session key for this specific user-institution pair
            keysToDelete.add("${REFRESH_SESSION_PREFIX}${userId}:institution:${institutionId}")
            
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
    override suspend fun startRefreshSession(userId: Int, institutionId: String) {
        try {
            val sessionKey = "${REFRESH_SESSION_PREFIX}${userId}:institution:${institutionId}"
            redisTemplate.opsForValue()
                .set(sessionKey, "ACTIVE", SESSION_TTL)
                .awaitSingleOrNull()
        } catch (e: Exception) {
            println("Error starting refresh session in Redis: ${e.message}")
        }
    }
    
    // Helper method to get userId by loginIdentityId for Finverse (returns -1 if not found)
    suspend fun getUserIdByLoginIdentityIdFinverse(loginIdentityId: String): Int {
        return try {
            val loginIdentityUserKey = "${FINVERSE_LOGIN_IDENTITY_USER_PREFIX}${loginIdentityId}:user_id"
            val userId = redisTemplate.opsForValue()
                .get(loginIdentityUserKey)
                .awaitSingleOrNull()
            
            userId?.toInt() ?: -1
        } catch (e: Exception) {
            println("Error retrieving user ID by login identity from Redis: ${e.message}")
            -1
        }
    }
}
