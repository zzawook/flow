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
                generateAndStoreRefreshToken(userId)
            }

    override suspend fun generateAndStoreAccessToken(refreshToken: String): TokenSet? =
            withContext(Dispatchers.IO) {
                val userId =
                        vaultService.getUserIdByRefreshToken(refreshToken).orElse(null)
                                ?: return@withContext null
                generateAndStoreRefreshToken(userId)
            }

    override suspend fun generateAndStoreRefreshToken(userId: Int): TokenSet =
            withContext(Dispatchers.IO) {
                val refreshToken = jwtTokenProvider.generateRefreshToken(userId)
                val accessToken = jwtTokenProvider.generateAccessToken(refreshToken)

                cacheService.storeAccessToken(userId, accessToken)
                vaultService.storeRefreshToken(userId, refreshToken)

                TokenSet(accessToken = accessToken, refreshToken = refreshToken)
            }
}
