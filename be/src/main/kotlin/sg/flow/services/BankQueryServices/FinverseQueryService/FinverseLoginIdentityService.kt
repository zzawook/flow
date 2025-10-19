package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.reactor.awaitSingle
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Component
import reactor.core.publisher.Mono
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.LoginIdentity
import sg.flow.models.finverse.responses.FinverseAuthTokenResponse
import sg.flow.models.finverse.responses.FinverseLoginIdentityResponse
import sg.flow.repositories.loginIdentity.LoginIdentityRepository
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.UserIdAndInstitutionId

@Component
class FinverseLoginIdentityService(
    private val cacheService: CacheService,
    private val loginIdentityRepository: LoginIdentityRepository,
    private val finverseWebclientService: FinverseWebclientService,
) {
    private val logger = LoggerFactory.getLogger(FinverseLoginIdentityService::class.java)

    suspend fun fetchLoginIdentityToken(userId: Int, code: String, institutionId: String): String {
        val finverseAuthTokenResponse: FinverseAuthTokenResponse = finverseWebclientService.fetchLoginIdentity(code)

        val loginIdentityDetailResponse: FinverseLoginIdentityResponse = finverseWebclientService.fetchLoginIdentityInfo(finverseAuthTokenResponse.loginIdentityToken)

        saveAndCacheLoginIdentityToken(
            userId,
            institutionId,
            finverseAuthTokenResponse.loginIdentityId,
            finverseAuthTokenResponse.loginIdentityToken,
            finverseAuthTokenResponse.refreshToken,
            loginIdentityDetailResponse.loginIdentity.refresh.refreshAllowed
        )

        return finverseAuthTokenResponse.loginIdentityId
    }

    suspend fun saveAndCacheLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String,
        loginIdentityRefreshToken: String,
        refreshAllowed: Boolean
    ) {
        loginIdentityRepository.saveOrUpdateLoginIdentity(LoginIdentity(
            userId,
            institutionId,
            loginIdentityId,
            loginIdentityRefreshToken,
            refreshAllowed
        ))
        cacheService.storeUserIdByLoginIdentityId(loginIdentityId, loginIdentityToken, userId, institutionId, refreshAllowed)
    }

    suspend fun refreshLoginIdentityToken(loginIdentityId: String): Mono<String> {
        val loginIdentity = loginIdentityRepository.getLoginIdentity(loginIdentityId)

        if (loginIdentity == null) {
            logger.error("Cannot refresh Login Identity Token, as login identity ID provided was not found: $loginIdentityId")
            return Mono.empty()
        }

        val finverseAuthTokenResponse: FinverseAuthTokenResponse = finverseWebclientService.refreshLoginIdentityToken(loginIdentity.loginIdentityRefreshToken)

        val newLoginIdentity = LoginIdentity(
            loginIdentity.userId,
            loginIdentity.finverseInstitutionId,
            finverseAuthTokenResponse.loginIdentityId,
            finverseAuthTokenResponse.refreshToken,
            loginIdentity.refreshAllowed
        )

        loginIdentityRepository.saveOrUpdateLoginIdentity(newLoginIdentity)
        cacheService.storeUserIdByLoginIdentityId(
            newLoginIdentity.loginIdentityId,
            finverseAuthTokenResponse.loginIdentityToken,
            newLoginIdentity.userId,
            newLoginIdentity.finverseInstitutionId,
            newLoginIdentity.refreshAllowed
        )

        return Mono.just(finverseAuthTokenResponse.loginIdentityToken)
    }

    suspend fun getUserIdAndInstitutionId(loginIdentityId: String): UserIdAndInstitutionId? {
        val userIdAndInstitutionIdOptional = cacheService.getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId)
        if (! userIdAndInstitutionIdOptional.isEmpty) {
            return userIdAndInstitutionIdOptional.get()
        }

        val loginIdentity = loginIdentityRepository.getLoginIdentity(loginIdentityId)

        if (loginIdentity != null) {
            refreshLoginIdentityToken(loginIdentityId)
                .doOnError { e ->
                    logger.error("Failed to refresh login token for $loginIdentityId", e)
                }.subscribe()
            return UserIdAndInstitutionId(
                loginIdentity.userId,
                loginIdentity.finverseInstitutionId
            )
        }

        logger.error("FAILED TO GET USER ID AND INSTITUTION ID FROM GIVEN LOGIN IDENTITY ID: $loginIdentityId")
        return UserIdAndInstitutionId(-1, "")
    }

    suspend fun getLoginIdentityTokenWithLoginIdentityID(loginIdentityId: String): String {
        var token = cacheService.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)

        if (token.isEmpty()) {
            token = refreshLoginIdentityToken(loginIdentityId).awaitSingle()
        }

        return token
    }

    suspend fun getLoginIdentityTokenWithUserIdAndInstitutionId(userId: Int, institutionId: String): String {
        var token = cacheService.getLoginIdentityCredential(userId, institutionId)?.loginIdentityToken

        if (token == null || token.isEmpty()) {
            val loginIdentity = loginIdentityRepository.getLoginIdentity(userId, institutionId)
            if (loginIdentity == null) {
                return "NO LOGIN IDENTITY FOUND"
            }
            token = refreshLoginIdentityToken(loginIdentity.loginIdentityId).awaitSingle()
        }

        return token
    }

    suspend fun getLoginIdentityIdWithUserIdAndInstitutionId(userId: Int, institutionId: String): String {
        var loginIdentityId = cacheService.getLoginIdentityCredential(userId, institutionId)?.loginIdentityId

        if (loginIdentityId == null || loginIdentityId.isEmpty()) {
            val loginIdentity = loginIdentityRepository.getLoginIdentity(userId, institutionId)
            if (loginIdentity == null) {
                return "NO LOGIN IDENTITY FOUND"
            }
            loginIdentityId = refreshLoginIdentityToken(loginIdentity.loginIdentityId).awaitSingle()
        }

        return loginIdentityId
    }

    suspend fun getIsRefreshAllowed(userId: Int, institutionId: String): Boolean {
        val loginIdentity = loginIdentityRepository.getLoginIdentity(userId, institutionId)

        if (loginIdentity == null) {
            logger.error("Failed to fetch login identity for userID: $userId, institution ID: $institutionId")
            return false
        }

        return loginIdentity.refreshAllowed
    }

    suspend fun getRefreshSession(loginIdentityId: String): FinverseDataRetrievalRequest? {
        return cacheService.getRefreshSession(loginIdentityId)
    }

    suspend fun hasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return cacheService.doesUserHasRunningRefreshSession(userId, institutionId)
    }

    suspend fun finishRefreshSession(loginIdentityId: String) {
        cacheService.storeFinishedRefreshSession(loginIdentityId)
        cacheService.clearRefreshSession(loginIdentityId)
    }

    suspend fun startPreAuthSession(userId: Int, institutionId: String, state: String) {
        cacheService.storePreAuthSession(userId, institutionId, state)
    }

    suspend fun getUserIdAndInstitutionIdFromState(state: String): UserIdAndInstitutionId {
        return cacheService.getPreAuthSession(state)
    }

    suspend fun clearPreAuthSession(state: String) {
        cacheService.clearPreAuthSession(state)
    }

    suspend fun storePostAuthResult(userId: Int, institutionId: String, authStatus: FinverseAuthenticationStatus) {
        cacheService.storeFinalAuth(userId, institutionId, authStatus)
    }
}