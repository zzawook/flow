package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.reactor.awaitSingle
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.BodyInserters
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.WebClientResponseException
import sg.flow.models.finverse.FinverseAuthenticationEventTypeParser
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalEvent
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProductRetrieval
import sg.flow.models.finverse.FinverseRetrievalStatus
import sg.flow.models.finverse.responses.CustomerTokenResponse
import sg.flow.models.finverse.responses.LinkTokenResponse
import sg.flow.models.finverse.responses.LoginIdentityResponse
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException
import sg.flow.services.UtilServices.CacheService
import java.time.Instant
import java.util.concurrent.atomic.AtomicReference
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

@Service
class FinverseQueryService(
    private val finverseCredentials: FinverseCredentials,
    private val finverseWebClient: WebClient,
    private val finverseAuthCache: FinverseAuthCache,
    private val finverseDataRetrievalEventsManager: FinverseDataRetrievalEventsManager,
    private val finverseTimeoutWatcher: FinverseTimeoutWatcher
) {
    private val customerTokenRef = AtomicReference<String>()
    private var tokenExpiry: Instant = Instant.EPOCH

    init {
        this.fetchCustomerToken()
    }

    private fun fetchCustomerToken() {
        val requestBody = mapOf(
            "grant_type"    to "client_credentials",
            "client_id"     to finverseCredentials.clientId,
            "client_secret" to finverseCredentials.clientSecret
        )
        val response = finverseWebClient.post()
            .uri("/auth/customer/token")
            .contentType(MediaType.APPLICATION_JSON)
            .bodyValue(requestBody)
            .retrieve()
            .bodyToMono(CustomerTokenResponse::class.java)
            .block() ?: throw IllegalStateException("Failed to fetch customer_token")

        // Store token and calculate expiry time
        customerTokenRef.set(response.accessToken)
        tokenExpiry = Instant.now().plusSeconds(response.expiresIn)
    }

    private fun getCustomerToken(): String {
        if (Instant.now().isAfter(tokenExpiry.minusSeconds(60))) {
            fetchCustomerToken()
        }
        return customerTokenRef.get()
    }

    /**
     * Generates a Link Token for the given institution,
     * returning the URL the front-end can open for user authentication.
     */
    suspend fun generateLinkUrl(userId: Int, institutionId: String, country: String = "SGP", automaticRefresh: Boolean = true): String {
        val token = getCustomerToken()
        val productsRequested =
            listOf("ACCOUNTS", "TRANSACTIONS", "ACCOUNT_NUMBERS", "BALANCE_HISTORY", "IDENTITY")
        val productSupported = productsRequested;

        val automaticRefreshVal: String = if (automaticRefresh) {
            "ON"
        } else {
            "OFF"
        }

        val userIdString = userId.toString().padEnd(4)

        val requestBody = mapOf(
            "client_id" to finverseCredentials.clientId,
            "institution_id" to institutionId,
            "institution_status" to "",
            "state" to "someCustomStateParameter",
            "user_id" to userIdString,
            "redirect_uri" to "http://localhost:8081/api/finverse/callback",
            "automatic_data_refresh" to automaticRefreshVal,
            "product_supported" to productSupported,
            "products_requested" to productsRequested,
            "countries" to listOf(country),
            "link_mode" to "real test",
            "ui_mode" to "",
            "response_mode" to "form_post", // NO CHANGE
            "response_type" to "code", // NO CHANGE
            "grant_type" to "client_credentials" // NO CHANGE
        )

        return try {
            // 1️⃣ Issue the HTTP call, mapping error‑status into exceptions
            val resp = finverseWebClient.post()
                .uri("/link/token")
                .headers { it.setBearerAuth(token) }
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(LinkTokenResponse::class.java)
                .awaitSingle()

            resp.linkUrl
        }
        catch (e: WebClientResponseException) {
            // 2 Handle 400 / 500 Errors
            println("Finverse returned HTTP ${e.statusCode}: ${e.responseBodyAsString}")
            throw FinverseException("Failed to generate link URL: ${e.responseBodyAsString}")
        }
        catch (e: Exception) {
            // 3️⃣ Handle other failures (serialization, network, etc.)
            println("Unexpected error while generating link URL")
            println(e.message)
            throw FinverseException("Unexpected error: ${e.message}")
        }
    }

    suspend fun fetchLoginIdentity(userId: Int, code: String, institutionId: String): String {
        val token = getCustomerToken()
        val loginIdentityResponse: LoginIdentityResponse = finverseWebClient.post()
            .uri("/auth/token")
            .headers { it.setBearerAuth(token) }
            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
            .body(
                BodyInserters.fromFormData("grant_type", "authorization_code")
                    .with("client_id", finverseCredentials.clientId)
                    .with("code", code)
                    .with("redirect_uri", "http://localhost:8081/api/finverse/callback")
            )
            .retrieve()
            .bodyToMono(LoginIdentityResponse::class.java)
            .awaitSingle()

        val requestedProduct: List<FinverseProductRetrieval> = listOf()

        finverseAuthCache.saveLoginIdentityToken(
            userId,
            institutionId,
            loginIdentityResponse.loginIdentityId,
            loginIdentityResponse.loginIdentityToken
        )

        finverseDataRetrievalEventsManager.registerFinverseDataRetrievalEvent(userId, FinverseDataRetrievalEvent(
            loginIdentityResponse.loginIdentityId,
            userId,
            institutionId,
            requestedProduct,
        ))

        return "RETRIEVING"
    }

    suspend fun getInstitutionAuthenticationResult(userId: Int, institutionId: String): FinverseAuthenticationStatus {
        val loginIdentityCredential = finverseAuthCache.getLoginIdentityCredential(userId, institutionId)

        val loginIdentityId = loginIdentityCredential?.loginIdentityId
        val loginIdentityToken = loginIdentityCredential?.loginIdentityToken

        if (loginIdentityId == null || loginIdentityToken == null) {
            return FinverseAuthenticationStatus.AUTHENTICATION_FAILED
        }

        val timeout = 30.seconds
        val status = finverseTimeoutWatcher.watchAuthentication(
            loginIdentityCredential.loginIdentityId,
            timeout
        )

        return status
    }

    suspend fun getUserDataRetrievalResult(userId: Int, institutionId: String): FinverseOverallRetrievalStatus {
        val loginIdentityCredential = finverseAuthCache.getLoginIdentityCredential(userId, institutionId)

        val loginIdentityId = loginIdentityCredential?.loginIdentityId
        val loginIdentityToken = loginIdentityCredential?.loginIdentityToken

        if (loginIdentityId == null || loginIdentityToken == null) {
            return FinverseOverallRetrievalStatus(
                success = false,
                message = "NO LOGIN IDENTITY INFORMATION FOUND",
                loginIdentityId = ""
            )
        }

        val timeout = 5.minutes
        val status = finverseTimeoutWatcher.watchDataRetrievalCompletion(
            loginIdentityId,
            timeout
        )

        return status
    }

}