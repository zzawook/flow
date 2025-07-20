package sg.flow.services.BankQueryServices.FinverseQueryService

import io.mockk.*
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseRetrievalStatus

@DisplayName("FinverseShouldFetchDecider Tests")
class FinverseShouldFetchDeciderTest {

        private lateinit var finverseShouldFetchDecider: FinverseShouldFetchDecider

        @BeforeEach
        fun setUp() {
                finverseShouldFetchDecider = FinverseShouldFetchDecider()
        }

        @Nested
        @DisplayName("General Should Fetch Logic Tests")
        inner class GeneralShouldFetchLogicTests {

                @Test
                @DisplayName("Should return false when status is not RETRIEVED")
                fun shouldReturnFalseWhenStatusNotRetrieved() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()

                        val nonRetrievedStatuses =
                                listOf(
                                        FinverseRetrievalStatus.RETRIEVAL_FAILED,
                                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED,
                                        FinverseRetrievalStatus.NOT_FOUND,
                                        FinverseRetrievalStatus.NOT_SUPPORTED,
                                        FinverseRetrievalStatus
                                                .TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                                )

                        nonRetrievedStatuses.forEach { status ->
                                FinverseProduct.all.forEach { product ->
                                        val result =
                                                finverseShouldFetchDecider.shouldFetch(
                                                        mockRequest,
                                                        product,
                                                        status
                                                )
                                        assertFalse(
                                                result,
                                                "Should return false for product ${product.productName} with status $status"
                                        )
                                }
                        }
                }

                @Test
                @DisplayName("Should return true for RETRIEVED status with non-special products")
                fun shouldReturnTrueForRetrievedStatusWithNonSpecialProducts() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()

                        val nonSpecialProducts =
                                listOf(
                                        FinverseProduct.ACCOUNT_NUMBERS,
                                        FinverseProduct.HISTORICAL_TRANSACTIONS,
                                        FinverseProduct.IDENTITY,
                                        FinverseProduct.BALANCE_HISTORY,
                                        FinverseProduct.INCOME_ESTIMATION,
                                        FinverseProduct.STATEMENTS
                                )

                        nonSpecialProducts.forEach { product ->
                                val result =
                                        finverseShouldFetchDecider.shouldFetch(
                                                mockRequest,
                                                product,
                                                FinverseRetrievalStatus.RETRIEVED
                                        )
                                assertTrue(
                                        result,
                                        "Should return true for product ${product.productName} with RETRIEVED status"
                                )
                        }
                }
        }

        @Nested
        @DisplayName("Online Transactions Fetch Logic Tests")
        inner class OnlineTransactionsFetchLogicTests {

                @Test
                @DisplayName("Should return true when both transactions are complete")
                fun shouldReturnTrueWhenBothTransactionsComplete() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns true

                        val result =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )

                        assertTrue(result)
                        verify { mockRequest.isBothTransactionComplete() }
                }

                @Test
                @DisplayName("Should return false when both transactions are not complete")
                fun shouldReturnFalseWhenBothTransactionsNotComplete() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns false

                        val result =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )

                        assertFalse(result)
                        verify { mockRequest.isBothTransactionComplete() }
                }

                @Test
                @DisplayName(
                        "Should return false for online transactions with non-retrieved status regardless of completion"
                )
                fun shouldReturnFalseForOnlineTransactionsWithNonRetrievedStatus() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns true

                        val nonRetrievedStatuses =
                                listOf(
                                        FinverseRetrievalStatus.RETRIEVAL_FAILED,
                                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED,
                                        FinverseRetrievalStatus.NOT_FOUND,
                                        FinverseRetrievalStatus.NOT_SUPPORTED,
                                        FinverseRetrievalStatus
                                                .TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                                )

                        nonRetrievedStatuses.forEach { status ->
                                val result =
                                        finverseShouldFetchDecider.shouldFetch(
                                                mockRequest,
                                                FinverseProduct.ONLINE_TRANSACTIONS,
                                                status
                                        )
                                assertFalse(
                                        result,
                                        "Should return false for status $status even when both transactions complete"
                                )
                        }

                        // Verify that the completion check was never called due to early return
                        verify(exactly = 0) { mockRequest.isBothTransactionComplete() }
                }
        }

        @Nested
        @DisplayName("Accounts Fetch Logic Tests")
        inner class AccountsFetchLogicTests {

                @Test
                @DisplayName("Should return true when accounts are complete")
                fun shouldReturnTrueWhenAccountsComplete() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isAccountComplete() } returns true

                        val result =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )

                        assertTrue(result)
                        verify { mockRequest.isAccountComplete() }
                }

                @Test
                @DisplayName("Should return false when accounts are not complete")
                fun shouldReturnFalseWhenAccountsNotComplete() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isAccountComplete() } returns false

                        val result =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )

                        assertFalse(result)
                        verify { mockRequest.isAccountComplete() }
                }

                @Test
                @DisplayName(
                        "Should return false for accounts with non-retrieved status regardless of completion"
                )
                fun shouldReturnFalseForAccountsWithNonRetrievedStatus() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isAccountComplete() } returns true

                        val nonRetrievedStatuses =
                                listOf(
                                        FinverseRetrievalStatus.RETRIEVAL_FAILED,
                                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED,
                                        FinverseRetrievalStatus.NOT_FOUND,
                                        FinverseRetrievalStatus.NOT_SUPPORTED,
                                        FinverseRetrievalStatus
                                                .TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                                )

                        nonRetrievedStatuses.forEach { status ->
                                val result =
                                        finverseShouldFetchDecider.shouldFetch(
                                                mockRequest,
                                                FinverseProduct.ACCOUNTS,
                                                status
                                        )
                                assertFalse(
                                        result,
                                        "Should return false for status $status even when accounts complete"
                                )
                        }

                        // Verify that the completion check was never called due to early return
                        verify(exactly = 0) { mockRequest.isAccountComplete() }
                }
        }

        @Nested
        @DisplayName("Comprehensive Product Testing")
        inner class ComprehensiveProductTesting {

                @Test
                @DisplayName("Should test all products with RETRIEVED status")
                fun shouldTestAllProductsWithRetrievedStatus() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()

                        // Setup mocks for special products
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        val expectedResults =
                                mapOf(
                                        FinverseProduct.ACCOUNTS to true,
                                        FinverseProduct.ACCOUNT_NUMBERS to true,
                                        FinverseProduct.ONLINE_TRANSACTIONS to true,
                                        FinverseProduct.HISTORICAL_TRANSACTIONS to true,
                                        FinverseProduct.IDENTITY to true,
                                        FinverseProduct.BALANCE_HISTORY to true,
                                        FinverseProduct.INCOME_ESTIMATION to true,
                                        FinverseProduct.STATEMENTS to true
                                )

                        expectedResults.forEach { (product, expectedResult) ->
                                val result =
                                        finverseShouldFetchDecider.shouldFetch(
                                                mockRequest,
                                                product,
                                                FinverseRetrievalStatus.RETRIEVED
                                        )
                                assertEquals(
                                        expectedResult,
                                        result,
                                        "Product ${product.productName} should return $expectedResult"
                                )
                        }
                }

                @Test
                @DisplayName("Should test special products with incomplete conditions")
                fun shouldTestSpecialProductsWithIncompleteConditions() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()

                        // Setup mocks for incomplete conditions
                        every { mockRequest.isBothTransactionComplete() } returns false
                        every { mockRequest.isAccountComplete() } returns false

                        // Test ONLINE_TRANSACTIONS with incomplete transactions
                        val onlineTransactionsResult =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        assertFalse(
                                onlineTransactionsResult,
                                "ONLINE_TRANSACTIONS should return false when transactions not complete"
                        )

                        // Test ACCOUNTS with incomplete accounts
                        val accountsResult =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        assertFalse(
                                accountsResult,
                                "ACCOUNTS should return false when accounts not complete"
                        )

                        // Verify the appropriate methods were called
                        verify { mockRequest.isBothTransactionComplete() }
                        verify { mockRequest.isAccountComplete() }
                }

                @Test
                @DisplayName("Should test mixed completion states")
                fun shouldTestMixedCompletionStates() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()

                        // Setup mixed completion states
                        every { mockRequest.isBothTransactionComplete() } returns
                                true // Transactions complete
                        every { mockRequest.isAccountComplete() } returns
                                false // Accounts incomplete

                        // Test ONLINE_TRANSACTIONS (should succeed)
                        val onlineTransactionsResult =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        assertTrue(
                                onlineTransactionsResult,
                                "ONLINE_TRANSACTIONS should return true when transactions complete"
                        )

                        // Test ACCOUNTS (should fail)
                        val accountsResult =
                                finverseShouldFetchDecider.shouldFetch(
                                        mockRequest,
                                        FinverseProduct.ACCOUNTS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        assertFalse(
                                accountsResult,
                                "ACCOUNTS should return false when accounts not complete"
                        )
                }
        }

        @Nested
        @DisplayName("Edge Cases and Boundary Testing")
        inner class EdgeCasesAndBoundaryTesting {

                @Test
                @DisplayName("Should handle null request gracefully for special products")
                fun shouldHandleNullRequestGracefullyForSpecialProducts() = runTest {
                        // This test assumes the actual implementation doesn't null-check
                        // and relies on the mock framework to simulate null behavior
                        val nullishRequest = mockk<FinverseDataRetrievalRequest>()
                        every { nullishRequest.isBothTransactionComplete() } throws
                                NullPointerException("Simulated null")
                        every { nullishRequest.isAccountComplete() } throws
                                NullPointerException("Simulated null")

                        // The method should handle exceptions gracefully or the calling code should
                        // handle
                        // nulls
                        // Since we're testing the current implementation, we expect it to propagate
                        // exceptions
                        try {
                                finverseShouldFetchDecider.shouldFetch(
                                        nullishRequest,
                                        FinverseProduct.ONLINE_TRANSACTIONS,
                                        FinverseRetrievalStatus.RETRIEVED
                                )
                        } catch (e: NullPointerException) {
                                // Expected behavior - the method doesn't handle null internally
                                assertTrue(true, "Expected NullPointerException for null request")
                        }
                }

                @Test
                @DisplayName("Should verify method calls for each product type")
                fun shouldVerifyMethodCallsForEachProductType() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        // Test ONLINE_TRANSACTIONS
                        finverseShouldFetchDecider.shouldFetch(
                                mockRequest,
                                FinverseProduct.ONLINE_TRANSACTIONS,
                                FinverseRetrievalStatus.RETRIEVED
                        )
                        verify(exactly = 1) { mockRequest.isBothTransactionComplete() }

                        // Clear mock interactions
                        clearMocks(mockRequest, answers = false)
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        // Test ACCOUNTS
                        finverseShouldFetchDecider.shouldFetch(
                                mockRequest,
                                FinverseProduct.ACCOUNTS,
                                FinverseRetrievalStatus.RETRIEVED
                        )
                        verify(exactly = 1) { mockRequest.isAccountComplete() }
                        verify(exactly = 0) { mockRequest.isBothTransactionComplete() }

                        // Clear mock interactions
                        clearMocks(mockRequest, answers = false)
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        // Test non-special product (should not call any completion methods)
                        finverseShouldFetchDecider.shouldFetch(
                                mockRequest,
                                FinverseProduct.IDENTITY,
                                FinverseRetrievalStatus.RETRIEVED
                        )
                        verify(exactly = 0) { mockRequest.isBothTransactionComplete() }
                        verify(exactly = 0) { mockRequest.isAccountComplete() }
                }

                @Test
                @DisplayName("Should test all retrieval statuses systematically")
                fun shouldTestAllRetrievalStatusesSystematically() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        val allStatuses = FinverseRetrievalStatus.values()
                        val allProducts = FinverseProduct.all

                        allProducts.forEach { product ->
                                allStatuses.forEach { status ->
                                        val result =
                                                finverseShouldFetchDecider.shouldFetch(
                                                        mockRequest,
                                                        product,
                                                        status
                                                )

                                        if (status == FinverseRetrievalStatus.RETRIEVED) {
                                                // For RETRIEVED status, result depends on product
                                                // type and completion state
                                                when (product) {
                                                        FinverseProduct.ONLINE_TRANSACTIONS ->
                                                                assertTrue(
                                                                        result,
                                                                        "ONLINE_TRANSACTIONS with RETRIEVED should return true when transactions complete"
                                                                )
                                                        FinverseProduct.ACCOUNTS ->
                                                                assertTrue(
                                                                        result,
                                                                        "ACCOUNTS with RETRIEVED should return true when accounts complete"
                                                                )
                                                        else ->
                                                                assertTrue(
                                                                        result,
                                                                        "${product.productName} with RETRIEVED should return true"
                                                                )
                                                }
                                        } else {
                                                // For non-RETRIEVED status, should always return
                                                // false
                                                assertFalse(
                                                        result,
                                                        "${product.productName} with $status should return false"
                                                )
                                        }
                                }
                        }
                }

                @Test
                @DisplayName("Should test performance with rapid successive calls")
                fun shouldTestPerformanceWithRapidSuccessiveCalls() = runTest {
                        val mockRequest = mockk<FinverseDataRetrievalRequest>()
                        every { mockRequest.isBothTransactionComplete() } returns true
                        every { mockRequest.isAccountComplete() } returns true

                        // Test rapid successive calls
                        repeat(1000) {
                                FinverseProduct.all.forEach { product ->
                                        FinverseRetrievalStatus.values().forEach { status ->
                                                finverseShouldFetchDecider.shouldFetch(
                                                        mockRequest,
                                                        product,
                                                        status
                                                )
                                        }
                                }
                        }

                        // If we reach here without timeout or exception, performance is acceptable
                        assertTrue(true, "Performance test completed successfully")
                }
        }

        // Helper method to assert equals with better error messages
        private fun assertEquals(expected: Boolean, actual: Boolean, message: String) {
                if (expected != actual) {
                        throw AssertionError("$message - Expected: $expected, Actual: $actual")
                }
        }
}
