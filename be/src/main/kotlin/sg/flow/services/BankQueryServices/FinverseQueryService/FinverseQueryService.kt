package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.runBlocking
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.BodyInserters
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.WebClientResponseException
import org.springframework.web.reactive.function.client.bodyToMono
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProductRetrieval
import sg.flow.models.finverse.responses.CustomerTokenResponse
import sg.flow.models.finverse.responses.LinkTokenResponse
import sg.flow.models.finverse.responses.LoginIdentityResponse
import sg.flow.repositories.bank.BankRepositoryImpl
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException
import java.lang.Thread.sleep
import java.time.Instant
import java.util.concurrent.atomic.AtomicReference
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds

@Service
class FinverseQueryService(
    private val finverseCredentials: FinverseCredentials,
    private val finverseWebClient: WebClient,
    private val finverseAuthCache: FinverseAuthCache,
    private val finverseDataRetrievalRequestsManager: FinverseDataRetrievalRequestsManager,
    private val finverseTimeoutWatcher: FinverseTimeoutWatcher,
    private val finverseResponseProcessor: FinverseResponseProcessor,
    private val bankRepositoryImpl: BankRepositoryImpl
) {
    private val customerTokenRef = AtomicReference<String>()
    private var tokenExpiry: Instant = Instant.EPOCH

    init {
        this.fetchCustomerToken()
//        this.fetchInstitutionData()
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

    fun fetchInstitutionData() {
        val countries = "SGP"
        finverseWebClient.get()
            .uri("/institutions?countries=$countries")
            .headers { it -> it.setBearerAuth(getCustomerToken()) }
            .retrieve()
            .bodyToMono(Array<FinverseInstitution>::class.java)
            .map { institutions ->
                institutions.map { institution ->
                    runBlocking {
                        val bank = finverseResponseProcessor.processInstitutionResponse(institution)
                        bankRepositoryImpl.save(bank)
                        bank
                    }
                }
            }.block()
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
            listOf("ACCOUNTS", "TRANSACTIONS", "ACCOUNT_NUMBERS")
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
            "response_mode" to "form_post", // DO NOT CHANGE
            "response_type" to "code", // DO NOT CHANGE
            "grant_type" to "client_credentials" // DO NOT CHANGE
        )

        return try {
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
            println("Finverse returned HTTP ${e.statusCode}: ${e.responseBodyAsString}")
            throw FinverseException("Failed to generate link URL: ${e.responseBodyAsString}")
        }
        catch (e: Exception) {
            println("Unexpected error while generating link URL")
            println(e.message)
            throw FinverseException("Unexpected error: ${e.message}")
        }
    }

    suspend fun fetchLoginIdentity(userId: Int, code: String, institutionId: String): String {
        println("Fetching login identity")
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
                    .with("grant_type", "authorization_code")
            )
            .retrieve()
            .bodyToMono(LoginIdentityResponse::class.java)
            .awaitSingle()

        val requestedProduct: List<FinverseProductRetrieval> = listOf()

        println("Saving LoginIdentity: ${loginIdentityResponse.loginIdentityToken}")
        finverseAuthCache.saveLoginIdentityToken(
            userId,
            institutionId,
            loginIdentityResponse.loginIdentityId,
            loginIdentityResponse.loginIdentityToken
        )

        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(userId, FinverseDataRetrievalRequest(
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

        println(loginIdentityId)
        println(loginIdentityToken)

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