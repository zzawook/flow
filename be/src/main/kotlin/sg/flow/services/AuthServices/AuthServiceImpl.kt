package sg.flow.services.AuthServices

import com.fasterxml.jackson.databind.ObjectMapper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.future.await
import kotlinx.coroutines.withContext
import org.slf4j.LoggerFactory
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.stereotype.Service
import org.springframework.web.server.ServerWebExchange
import sg.flow.configs.FlowEmailProps
import sg.flow.configs.MagicLinkProps
import sg.flow.entities.User
import sg.flow.grpc.exception.InternalErrorException
import sg.flow.grpc.exception.InvalidCredentialException
import sg.flow.grpc.exception.TokenGenerationException
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import sg.flow.repositories.user.UserRepository
import sg.flow.services.UserServices.UserService
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.VaultService
import software.amazon.awssdk.core.exception.SdkClientException
import software.amazon.awssdk.services.sesv2.SesV2AsyncClient
import software.amazon.awssdk.services.sesv2.model.SendEmailRequest
import software.amazon.awssdk.services.sesv2.model.SesV2Exception
import java.net.URLEncoder
import java.time.LocalDate
import java.util.Date
import java.util.Optional
import java.util.UUID
import kotlin.text.Charsets.UTF_8
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Instant

@Service
class AuthServiceImpl(
    private val cacheService: CacheService,
    private val vaultService: VaultService,
    private val tokenService: FlowTokenService,
    private val userRepository: UserRepository,
    private val userService: UserService,
    private val passwordEncoder: PasswordEncoder,
    private val ses: SesV2AsyncClient,
    private val emailProps: FlowEmailProps,
    private val linkProps: MagicLinkProps,
    private val mapper: ObjectMapper,
    private val emailVerifyTimeoutWatcher: AuthTimeoutWatcher
) : AuthService {

    val logger = LoggerFactory.getLogger(AuthServiceImpl::class.java)

    override suspend fun registerUser(email: String, name: String, password: String, dateOfBirth: LocalDate): TokenSet =
            withContext(Dispatchers.IO) {
                if (checkUserExists(email)) {
                    return@withContext getTokenSetForUser(email, password)
                }

                // POSSIBLY IMPLEMENT SINGPASS INTEGRATION
                var passwordEncoded: String
                try {
passwordEncoded = passwordEncoder.encode(password)

                } catch (e: Exception) {
                    throw TokenGenerationException("Failed to encode given password")
                }

                val savedEntity = userService.saveUser(name, email, passwordEncoded, dateOfBirth)
                if (savedEntity == null) {
                    return@withContext TokenSet(
                        "", ""
                    )
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

    override suspend fun signOutUser(accessToken: String): Boolean {
        return tokenService.revokeAccessToken(accessToken)
    }

    override suspend fun sendVerificationEmail(email: String): Boolean {
        val templateName = emailProps.templates.en

        val token = tokenService.generateAndStoreEmailVerificationToken(email)

        val verifyUrl = "${linkProps.baseUrl}?token=${
            URLEncoder.encode(token, UTF_8)
        }"

        val templateData = mapper.writeValueAsString(
            mapOf("verificationUrl" to verifyUrl)
        )

        val req = SendEmailRequest.builder()
            .fromEmailAddress(emailProps.sender)
            .destination { it.toAddresses(email) }
            .content {c -> c.template { t ->
                t.templateName(templateName)
                    .templateData(templateData)
            }}
            .configurationSetName("my-first-configuration-set")
            .build()

        var delayMs = 200L
        repeat(3) { attempt ->
            try {
                val resp = ses .sendEmail(req).await()
                logger.info("Verification email sent to $email")// non-blocking; unwraps the cause
                return true
            } catch (e: SesV2Exception) {
                e.printStackTrace()
                if (!isRetryable(e) || attempt == 2) throw e
                kotlinx.coroutines.delay(delayMs); delayMs *= 2
            } catch (e: SdkClientException) {         // timeouts/DNS/TLS/etc.
                e.printStackTrace()
                if (attempt == 2) throw e
                kotlinx.coroutines.delay(delayMs); delayMs *= 2
            } catch (e: Exception) {
                e.printStackTrace()
                logger.error("FAILED TO SEND VERIFICATION EMAIL")
            }
        }

        return false
    }
    private fun isRetryable(e: SesV2Exception): Boolean {
        val code = e.awsErrorDetails()?.errorCode() ?: return false
        return code in setOf("TooManyRequestsException") || e.statusCode() in 500..599
    }

    override suspend fun verifyEmail(token: String): Boolean {
        val emailValidated = tokenService.validateEmailVerificationToken(token)

        userService.markUserEmailVerified(emailValidated)

        return true
    }

    override suspend fun checkEmailVerified(email: String): Boolean {
        val timeout = 3.minutes

        if (userService.isUserVerified(email)) {
            return true
        }

        val result = emailVerifyTimeoutWatcher.watchEmailVerification(
            email,
            timeout
        )

        return result
    }
}
