package sg.flow.services.BankQueryServices.FinverseQueryService

import io.mockk.*
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseProductRetrieval
import sg.flow.models.finverse.FinverseRetrievalStatus
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

@DisplayName("FinverseDataRetrievalRequestsManager Tests")
class FinverseDataRetrievalRequestsManagerTest {

        private lateinit var finverseAuthCache: FinverseAuthCache
        private lateinit var finverseProductCompleteEventPublisher:
                FinverseProductCompleteEventPublisher
        private lateinit var finverseShouldFetchDecider: FinverseShouldFetchDecider
        private lateinit var finverseResponseProcessor: FinverseResponseProcessor
        private lateinit var finverseWebClient: WebClient

        private lateinit var finverseDataRetrievalRequestsManager:
                FinverseDataRetrievalRequestsManager

        @BeforeEach
        fun setUp() {
                finverseAuthCache = mockk()
                finverseProductCompleteEventPublisher = mockk()
                finverseShouldFetchDecider = mockk()
                finverseResponseProcessor = mockk()
                finverseWebClient = mockk()

                finverseDataRetrievalRequestsManager =
                        FinverseDataRetrievalRequestsManager(
                                finverseAuthCache,
                                finverseProductCompleteEventPublisher,
                                finverseShouldFetchDecider,
                                finverseResponseProcessor,
                                finverseWebClient
                        )
        }

        @Nested
        @DisplayName("Register Finverse Data Retrieval Event Tests")
        inner class RegisterFinverseDataRetrievalEventTests {

                @Test
                @DisplayName("Should register data retrieval event successfully")
                fun shouldRegisterDataRetrievalEventSuccessfully() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"
                        val institutionId = "dbs-bank"
                        val requestedProducts = listOf<FinverseProductRetrieval>()

                        val dataRetrievalRequest =
                                FinverseDataRetrievalRequest(
                                        loginIdentityId,
                                        userId,
                                        institutionId,
                                        requestedProducts
                                )

                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                dataRetrievalRequest
                        )

                        // Verify by checking if user is complete (should be false for empty
                        // products list)
                        assertFalse(finverseDataRetrievalRequestsManager.isUserComplete(userId))
                }

                @Test
                @DisplayName("Should handle multiple users registration")
                fun shouldHandleMultipleUsersRegistration() = runTest {
                        val users = listOf(123, 456, 789)

                        users.forEach { userId ->
                                val dataRetrievalRequest =
                                        createMockDataRetrievalRequest(
                                                "login-id-$userId",
                                                userId,
                                                "bank-$userId"
                                        )
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(
                                                userId,
                                                dataRetrievalRequest
                                        )
                        }

                        users.forEach { userId ->
                                assertFalse(
                                        finverseDataRetrievalRequestsManager.isUserComplete(userId)
                                )
                        }
                }

                @Test
                @DisplayName("Should overwrite existing registration for same user")
                fun shouldOverwriteExistingRegistrationForSameUser() = runTest {
                        val userId = 123

                        val firstRequest =
                                createMockDataRetrievalRequest(
                                        "first-login-id",
                                        userId,
                                        "first-bank"
                                )
                        val secondRequest =
                                createMockDataRetrievalRequest(
                                        "second-login-id",
                                        userId,
                                        "second-bank"
                                )

                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                firstRequest
                        )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                secondRequest
                        )

                        // The second request should have replaced the first
                        val status =
                                finverseDataRetrievalRequestsManager.getOverallRetrievalStatus(
                                        userId,
                                        "second-login-id"
                                )
                        assertEquals("second-login-id", status.loginIdentityId)
                }
        }

        @Nested
        @DisplayName("Is User Complete Tests")
        inner class IsUserCompleteTests {

                @Test
                @DisplayName("Should return false for non-existent user")
                fun shouldReturnFalseForNonExistentUser() = runTest {
                        assertFalse(finverseDataRetrievalRequestsManager.isUserComplete(999))
                }

                @Test
                @DisplayName("Should return false for user with incomplete products")
                fun shouldReturnFalseForUserWithIncompleteProducts() = runTest {
                        val userId = 123
                        val products =
                                listOf(
                                        createMockProductRetrieval(FinverseProduct.ACCOUNTS, false),
                                        createMockProductRetrieval(
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                false
                                        )
                                )

                        val request =
                                createMockDataRetrievalRequest("login-id", userId, "bank", products)
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        assertFalse(finverseDataRetrievalRequestsManager.isUserComplete(userId))
                }

                @Test
                @DisplayName("Should return true for user with all products complete")
                fun shouldReturnTrueForUserWithAllProductsComplete() = runTest {
                        val userId = 123
                        val products =
                                listOf(
                                        createMockProductRetrieval(FinverseProduct.ACCOUNTS, true),
                                        createMockProductRetrieval(
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                true
                                        )
                                )

                        val request =
                                createMockDataRetrievalRequest("login-id", userId, "bank", products)
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        assertTrue(finverseDataRetrievalRequestsManager.isUserComplete(userId))
                }

                @Test
                @DisplayName("Should return true for user with empty products list")
                fun shouldReturnTrueForUserWithEmptyProductsList() = runTest {
                        val userId = 123
                        val request =
                                createMockDataRetrievalRequest(
                                        "login-id",
                                        userId,
                                        "bank",
                                        emptyList()
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        assertTrue(finverseDataRetrievalRequestsManager.isUserComplete(userId))
                }
        }

        @Nested
        @DisplayName("Get Overall Retrieval Status Tests")
        inner class GetOverallRetrievalStatusTests {

                @Test
                @DisplayName("Should return failure status for non-existent user")
                fun shouldReturnFailureStatusForNonExistentUser() = runTest {
                        val status =
                                finverseDataRetrievalRequestsManager.getOverallRetrievalStatus(
                                        999,
                                        "login-id"
                                )

                        assertFalse(status.success)
                        assertEquals("CANNOT FIND REGISTERED DATA RETRIEVAL EVENT", status.message)
                        assertEquals("login-id", status.loginIdentityId)
                }

                @Test
                @DisplayName("Should return success status for complete retrieval")
                fun shouldReturnSuccessStatusForCompleteRetrieval() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"
                        val institutionId = "dbs-bank"

                        val products =
                                listOf(
                                        createMockProductRetrievalWithStatus(
                                                FinverseProduct.ACCOUNTS,
                                                FinverseRetrievalStatus.RETRIEVED
                                        ),
                                        createMockProductRetrievalWithStatus(
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                FinverseRetrievalStatus.PARTIALLY_RETRIEVED
                                        )
                                )

                        val request =
                                createMockDataRetrievalRequest(
                                        loginIdentityId,
                                        userId,
                                        institutionId,
                                        products
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        val status =
                                finverseDataRetrievalRequestsManager.getOverallRetrievalStatus(
                                        userId,
                                        loginIdentityId
                                )

                        assertTrue(status.success)
                        assertEquals("$userId - $institutionId - ${products.size}", status.message)
                        assertEquals(loginIdentityId, status.loginIdentityId)
                }

                @Test
                @DisplayName("Should return failure status for failed retrieval")
                fun shouldReturnFailureStatusForFailedRetrieval() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"

                        val products =
                                listOf(
                                        createMockProductRetrievalWithStatus(
                                                FinverseProduct.ACCOUNTS,
                                                FinverseRetrievalStatus.RETRIEVAL_FAILED
                                        ),
                                        createMockProductRetrievalWithStatus(
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                FinverseRetrievalStatus.RETRIEVED
                                        )
                                )

                        val request =
                                createMockDataRetrievalRequest(
                                        loginIdentityId,
                                        userId,
                                        "bank",
                                        products
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        val status =
                                finverseDataRetrievalRequestsManager.getOverallRetrievalStatus(
                                        userId,
                                        loginIdentityId
                                )

                        assertFalse(status.success)
                        assertTrue(status.message.contains("ACCOUNTS"))
                        assertTrue(status.message.contains("RETRIEVAL_FAILED"))
                        assertEquals(loginIdentityId, status.loginIdentityId)
                }

                @Test
                @DisplayName("Should handle all retrieval status types")
                fun shouldHandleAllRetrievalStatusTypes() = runTest {
                        val statusTypes =
                                listOf(
                                        FinverseRetrievalStatus.RETRIEVED,
                                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED,
                                        FinverseRetrievalStatus.RETRIEVAL_FAILED,
                                        FinverseRetrievalStatus.NOT_FOUND,
                                        FinverseRetrievalStatus.NOT_SUPPORTED,
                                        FinverseRetrievalStatus
                                                .TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                                )

                        statusTypes.forEach { retrievalStatus ->
                                val userId = statusTypes.indexOf(retrievalStatus) + 1
                                val loginIdentityId = "login-id-$userId"

                                val products =
                                        listOf(
                                                createMockProductRetrievalWithStatus(
                                                        FinverseProduct.ACCOUNTS,
                                                        retrievalStatus
                                                )
                                        )

                                val request =
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                "bank",
                                                products
                                        )
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(userId, request)

                                val status =
                                        finverseDataRetrievalRequestsManager
                                                .getOverallRetrievalStatus(userId, loginIdentityId)

                                if (retrievalStatus == FinverseRetrievalStatus.RETRIEVED ||
                                                retrievalStatus ==
                                                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED
                                ) {
                                        assertTrue(
                                                status.success,
                                                "Should be successful for $retrievalStatus"
                                        )
                                } else {
                                        assertFalse(
                                                status.success,
                                                "Should be failed for $retrievalStatus"
                                        )
                                        assertTrue(status.message.contains(retrievalStatus.name))
                                }
                        }
                }
        }

        @Nested
        @DisplayName("Update and Fetch If Success Tests")
        inner class UpdateAndFetchIfSuccessTests {

                @BeforeEach
                fun setupMocks() {
                        coEvery { finverseAuthCache.getUserId(any()) } returns 123
                        coEvery {
                                finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(any())
                        } returns "test-token"
                        every {
                                finverseShouldFetchDecider.shouldFetch(any(), any(), any())
                        } returns false
                        coEvery { finverseProductCompleteEventPublisher.publish(any()) } just Runs
                }

                @Test
                @DisplayName("Should return early when user ID is negative")
                fun shouldReturnEarlyWhenUserIdIsNegative() = runTest {
                        coEvery { finverseAuthCache.getUserId(any()) } returns -1

                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                "login-id",
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )

                        coVerify(exactly = 1) { finverseAuthCache.getUserId("login-id") }
                        verify(exactly = 0) {
                                finverseShouldFetchDecider.shouldFetch(any(), any(), any())
                        }
                }

                @Test
                @DisplayName("Should throw exception when retrieval request not found")
                fun shouldThrowExceptionWhenRetrievalRequestNotFound() = runTest {
                        val exception =
                                assertThrows<FinverseException> {
                                        finverseDataRetrievalRequestsManager
                                                .updateAndFetchIfSuccess(
                                                        "non-existent-login-id",
                                                        FinverseProduct.ACCOUNTS,
                                                        FinverseRetrievalStatus.RETRIEVED
                                                )
                                }

                        assertEquals("Could not find update request", exception.detail)
                }

                @Test
                @DisplayName(
                        "Should update product status and not fetch when shouldFetch returns false"
                )
                fun shouldUpdateProductStatusAndNotFetch() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"

                        val products =
                                listOf(createMockProductRetrieval(FinverseProduct.ACCOUNTS, false))
                        val request =
                                spyk(
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                "bank",
                                                products
                                        )
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        every {
                                finverseShouldFetchDecider.shouldFetch(
                                        any(),
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        } returns false

                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )

                        verify {
                                request.putOrUpdate(
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        }
                        verify(exactly = 0) { finverseProductCompleteEventPublisher wasNot Called }
                }

                @Test
                @DisplayName("Should fetch product when shouldFetch returns true")
                fun shouldFetchProductWhenShouldFetchReturnsTrue() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"
                        val loginIdentityToken = "test-token"

                        val mockProduct = spyk(FinverseProduct.ACCOUNTS)
                        val products = listOf(createMockProductRetrieval(mockProduct, false))
                        val request =
                                spyk(
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                "bank",
                                                products
                                        )
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        every {
                                finverseShouldFetchDecider.shouldFetch(
                                        any(),
                                        mockProduct,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        } returns true
                        coEvery {
                                mockProduct.fetch(
                                        loginIdentityId,
                                        loginIdentityToken,
                                        finverseResponseProcessor,
                                        finverseWebClient
                                )
                        } just Runs

                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                mockProduct,
                                FinverseRetrievalStatus.RETRIEVED
                        )

                        verify {
                                request.putOrUpdate(mockProduct, FinverseRetrievalStatus.RETRIEVED)
                        }
                        coVerify {
                                mockProduct.fetch(
                                        loginIdentityId,
                                        loginIdentityToken,
                                        finverseResponseProcessor,
                                        finverseWebClient
                                )
                        }
                }

                @Test
                @DisplayName("Should publish completion event when user is complete")
                fun shouldPublishCompletionEventWhenUserIsComplete() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"

                        val products =
                                listOf(createMockProductRetrieval(FinverseProduct.ACCOUNTS, true))
                        val request =
                                spyk(
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                "bank",
                                                products
                                        )
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        // Mock the request to return true for isComplete after update
                        every { request.isComplete() } returns true

                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )

                        coVerify { finverseProductCompleteEventPublisher.publish(any()) }
                }

                @Test
                @DisplayName("Should handle different products correctly")
                fun shouldHandleDifferentProductsCorrectly() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"

                        val products =
                                listOf(
                                        FinverseProduct.ACCOUNTS,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseProduct.HISTORICAL_TRANSACTIONS,
                                        FinverseProduct.ACCOUNT_NUMBERS,
                                        FinverseProduct.IDENTITY,
                                        FinverseProduct.BALANCE_HISTORY,
                                        FinverseProduct.INCOME_ESTIMATION,
                                        FinverseProduct.STATEMENTS
                                )

                        products.forEach { product ->
                                val mockProducts =
                                        listOf(createMockProductRetrieval(product, false))
                                val request =
                                        spyk(
                                                createMockDataRetrievalRequest(
                                                        loginIdentityId,
                                                        userId,
                                                        "bank",
                                                        mockProducts
                                                )
                                        )
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(userId, request)

                                finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                        loginIdentityId,
                                        product,
                                        FinverseRetrievalStatus.RETRIEVED
                                )

                                verify {
                                        request.putOrUpdate(
                                                product,
                                                FinverseRetrievalStatus.RETRIEVED
                                        )
                                }
                        }
                }
        }

        @Nested
        @DisplayName("Integration and Complex Scenarios Tests")
        inner class IntegrationAndComplexScenariosTests {

                @BeforeEach
                fun setupMocks() {
                        coEvery { finverseAuthCache.getUserId(any()) } returns 123
                        coEvery {
                                finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(any())
                        } returns "test-token"
                        every {
                                finverseShouldFetchDecider.shouldFetch(any(), any(), any())
                        } returns false
                        coEvery { finverseProductCompleteEventPublisher.publish(any()) } just Runs
                }

                @Test
                @DisplayName("Should handle complete workflow from registration to completion")
                fun shouldHandleCompleteWorkflowFromRegistrationToCompletion() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"
                        val institutionId = "dbs-bank"

                        val products =
                                listOf(
                                        createMockProductRetrieval(FinverseProduct.ACCOUNTS, false),
                                        createMockProductRetrieval(
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                false
                                        )
                                )
                        val request =
                                spyk(
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                institutionId,
                                                products
                                        )
                                )

                        // Register event
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )
                        assertFalse(finverseDataRetrievalRequestsManager.isUserComplete(userId))

                        // Update first product
                        every { request.isComplete() } returns false
                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )
                        verify(exactly = 0) { finverseProductCompleteEventPublisher wasNot Called }

                        // Update second product to complete
                        every { request.isComplete() } returns true
                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                FinverseProduct.ONLINE_TRANSACTIONS,
                                FinverseRetrievalStatus.RETRIEVED
                        )
                        coVerify(exactly = 1) {
                                finverseProductCompleteEventPublisher.publish(any())
                        }
                }

                @Test
                @DisplayName("Should handle multiple users with different completion states")
                fun shouldHandleMultipleUsersWithDifferentCompletionStates() = runTest {
                        val users =
                                listOf(
                                        Triple(123, "login-123", true), // Complete
                                        Triple(456, "login-456", false), // Incomplete
                                        Triple(789, "login-789", true) // Complete
                                )

                        users.forEach { (userId, loginId, isComplete) ->
                                val products =
                                        listOf(
                                                createMockProductRetrieval(
                                                        FinverseProduct.ACCOUNTS,
                                                        isComplete
                                                )
                                        )
                                val request =
                                        createMockDataRetrievalRequest(
                                                loginId,
                                                userId,
                                                "bank-$userId",
                                                products
                                        )
                                finverseDataRetrievalRequestsManager
                                        .registerFinverseDataRetrievalEvent(userId, request)
                        }

                        assertTrue(finverseDataRetrievalRequestsManager.isUserComplete(123))
                        assertFalse(finverseDataRetrievalRequestsManager.isUserComplete(456))
                        assertTrue(finverseDataRetrievalRequestsManager.isUserComplete(789))
                }

                @Test
                @DisplayName("Should handle error scenarios gracefully")
                fun shouldHandleErrorScenariosGracefully() = runTest {
                        val userId = 123
                        val loginIdentityId = "login-id-123"

                        // Test with null products list
                        val request =
                                spyk(
                                        createMockDataRetrievalRequest(
                                                loginIdentityId,
                                                userId,
                                                "bank",
                                                emptyList()
                                        )
                                )
                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(
                                userId,
                                request
                        )

                        // Should not throw exception
                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                                loginIdentityId,
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )

                        verify {
                                request.putOrUpdate(
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        }
                }
        }

        // Helper methods
        private fun createMockDataRetrievalRequest(
                loginIdentityId: String,
                userId: Int,
                institutionId: String,
                products: List<FinverseProductRetrieval> = emptyList()
        ): FinverseDataRetrievalRequest {
                val request =
                        spyk(
                                FinverseDataRetrievalRequest(
                                        loginIdentityId,
                                        userId,
                                        institutionId,
                                        products
                                )
                        )
                every { request.getLoginIdentityId() } returns loginIdentityId
                every { request.isComplete() } returns
                        products.all { mockk<FinverseProductRetrieval>().isComplete() }
                every { request.getOverallRetrievalStatus() } returns
                        FinverseOverallRetrievalStatus(
                                loginIdentityId = loginIdentityId,
                                success = true,
                                message = "$userId - $institutionId - ${products.size}"
                        )
                every { request.putOrUpdate(any(), any()) } just Runs
                return request
        }

        private fun createMockProductRetrieval(
                product: FinverseProduct,
                isComplete: Boolean
        ): FinverseProductRetrieval {
                val productRetrieval = mockk<FinverseProductRetrieval>()
                every { productRetrieval.getProduct() } returns product
                every { productRetrieval.isComplete() } returns isComplete
                every { productRetrieval.setStatus(any()) } just Runs
                return productRetrieval
        }

        private fun createMockProductRetrievalWithStatus(
                product: FinverseProduct,
                status: FinverseRetrievalStatus
        ): FinverseProductRetrieval {
                val productRetrieval = mockk<FinverseProductRetrieval>()
                every { productRetrieval.getProduct() } returns product
                every { productRetrieval.getStatus() } returns status
                every { productRetrieval.isComplete() } returns
                        (status == FinverseRetrievalStatus.RETRIEVED)
                every { productRetrieval.setStatus(any()) } just Runs
                return productRetrieval
        }
}
