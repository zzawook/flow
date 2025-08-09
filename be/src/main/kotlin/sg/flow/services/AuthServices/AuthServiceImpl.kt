package sg.flow.services.AuthServices

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Service
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.VaultService

@Service
class AuthServiceImpl(
        private val cacheService: CacheService,
        private val vaultService: VaultService,
        private val tokenService: FlowTokenService,
) : AuthService {

    override suspend fun registerUser(request: AuthRequest): TokenSet =
            withContext(Dispatchers.IO) {
                // TODO replace with real authentication logic (e.g., Singpass)
                val tokenSet = TokenSet("accessToken", "refreshToken")
                cacheService.storeAccessToken(1, tokenSet.accessToken)
                vaultService.storeAccessToken(1, tokenSet.accessToken)
                vaultService.storeRefreshToken(1, tokenSet.refreshToken)
                tokenSet
            }

    override suspend fun getAccessTokenByRefreshToken(
            request: AccessTokenRefreshRequest
    ): TokenSet? =
            withContext(Dispatchers.IO) {
                tokenService.getAccessTokenByRefreshToken(request.refreshToken)
            }
}
