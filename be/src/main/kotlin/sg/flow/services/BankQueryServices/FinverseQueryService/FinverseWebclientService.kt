package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.BodyInserters
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.WebClientResponseException
import org.springframework.web.reactive.function.client.awaitBody
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.responses.CustomerTokenResponse
import sg.flow.models.finverse.responses.FinverseAccountNumberResponse
import sg.flow.models.finverse.responses.FinverseAccountResponse
import sg.flow.models.finverse.responses.FinverseAuthTokenResponse
import sg.flow.models.finverse.responses.FinverseBalanceHistoryResponse
import sg.flow.models.finverse.responses.FinverseIdentityResponse
import sg.flow.models.finverse.responses.FinverseIncomeEstimationResponse
import sg.flow.models.finverse.responses.FinverseLoginIdentityResponse
import sg.flow.models.finverse.responses.FinverseStatementsResponse
import sg.flow.models.finverse.responses.FinverseTransactionResponse
import sg.flow.models.finverse.responses.LinkTokenResponse
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException
import java.time.Instant
import java.util.concurrent.atomic.AtomicReference
import kotlin.text.get

@Service
class FinverseWebclientService(
    private val finverseWebClient: WebClient,
    private val finverseCredentials: FinverseCredentials,
) {
    private val customerTokenRef = AtomicReference<String>()
    private var tokenExpiry: Instant = Instant.EPOCH

    private val logger = LoggerFactory.getLogger(FinverseWebclientService::class.java)

    private final val FINVERSE_CALLBACK_ADDRESS = "http://localhost:8081/api/finverse/callback"

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

    fun fetchInstitutionData(countries: String): List<FinverseInstitution> {
        val uri = "/institutions?countries=$countries&products_supported=ACCOUNTS&products_supported=ACCOUNT_NUMBERS&products_supported=TRANSACTIONS"
        val institutions = finverseWebClient.get()
            .uri(uri)
            .headers { it -> it.setBearerAuth(getCustomerToken()) }
            .retrieve()
            .bodyToMono(Array<FinverseInstitution>::class.java)
            .block()

        if (institutions == null) {
            logger.error("Failed to fetch finverse institutions")
            return listOf()
        }

        return institutions.toList()
    }

    suspend fun fetchLinkUrlRefresh(loginIdentityToken: String, state: String = "") : LinkTokenResponse {
        val requestBody = mapOf(
            "user_present" to true,
            "link_customizations" to mapOf(
                "state" to state,
                "ui_mode" to "iframe",
                "redirect_uri" to FINVERSE_CALLBACK_ADDRESS
            )
        )
        println(requestBody)

        return try {
            finverseWebClient.post()
                .uri("/login_identity/refresh")
                .headers { it -> it.setBearerAuth(loginIdentityToken) }
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(LinkTokenResponse::class.java)
                .awaitSingle()
        } catch (e: WebClientResponseException) {
            e.printStackTrace()
            logger.error("Finverse returned HTTP during refresh: ${e.statusCode}: ${e.responseBodyAsString}")
            throw FinverseException("Failed to generate link URL: ${e.responseBodyAsString}")
        } catch (e: Exception) {
            logger.error("Unexpected error while generating link URL", e)
            throw FinverseException("Unexpected error: ${e.message}")
        }
    }

    suspend fun fetchLinkUrlInit(
        userId: Int,
        institutionId: String,
        state: String,
        automaticRefresh: String,
        productSupported: List<String>,
        productsRequested: List<String>,
        countries: List<String>,
        ): LinkTokenResponse {
        return fetchLinkUrlWithToken(
            getCustomerToken(),
            userId,
            institutionId,
            state,
            automaticRefresh,
            productSupported,
            productsRequested,
            countries
        )
    }

    suspend fun fetchLinkUrlRelink(
        userId: Int,
        institutionId: String,
        loginIdentityToken: String,
        state: String,
        automaticRefresh: String,
        productSupported: List<String>,
        productsRequested: List<String>,
        countries: List<String>,
    ): LinkTokenResponse {
        return fetchLinkUrlWithToken(
            loginIdentityToken,
            userId,
            institutionId,
            state,
            automaticRefresh,
            productSupported,
            productsRequested,
            countries
        )
    }

    private suspend fun fetchLinkUrlWithToken(
        token: String,
        userId: Int,
        institutionId: String,
        state: String,
        automaticRefresh: String,
        productSupported: List<String>,
        productsRequested: List<String>,
        countries: List<String>,
    ): LinkTokenResponse {
        val requestBody = mapOf(
            "client_id" to finverseCredentials.clientId,
            "institution_id" to institutionId,
            "institution_status" to "",
            "state" to state,
            "user_id" to userId.toString().padEnd(4),
            "redirect_uri" to FINVERSE_CALLBACK_ADDRESS,
            "automatic_data_refresh" to automaticRefresh,
            "product_supported" to productSupported,
            "products_requested" to productsRequested,
            "countries" to countries,
            "link_mode" to "real test",
            "ui_mode" to "",
            "response_mode" to "form_post", // DO NOT CHANGE
            "response_type" to "code", // DO NOT CHANGE
            "grant_type" to "client_credentials" // DO NOT CHANGE
        )

        return try {
            finverseWebClient.post()
                .uri("/link/token")
                .headers { it.setBearerAuth(token) }
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(requestBody)
                .retrieve()
                .bodyToMono(LinkTokenResponse::class.java)
                .awaitSingle()
        }
        catch (e: WebClientResponseException) {
            e.printStackTrace()
            logger.error("Finverse returned HTTP during relink${e.statusCode}: ${e.responseBodyAsString}")
            throw FinverseException("Failed to generate link URL: ${e.responseBodyAsString}")
        }
        catch (e: Exception) {
            logger.error("Unexpected error while generating link URL", e)
            throw FinverseException("Unexpected error: ${e.message}")
        }
    }

    suspend fun fetchLoginIdentity(code: String): FinverseAuthTokenResponse {
        val finverseAuthTokenResponse: FinverseAuthTokenResponse = finverseWebClient.post()
            .uri("/auth/token")
            .headers { it.setBearerAuth(getCustomerToken()) }
            .contentType(MediaType.APPLICATION_FORM_URLENCODED)
            .body(
                BodyInserters.fromFormData("grant_type", "authorization_code")
                    .with("client_id", finverseCredentials.clientId)
                    .with("code", code)
                    .with("redirect_uri", "http://localhost:8081/api/finverse/callback")
                    .with("grant_type", "authorization_code")
            )
            .retrieve()
            .bodyToMono(FinverseAuthTokenResponse::class.java)
            .awaitSingle()

        return finverseAuthTokenResponse
    }

    suspend fun fetchLoginIdentityInfo(loginIdentityToken: String) : FinverseLoginIdentityResponse {
        return finverseWebClient.get()
            .uri("/login_identity")
            .headers { it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .bodyToMono(FinverseLoginIdentityResponse::class.java)
            .awaitSingle()
    }

    suspend fun refreshLoginIdentityToken(loginIdentityRefreshToken: String): FinverseAuthTokenResponse {
        return try {
            finverseWebClient.post()
                .uri("/auth/token/refresh")
                .headers { it -> it.setBearerAuth(getCustomerToken()) }
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(mapOf("refresh_token" to loginIdentityRefreshToken))
                .retrieve()
                .bodyToMono(FinverseAuthTokenResponse::class.java)
                .awaitSingle()
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to Refresh Login Identity")
            return FinverseAuthTokenResponse(
                "", 1,"","","",""
            )
        }
    }

    suspend fun fetchAccount(loginIdentityToken: String): FinverseAccountResponse {
        return finverseWebClient
            .get()
            .uri("/accounts")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchAccountNumberForAccountId(loginIdentityToken: String, accountId: String): FinverseAccountNumberResponse {
        return finverseWebClient
            .get()
            .uri("/account_numbers/$accountId")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchOnlineTransaction(loginIdentityToken: String): FinverseTransactionResponse {
        return finverseWebClient
            .get()
            .uri { builder ->
                builder.path("/transactions")
                    .queryParam("type", "online")
                    .build()
            }
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchHistoricalTransaction(loginIdentityToken: String): FinverseTransactionResponse {
        return finverseWebClient
            .get()
            .uri { builder ->
                builder.path("/transactions")
                    .queryParam("type", "history")
                    .build()
            }
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchIdentity(loginIdentityToken: String): FinverseIdentityResponse {
        return finverseWebClient
            .get()
            .uri("/identity")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchBalanceHistory(loginIdentityToken: String): FinverseBalanceHistoryResponse {
        return finverseWebClient
            .get()
            .uri("/balance_history")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchIncomeStatement(loginIdentityToken: String): FinverseIncomeEstimationResponse {
        return finverseWebClient
            .get()
            .uri("/income")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }

    suspend fun fetchStatement(loginIdentityToken: String): FinverseStatementsResponse {
        return finverseWebClient
            .get()
            .uri("/statement")
            .headers { it -> it.setBearerAuth(loginIdentityToken) }
            .retrieve()
            .awaitBody()
    }
}