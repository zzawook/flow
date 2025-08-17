package sg.flow.services.UtilServices

import com.fasterxml.jackson.databind.ObjectMapper
import kotlinx.coroutines.reactive.awaitFirstOrNull
import org.slf4j.LoggerFactory
import java.util.Optional
import org.springframework.stereotype.Service
import org.springframework.vault.core.ReactiveVaultTemplate
import org.springframework.vault.core.VaultKeyValueOperationsSupport.KeyValueBackend
import sg.flow.models.finverse.LoginIdentity
import java.security.MessageDigest
import java.util.Base64

@Service
class VaultServiceImpl(
    private val vaultTemplate: ReactiveVaultTemplate,
    private val objectMapper: ObjectMapper
) : VaultService {
    private val logger = LoggerFactory.getLogger(VaultServiceImpl::class.java)

    private val kv = vaultTemplate.opsForKeyValue("secret", KeyValueBackend.KV_2)

    private val LOGIN_IDENTITY_BY_LOGIN_IDENTITY_ID = "login_identity/by_login_identity_id/"
    private val LOGIN_IDENTITY_BY_USERID_AND_INSTITUTION_ID = "login_identity/by_user_id_and_institution_id/"

    private val USER_ID_BY_REFRESH_TOKEN = "refresh_token/by_token/"
    private val REFRESH_TOKEN_BY_USER_ID = "refresh_token/by_user_id/"

    private fun generateUserIdByRefreshTokenKey(refreshToken: String) : String {
        return USER_ID_BY_REFRESH_TOKEN + keyFor(refreshToken)
    }

    private fun generateRefreshTokenByUserIdKey(userId: Int): String {
        return REFRESH_TOKEN_BY_USER_ID + userId
    }

    private fun generateLoginIdentityByLoginIdentityIdKey(loginIdentityId: String): String {
        return LOGIN_IDENTITY_BY_LOGIN_IDENTITY_ID + loginIdentityId
    }

    private fun generateLoginIdentityByUserIdAndInstitutionIdKey(userId: Int, institution_id: String): String {
        return "$LOGIN_IDENTITY_BY_USERID_AND_INSTITUTION_ID$userId/$institution_id"
    }

    private fun keyFor(refreshToken: String): String {
        val digest = MessageDigest.getInstance("SHA-256").digest(refreshToken.toByteArray())
        val b64 = Base64.getUrlEncoder().withoutPadding().encodeToString(digest)
        return b64
    }

    override suspend fun getUserIdByRefreshToken(token: String): Optional<Int> {
        val key = generateUserIdByRefreshTokenKey(token)

        val versioned = kv.get(key).awaitFirstOrNull()?.data
        if (versioned == null) {
            logger.error("User ID with given refresh token does not exist - Refresh token was not found")
            return Optional.empty()
        }
        val userId = (versioned["UserID"] as? Number)?.toInt()

        if (userId == null) {
            logger.error("User ID with given refresh token does not exist - User ID fetched was null")
            return Optional.empty()
        }

        return Optional.of(userId)
    }

    override suspend fun storeRefreshToken(userId: Int, refreshToken: String) {
        val keyByRefreshToken = generateUserIdByRefreshTokenKey(refreshToken)
        val keyByUserId = generateRefreshTokenByUserIdKey(userId)

        try {
            kv.put(keyByRefreshToken, mapOf("UserID" to userId)).awaitFirstOrNull()
            kv.put(keyByUserId, mapOf("RefreshToken" to refreshToken)).awaitFirstOrNull()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Error while storing refresh token")
            return
        }
    }

    override suspend fun getRefreshTokenForUserId(userId: Int): Optional<String> {
        val key = generateRefreshTokenByUserIdKey(userId)

        val versioned = kv.get(key).awaitFirstOrNull()?.data
        if (versioned == null) {
            logger.error("Refresh Token for give user ID does not exist")
            return Optional.empty()
        }
        val userId = (versioned["RefreshToken"] as? String)

        if (userId == null) {
            logger.error("Refresh Token for give user ID does not exist")
            return Optional.empty()
        }
        return Optional.of(userId)
    }

    override suspend fun saveOrUpdateLoginIdentity(loginIdentity: LoginIdentity) {
        val keyByLIID = generateLoginIdentityByLoginIdentityIdKey(loginIdentity.loginIdentityId)

        val userId = loginIdentity.userId
        val institutionId = loginIdentity.finverseInstitutionId
        val keyByUserIdAndInstitutionId = generateLoginIdentityByUserIdAndInstitutionIdKey(userId, institutionId)

        kv.put(
            keyByLIID,
            loginIdentity
        ).awaitFirstOrNull()
        kv.put(
            keyByUserIdAndInstitutionId,
            loginIdentity
        ).awaitFirstOrNull()
    }

    override suspend fun deleteLoginIdentity(loginIdentity: LoginIdentity) {
        val keyByLIID = generateLoginIdentityByLoginIdentityIdKey(loginIdentity.loginIdentityId)

        val userId = loginIdentity.userId
        val institutionId = loginIdentity.finverseInstitutionId

        val keyByUserIdAndInstitutionId = generateLoginIdentityByUserIdAndInstitutionIdKey(userId, institutionId)

        kv.delete(keyByLIID).awaitFirstOrNull()
        kv.delete(keyByUserIdAndInstitutionId).awaitFirstOrNull()
    }

    override suspend fun deleteLoginIdentity(userId: Int, institutionId: String) {
        val keyByUserIdAndInstitutionId = generateLoginIdentityByUserIdAndInstitutionIdKey(userId, institutionId)
        val loginIdentity = getLoginIdentity(userId, institutionId,)

        if (loginIdentity == null) {
            logger.error("Failed to find login identity with userId and institution ID of: $userId, $institutionId")
            return
        }
        val keyByLIID = generateLoginIdentityByLoginIdentityIdKey(loginIdentity.loginIdentityId)

        kv.delete(keyByLIID)
        kv.delete(keyByUserIdAndInstitutionId)
    }

    override suspend fun getLoginIdentity(
        userId: Int,
        institutionId: String
    ): LoginIdentity? {
        val key = generateLoginIdentityByUserIdAndInstitutionIdKey(userId, institutionId)

        val data: Map<String, Any?> = kv.get(key)
            .awaitFirstOrNull()
            ?.data
            ?: run {
                logger.error("Login Identity not found for user=$userId institution=$institutionId")
                return null
            }

        // objectMapper is the one Spring injects into your beans
        return objectMapper.convertValue(data, LoginIdentity::class.java)
    }

    override suspend fun getLoginIdentity(loginIdentityId: String): LoginIdentity? {
        val key = generateLoginIdentityByLoginIdentityIdKey(loginIdentityId)

        val data: Map<String, Any?> = kv.get(key)
            .awaitFirstOrNull()
            ?.data
            ?: run {
                logger.error("Login Identity not found for Login Identity Id: $loginIdentityId")
                return null
            }

        // objectMapper is the one Spring injects into your beans
        return objectMapper.convertValue(data, LoginIdentity::class.java)
    }


}