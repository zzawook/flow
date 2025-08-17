package sg.flow.services.AuthServices

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import sg.flow.entities.User
import sg.flow.grpc.exception.InternalErrorException
import sg.flow.grpc.exception.InvalidCredentialException
import sg.flow.grpc.exception.TokenGenerationException
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import sg.flow.repositories.user.UserRepository
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.VaultService
import java.time.LocalDate
import java.util.Optional

@Service
class AuthServiceImpl(
        private val cacheService: CacheService,
        private val vaultService: VaultService,
        private val tokenService: FlowTokenService,
        private val userRepository: UserRepository,
        private val passwordEncoder: PasswordEncoder
) : AuthService {

    override suspend fun registerUser(email: String, name: String, password: String): TokenSet =
            withContext(Dispatchers.IO) {
                if (checkUserExists(email)) {
                    return@withContext getTokenSetForUser(email, password)
                }

                // POSSIBLY IMPLEMENT SINGPASS INTEGRATION
                var passwordEncoded: String
                try {
                    passwordEncoded = passwordEncoder.encode(password)
                    println(passwordEncoded)
                } catch (e: Exception) {
                    throw TokenGenerationException("Failed to encode given password")
                }

                var savedEntity: User
                try {
                    savedEntity = userRepository.save(
                        User(
                            name = name,
                            email = email,
                            id = null,
                            identificationNumber = "",
                            phoneNumber = "",
                            dateOfBirth = LocalDate.now(),
                            address = "",
                            passwordHash = passwordEncoded
                        )
                    )
                } catch (e: Exception) {
                    e.printStackTrace()
                    throw InternalErrorException("Failed to save user")
                }

                var userId: Int
                try {
                    userId = userRepository.getUserIdByEmail(savedEntity.email)
                } catch (e: Exception) {
                    e.printStackTrace()
                    throw InternalErrorException("Failed to get User ID from saved user")
                }

                var tokenSet: TokenSet? = null
                try {
                    tokenSet = tokenService.generateAndStoreRefreshTokenAndAccessToken(userId)
                } catch (e: Exception) {
                    e.printStackTrace()
                    throw TokenGenerationException("Failed to generate token for this user")
                }

                if (tokenSet == null) {
                    throw TokenGenerationException("Generated token was null")
                }

                try {
                    cacheService.storeAccessToken(1, tokenSet.accessToken)
                    vaultService.storeRefreshToken(1, tokenSet.refreshToken)
                } catch (e: Exception) {
                    e.printStackTrace()
                    throw InternalErrorException("Failed to store access token in cache / vault")
                }

                tokenSet
            }

    override suspend fun getTokenSetForUser(
        email: String,
        password: String
    ): TokenSet {
        return withContext(Dispatchers.IO) {
            val userIdAndPasswordHash = userRepository.getUserIdAndPasswordHashWithEmail(email)
            val doesMatch = passwordEncoder.matches(password, userIdAndPasswordHash.passwordHash)

            if (! doesMatch) {
                throw InvalidCredentialException("Password does not match")
            }

            val userId = userIdAndPasswordHash.userId
            val refreshToken: Optional<String> = vaultService.getRefreshTokenForUserId(userId)

            var tokenSet: TokenSet?
            if (refreshToken.isEmpty) {
                tokenSet = tokenService.generateAndStoreRefreshTokenAndAccessToken(userId)
            } else {
                tokenSet = tokenService.getAccessTokenByRefreshToken(refreshToken.get())
            }

            tokenSet ?: TokenSet("","")
        }
    }

    override suspend fun getAccessTokenByRefreshToken(
            request: AccessTokenRefreshRequest
    ): TokenSet? =
            withContext(Dispatchers.IO) {
                tokenService.getAccessTokenByRefreshToken(request.refreshToken)
            }

    override suspend fun checkUserExists(email: String): Boolean {
        val result = withContext(Dispatchers.IO) {
            userRepository.checkUserExists(email)
        }

        return result
    }
}
