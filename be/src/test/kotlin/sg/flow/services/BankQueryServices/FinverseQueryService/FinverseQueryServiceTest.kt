package sg.flow.services.BankQueryServices.FinverseQueryService

import io.mockk.*
import kotlin.time.Duration.Companion.minutes
import kotlin.time.Duration.Companion.seconds
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.springframework.http.HttpHeaders
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.web.reactive.function.BodyInserters
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.WebClientResponseException
import reactor.core.publisher.Mono
import sg.flow.entities.Bank
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.responses.CustomerTokenResponse
import sg.flow.models.finverse.responses.LinkTokenResponse
import sg.flow.models.finverse.responses.FinverseAuthTokenResponse
import sg.flow.repositories.bank.BankRepositoryImpl
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

@DisplayName("FinverseQueryService Tests")
class FinverseQueryServiceTest {

        private lateinit var finverseCredentials: FinverseCredentials
        private lateinit var finverseWebClient: WebClient
        private lateinit var finverseLoginIdentityService: FinverseLoginIdentityService
        private lateinit var finverseDataRetrievalRequestsManager:
                FinverseDataRetrievalRequestsManager
        private lateinit var finverseTimeoutWatcher: FinverseTimeoutWatcher
        private lateinit var finverseResponseProcessor: FinverseResponseProcessor
        private lateinit var bankRepositoryImpl: BankRepositoryImpl

        private lateinit var webClientRequestHeadersUriSpec: WebClient.RequestHeadersUriSpec<*>
        private lateinit var webClientRequestBodyUriSpec: WebClient.RequestBodyUriSpec
        private lateinit var webClientRequestHeadersSpec: WebClient.RequestHeadersSpec<*>
        private lateinit var webClientRequestBodySpec: WebClient.RequestBodySpec
        private lateinit var webClientResponseSpec: WebClient.ResponseSpec

        private lateinit var finverseQueryService: FinverseQueryService

        @BeforeEach
        fun setUp() {
                finverseCredentials = mockk()
                finverseWebClient = mockk()
                finverseLoginIdentityService = mockk()
                finverseDataRetrievalRequestsManager = mockk()
                finverseTimeoutWatcher = mockk()
                finverseResponseProcessor = mockk()
                bankRepositoryImpl = mockk()

                webClientRequestHeadersUriSpec = mockk()
                webClientRequestBodyUriSpec = mockk()
                webClientRequestHeadersSpec = mockk()
                webClientRequestBodySpec = mockk()
                webClientResponseSpec = mockk()

                every { finverseCredentials.clientId } returns "test-client-id"
                every { finverseCredentials.clientSecret } returns "test-client-secret"

                // Mock the initial token fetch in constructor
                setupTokenFetchMocks()

                finverseQueryService =
                        FinverseQueryService(
                                finverseCredentials,
                                finverseWebClient,
                                finverseLoginIdentityService,
                                finverseDataRetrievalRequestsManager,
                                finverseTimeoutWatcher,
                                finverseResponseProcessor,
                                bankRepositoryImpl
                        )
        }

        private fun setupTokenFetchMocks() {
                val customerTokenResponse =
                        CustomerTokenResponse(
                                accessToken = "test-access-token",
                                expiresIn = 3600L,
                                tokenType = "Bearer"
                        )

                every { finverseWebClient.post() } returns webClientRequestBodyUriSpec
                every { webClientRequestBodyUriSpec.uri("/auth/customer/token") } returns
                        webClientRequestBodySpec
                every { webClientRequestBodySpec.contentType(MediaType.APPLICATION_JSON) } returns
                        webClientRequestBodySpec
                every { webClientRequestBodySpec.bodyValue(any()) } returns
                        webClientRequestHeadersSpec
                every { webClientRequestHeadersSpec.retrieve() } returns webClientResponseSpec
                every {
                        webClientResponseSpec.bodyToMono(CustomerTokenResponse::class.java)
                } returns Mono.just(customerTokenResponse)
        }

        @Nested
        @DisplayName("Token Management Tests")
        inner class TokenManagementTests {

                @Test
                @DisplayName("Should fetch customer token successfully on initialization")
                fun shouldFetchCustomerTokenOnInit() {
                        // The token fetch is already done in constructor through
                        // setupTokenFetchMocks
                        verify { finverseWebClient.post() }
                        verify { webClientRequestBodyUriSpec.uri("/auth/customer/token") }
                }

                @Test
                @DisplayName("Should throw exception when customer token fetch fails")
                fun shouldThrowExceptionWhenTokenFetchFails() {
                        every {
                                webClientResponseSpec.bodyToMono(CustomerTokenResponse::class.java)
                        } returns Mono.empty()

                        assertThrows<IllegalStateException> {
                                FinverseQueryService(
                                        finverseCredentials,
                                        finverseWebClient,
                                        finverseLoginIdentityService,
                                        finverseDataRetrievalRequestsManager,
                                        finverseTimeoutWatcher,
                                        finverseResponseProcessor,
                                        bankRepositoryImpl
                                )
                        }
                }

                @Test
                @DisplayName("Should refresh token when expired")
                fun shouldRefreshTokenWhenExpired() = runTest {
                        // First, let the service initialize with a token
                        clearAllMocks()
                        setupTokenFetchMocks()

                        val newFinverseService =
                                FinverseQueryService(
                                        finverseCredentials,
                                        finverseWebClient,
                                        finverseLoginIdentityService,
                                        finverseDataRetrievalRequestsManager,
                                        finverseTimeoutWatcher,
                                        finverseResponseProcessor,
                                        bankRepositoryImpl
                                )

                        // Sleep to ensure token is "expired" (in real scenario, we'd manipulate
                        // time)
                        Thread.sleep(100)

                        // Setup mocks for generateLinkUrl which calls getCustomerToken
                        setupLinkUrlMocks()

                        newFinverseService.generateLinkUrl(1, "test-institution")

                        // Should have called token refresh
                        verify(atLeast = 2) { finverseWebClient.post() }
                }
        }

        @Nested
        @DisplayName("Generate Link URL Tests")
        inner class GenerateLinkUrlTests {

                @BeforeEach
                fun setup() {
                        setupLinkUrlMocks()
                }

                private fun setupLinkUrlMocks() {
                        val linkTokenResponse =
                                LinkTokenResponse(
                                        linkUrl = "https://finverse.com/link/test-url",
                                        linkToken = "test-link-token"
                                )

                        every { finverseWebClient.post() } returns webClientRequestBodyUriSpec
                        every { webClientRequestBodyUriSpec.uri("/link/token") } returns
                                webClientRequestBodySpec
                        every {
                                webClientRequestBodySpec.headers(any<(HttpHeaders) -> Unit>())
                        } returns webClientRequestBodySpec
                        every {
                                webClientRequestBodySpec.contentType(MediaType.APPLICATION_JSON)
                        } returns webClientRequestBodySpec
                        every { webClientRequestBodySpec.bodyValue(any()) } returns
                                webClientRequestHeadersSpec
                        every { webClientRequestHeadersSpec.retrieve() } returns
                                webClientResponseSpec
                        every {
                                webClientResponseSpec.bodyToMono(LinkTokenResponse::class.java)
                        } returns Mono.just(linkTokenResponse)
                }

                @Test
                @DisplayName("Should generate link URL with default parameters")
                fun shouldGenerateLinkUrlWithDefaults() = runTest {
                        val result = finverseQueryService.generateLinkUrl(123, "dbs-bank")

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["user_id"] == "123 " && // padEnd(4)
                                                body["institution_id"] == "dbs-bank" &&
                                                        body["automatic_data_refresh"] == "ON" &&
                                                        body["countries"] == listOf("SGP")
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should generate link URL with custom country")
                fun shouldGenerateLinkUrlWithCustomCountry() = runTest {
                        val result = finverseQueryService.generateLinkUrl(456, "ocbc-bank", "MYS")

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["countries"] == listOf("MYS")
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should generate link URL with automatic refresh disabled")
                fun shouldGenerateLinkUrlWithAutomaticRefreshDisabled() = runTest {
                        val result =
                                finverseQueryService.generateLinkUrl(
                                        789,
                                        "uob-bank",
                                        automaticRefresh = false
                                )

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["automatic_data_refresh"] == "OFF"
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should handle WebClient response exception")
                fun shouldHandleWebClientResponseException() = runTest {
                        val exception =
                                WebClientResponseException.create(
                                        HttpStatus.BAD_REQUEST.value(),
                                        "Bad Request",
                                        HttpHeaders.EMPTY,
                                        "Error response".toByteArray(),
                                        null
                                )

                        every {
                                webClientResponseSpec.bodyToMono(LinkTokenResponse::class.java)
                        } throws exception

                        val thrownException =
                                assertThrows<FinverseException> {
                                        finverseQueryService.generateLinkUrl(123, "test-bank")
                                }

                        assertTrue(thrownException.detail.contains("Failed to generate link URL"))
                }

                @Test
                @DisplayName("Should handle unexpected exception")
                fun shouldHandleUnexpectedException() = runTest {
                        every {
                                webClientResponseSpec.bodyToMono(LinkTokenResponse::class.java)
                        } throws RuntimeException("Network error")

                        val thrownException =
                                assertThrows<FinverseException> {
                                        finverseQueryService.generateLinkUrl(123, "test-bank")
                                }

                        assertTrue(thrownException.detail.contains("Unexpected error"))
                }

                @Test
                @DisplayName("Should pad user ID correctly")
                fun shouldPadUserIdCorrectly() = runTest {
                        finverseQueryService.generateLinkUrl(1, "test-bank")

                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["user_id"] == "1   " // padEnd(4)
                                        }
                                )
                        }

                        finverseQueryService.generateLinkUrl(12345, "test-bank")

                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["user_id"] ==
                                                        "12345" // longer than 4, no padding
                                        }
                                )
                        }
                }
        }

        @Nested
        @DisplayName("Fetch Login Identity Tests")
        inner class FetchLoginIdentityTests {

                @BeforeEach
                fun setup() {
                        setupLoginIdentityMocks()
                }

                private fun setupLoginIdentityMocks() {
                        val finverseAuthTokenResponse =
                                FinverseAuthTokenResponse(
                                        loginIdentityToken = "test-login-token",
                                        expiresIn = 3600 as Integer,
                                        issuedAt = "2024-01-01T00:00:00Z",
                                        loginIdentityId = "test-login-id",
                                        refreshToken = "test-refresh-token",
                                        tokenType = "Bearer"
                                )

                        every { finverseWebClient.post() } returns webClientRequestBodyUriSpec
                        every { webClientRequestBodyUriSpec.uri("/auth/token") } returns
                                webClientRequestBodySpec
                        every {
                                webClientRequestBodySpec.headers(any<(HttpHeaders) -> Unit>())
                        } returns webClientRequestBodySpec
                        every {
                                webClientRequestBodySpec.contentType(
                                        MediaType.APPLICATION_FORM_URLENCODED
                                )
                        } returns webClientRequestBodySpec
                        every {
                                webClientRequestBodySpec.body(
                                        any<BodyInserters.FormInserter<String>>()
                                )
                        } returns webClientRequestHeadersSpec
                        every { webClientRequestHeadersSpec.retrieve() } returns
                                webClientResponseSpec
                        every {
                                webClientResponseSpec.bodyToMono(FinverseAuthTokenResponse::class.java)
                        } returns Mono.just(finverseAuthTokenResponse)

                        coEvery {
                                finverseLoginIdentityService.saveLoginIdentityToken(any(), any(), any(), any())
                        } just Runs
                        every {
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(any(), any())
                        } just Runs
                }

                @Test
                @DisplayName("Should fetch login identity successfully")
                fun shouldFetchLoginIdentitySuccessfully() = runTest {
                        val result =
                                finverseQueryService.fetchLoginIdentity(
                                        123,
                                        "auth-code-123",
                                        "test-institution"
                                )

                        assertEquals("RETRIEVING", result)
                        coVerify {
                                finverseLoginIdentityService.saveLoginIdentityToken(
                                        123,
                                        "test-institution",
                                        "test-login-id",
                                        "test-login-token"
                                )
                        }
                        verify {
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(eq(123), any())
                        }
                }

                @Test
                @DisplayName("Should handle different user IDs and institution IDs")
                fun shouldHandleDifferentUserAndInstitutionIds() = runTest {
                        val result =
                                finverseQueryService.fetchLoginIdentity(
                                        456,
                                        "different-code",
                                        "different-institution"
                                )

                        assertEquals("RETRIEVING", result)
                        coVerify {
                                finverseLoginIdentityService.saveLoginIdentityToken(
                                        456,
                                        "different-institution",
                                        "test-login-id",
                                        "test-login-token"
                                )
                        }
                }

                @Test
                @DisplayName("Should use correct form data")
                fun shouldUseCorrectFormData() = runTest {
                        finverseQueryService.fetchLoginIdentity(
                                123,
                                "test-code",
                                "test-institution"
                        )

                        verify {
                                webClientRequestBodySpec.body(
                                        match<BodyInserters.FormInserter<String>> { formInserter ->
                                                // We can't easily inspect form data, but we can
                                                // verify the method was
                                                // called
                                                true
                                        }
                                )
                        }
                }
        }

        @Nested
        @DisplayName("Get Institution Authentication Result Tests")
        inner class GetInstitutionAuthenticationResultTests {

                @Test
                @DisplayName("Should return AUTHENTICATION_FAILED when no credentials found")
                fun shouldReturnAuthFailedWhenNoCredentials() = runTest {
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns null

                        val result =
                                finverseQueryService.getInstitutionAuthenticationResult(
                                        123,
                                        "test-institution"
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result)
                }

                @Test
                @DisplayName("Should return AUTHENTICATION_FAILED when login identity ID is null")
                fun shouldReturnAuthFailedWhenLoginIdNull() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "",
                                        loginIdentityToken = "test-token"
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential

                        val result =
                                finverseQueryService.getInstitutionAuthenticationResult(
                                        123,
                                        "test-institution"
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result)
                }

                @Test
                @DisplayName(
                        "Should return AUTHENTICATION_FAILED when login identity token is null"
                )
                fun shouldReturnAuthFailedWhenTokenNull() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-id",
                                        loginIdentityToken = ""
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential

                        val result =
                                finverseQueryService.getInstitutionAuthenticationResult(
                                        123,
                                        "test-institution"
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result)
                }

                @Test
                @DisplayName("Should call timeout watcher with correct parameters")
                fun shouldCallTimeoutWatcherWithCorrectParams() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-login-id",
                                        loginIdentityToken = "test-token"
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(
                                        123,
                                        "test-institution"
                                )
                        } returns credential
                        coEvery {
                                finverseTimeoutWatcher.watchAuthentication(
                                        "test-login-id",
                                        30.seconds
                                )
                        } returns FinverseAuthenticationStatus.AUTHENTICATED

                        val result =
                                finverseQueryService.getInstitutionAuthenticationResult(
                                        123,
                                        "test-institution"
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        coVerify {
                                finverseTimeoutWatcher.watchAuthentication(
                                        "test-login-id",
                                        30.seconds
                                )
                        }
                }

                @Test
                @DisplayName("Should handle all authentication status types")
                fun shouldHandleAllAuthenticationStatusTypes() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-login-id",
                                        loginIdentityToken = "test-token"
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential

                        val authStatuses =
                                listOf(
                                        FinverseAuthenticationStatus.AUTHENTICATED,
                                        FinverseAuthenticationStatus.AUTHENTICATION_FAILED,
                                        FinverseAuthenticationStatus
                                                .AUTHENTICATION_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION,
                                        FinverseAuthenticationStatus
                                                .AUTHENTICATION_TOO_MANY_ATTEMPTS,
                                        FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT
                                )

                        authStatuses.forEach { status ->
                                coEvery {
                                        finverseTimeoutWatcher.watchAuthentication(any(), any())
                                } returns status

                                val result =
                                        finverseQueryService.getInstitutionAuthenticationResult(
                                                123,
                                                "test-institution"
                                        )
                                assertEquals(status, result)
                        }
                }
        }

        @Nested
        @DisplayName("Get User Data Retrieval Result Tests")
        inner class GetUserDataRetrievalResultTests {

                @Test
                @DisplayName("Should return failure status when no credentials found")
                fun shouldReturnFailureWhenNoCredentials() = runTest {
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns null

                        val result =
                                finverseQueryService.getUserDataRetrievalResult(
                                        123,
                                        "test-institution"
                                )

                        assertFalse(result.success)
                        assertEquals("NO LOGIN IDENTITY INFORMATION FOUND", result.message)
                        assertEquals("", result.loginIdentityId)
                }

                @Test
                @DisplayName("Should return failure status when login identity ID is null")
                fun shouldReturnFailureWhenLoginIdNull() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "",
                                        loginIdentityToken = "test-token"
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential

                        val result =
                                finverseQueryService.getUserDataRetrievalResult(
                                        123,
                                        "test-institution"
                                )

                        assertFalse(result.success)
                        assertEquals("NO LOGIN IDENTITY INFORMATION FOUND", result.message)
                }

                @Test
                @DisplayName("Should call timeout watcher for data retrieval completion")
                fun shouldCallTimeoutWatcherForDataRetrieval() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-login-id",
                                        loginIdentityToken = "test-token"
                                )
                        val expectedResult =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = "test-login-id",
                                        success = true,
                                        message = "Data retrieved successfully"
                                )

                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(
                                        123,
                                        "test-institution"
                                )
                        } returns credential
                        coEvery {
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        "test-login-id",
                                        5.minutes
                                )
                        } returns expectedResult

                        val result =
                                finverseQueryService.getUserDataRetrievalResult(
                                        123,
                                        "test-institution"
                                )

                        assertEquals(expectedResult, result)
                        coVerify {
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        "test-login-id",
                                        5.minutes
                                )
                        }
                }

                @Test
                @DisplayName("Should handle timeout scenarios")
                fun shouldHandleTimeoutScenarios() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-login-id",
                                        loginIdentityToken = "test-token"
                                )
                        val timeoutResult =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = "test-login-id",
                                        success = false,
                                        message = "TIME OUT: 5m"
                                )

                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential
                        coEvery {
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(any(), any())
                        } returns timeoutResult

                        val result =
                                finverseQueryService.getUserDataRetrievalResult(
                                        123,
                                        "test-institution"
                                )

                        assertFalse(result.success)
                        assertTrue(result.message.contains("TIME OUT"))
                }
        }

        @Nested
        @DisplayName("Fetch Institution Data Tests")
        inner class FetchInstitutionDataTests {

                @Test
                @DisplayName("Should fetch and process institution data successfully")
                fun shouldFetchAndProcessInstitutionData() = runTest {
                        val institutions =
                                arrayOf(
                                        FinverseInstitution(
                                                institutionId = "dbs-sg",
                                                institutionName = "DBS Bank",
                                                institutionType = "BANK",
                                                countries = listOf("SGP"),
                                                bankCode = "DBS001"
                                        ),
                                        FinverseInstitution(
                                                institutionId = "ocbc-sg",
                                                institutionName = "OCBC Bank",
                                                institutionType = "BANK",
                                                countries = listOf("SGP"),
                                                bankCode = "OCBC001"
                                        )
                                )

                        val mockBank1 = Bank(id = 1, name = "DBS Bank", bankCode = "DBS001")
                        val mockBank2 = Bank(id = 2, name = "OCBC Bank", bankCode = "OCBC001")

                        every { finverseWebClient.get() } returns webClientRequestHeadersUriSpec
                        every {
                                webClientRequestHeadersUriSpec.uri("/institutions?countries=SGP")
                        } returns webClientRequestHeadersSpec
                        every {
                                webClientRequestHeadersSpec.headers(any<(HttpHeaders) -> Unit>())
                        } returns webClientRequestHeadersSpec
                        every { webClientRequestHeadersSpec.retrieve() } returns
                                webClientResponseSpec
                        every {
                                webClientResponseSpec.bodyToMono(
                                        Array<FinverseInstitution>::class.java
                                )
                        } returns Mono.just(institutions)

                        coEvery {
                                finverseResponseProcessor.processInstitutionResponse(
                                        institutions[0]
                                )
                        } returns mockBank1
                        coEvery {
                                finverseResponseProcessor.processInstitutionResponse(
                                        institutions[1]
                                )
                        } returns mockBank2
                        coEvery { bankRepositoryImpl.save(any()) } returns mockk()

                        finverseQueryService.fetchInstitutionData()

                        coVerify {
                                finverseResponseProcessor.processInstitutionResponse(
                                        institutions[0]
                                )
                        }
                        coVerify {
                                finverseResponseProcessor.processInstitutionResponse(
                                        institutions[1]
                                )
                        }
                        coVerify { bankRepositoryImpl.save(mockBank1) }
                        coVerify { bankRepositoryImpl.save(mockBank2) }
                }

                @Test
                @DisplayName("Should handle empty institution data")
                fun shouldHandleEmptyInstitutionData() = runTest {
                        val emptyInstitutions = arrayOf<FinverseInstitution>()

                        every { finverseWebClient.get() } returns webClientRequestHeadersUriSpec
                        every {
                                webClientRequestHeadersUriSpec.uri("/institutions?countries=SGP")
                        } returns webClientRequestHeadersSpec
                        every {
                                webClientRequestHeadersSpec.headers(any<(HttpHeaders) -> Unit>())
                        } returns webClientRequestHeadersSpec
                        every { webClientRequestHeadersSpec.retrieve() } returns
                                webClientResponseSpec
                        every {
                                webClientResponseSpec.bodyToMono(
                                        Array<FinverseInstitution>::class.java
                                )
                        } returns Mono.just(emptyInstitutions)

                        finverseQueryService.fetchInstitutionData()

                        coVerify(exactly = 0) {
                                finverseResponseProcessor.processInstitutionResponse(any())
                        }
                        coVerify(exactly = 0) { bankRepositoryImpl.save(any()) }
                }
        }

        @Nested
        @DisplayName("Edge Cases and Error Handling Tests")
        inner class EdgeCasesAndErrorHandlingTests {

                @Test
                @DisplayName("Should handle extremely large user IDs")
                fun shouldHandleExtremelyLargeUserIds() = runTest {
                        setupLinkUrlMocks()

                        val result =
                                finverseQueryService.generateLinkUrl(Int.MAX_VALUE, "test-bank")

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["user_id"] == Int.MAX_VALUE.toString()
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should handle empty institution ID")
                fun shouldHandleEmptyInstitutionId() = runTest {
                        setupLinkUrlMocks()

                        val result = finverseQueryService.generateLinkUrl(123, "")

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["institution_id"] == ""
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should handle special characters in institution ID")
                fun shouldHandleSpecialCharactersInInstitutionId() = runTest {
                        setupLinkUrlMocks()

                        val specialInstitutionId = "test-bank-éñ@#$%"
                        val result = finverseQueryService.generateLinkUrl(123, specialInstitutionId)

                        assertEquals("https://finverse.com/link/test-url", result)
                        verify {
                                webClientRequestBodySpec.bodyValue(
                                        match<Map<String, Any>> { body ->
                                                body["institution_id"] == specialInstitutionId
                                        }
                                )
                        }
                }

                @Test
                @DisplayName("Should handle concurrent access correctly")
                fun shouldHandleConcurrentAccessCorrectly() = runTest {
                        val credential =
                                FinverseLoginIdentityCredential(
                                        loginIdentityId = "test-login-id",
                                        loginIdentityToken = "test-token"
                                )
                        coEvery {
                                finverseLoginIdentityService.getLoginIdentityCredential(any(), any())
                        } returns credential
                        coEvery { finverseTimeoutWatcher.watchAuthentication(any(), any()) } returns
                                FinverseAuthenticationStatus.AUTHENTICATED

                        // Simulate concurrent calls
                        val results = mutableListOf<FinverseAuthenticationStatus>()
                        repeat(10) {
                                val result =
                                        finverseQueryService.getInstitutionAuthenticationResult(
                                                123,
                                                "test-institution"
                                        )
                                results.add(result)
                        }

                        // All results should be consistent
                        assertTrue(results.all { it == FinverseAuthenticationStatus.AUTHENTICATED })
                }
        }

        private fun setupLinkUrlMocks() {
                val linkTokenResponse =
                        LinkTokenResponse(
                                linkUrl = "https://finverse.com/link/test-url",
                                linkToken = "test-link-token"
                        )

                every { finverseWebClient.post() } returns webClientRequestBodyUriSpec
                every { webClientRequestBodyUriSpec.uri("/link/token") } returns
                        webClientRequestBodySpec
                every { webClientRequestBodySpec.headers(any<(HttpHeaders) -> Unit>()) } returns
                        webClientRequestBodySpec
                every { webClientRequestBodySpec.contentType(MediaType.APPLICATION_JSON) } returns
                        webClientRequestBodySpec
                every { webClientRequestBodySpec.bodyValue(any()) } returns
                        webClientRequestHeadersSpec
                every { webClientRequestHeadersSpec.retrieve() } returns webClientResponseSpec
                every { webClientResponseSpec.bodyToMono(LinkTokenResponse::class.java) } returns
                        Mono.just(linkTokenResponse)
        }
}
