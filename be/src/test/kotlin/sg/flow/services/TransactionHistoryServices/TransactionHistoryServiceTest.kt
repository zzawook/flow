package sg.flow.services.TransactionHistoryServices

import java.time.LocalDate
import java.time.LocalTime
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList

@DisplayName("TransactionHistoryService Tests - Basic")
class TransactionHistoryServiceTest {

    @Test
    @DisplayName("Should test TransactionHistoryDetail model")
    fun `should test TransactionHistoryDetail model`() {
        val detail =
                TransactionHistoryDetail(
                        id = 123L,
                        transactionReference = "TXN123456",
                        account = null,
                        card = null,
                        transactionDate = LocalDate.of(2024, 1, 15),
                        transactionTime = LocalTime.of(14, 30, 0),
                        amount = 250.50,
                        transactionType = "TRANSFER",
                        description = "Payment to merchant",
                        transactionStatus = "COMPLETED",
                        friendlyDescription = "Coffee shop payment"
                )

        assertEquals(123L, detail.id)
        assertEquals("TXN123456", detail.transactionReference)
        assertNull(detail.account)
        assertNull(detail.card)
        assertEquals(LocalDate.of(2024, 1, 15), detail.transactionDate)
        assertEquals(LocalTime.of(14, 30, 0), detail.transactionTime)
        assertEquals(250.50, detail.amount)
        assertEquals("TRANSFER", detail.transactionType)
        assertEquals("Payment to merchant", detail.description)
        assertEquals("COMPLETED", detail.transactionStatus)
        assertEquals("Coffee shop payment", detail.friendlyDescription)
    }

    @Test
    @DisplayName("Should test TransactionHistoryList model")
    fun `should test TransactionHistoryList model`() {
        val startDate = LocalDate.of(2024, 1, 1)
        val endDate = LocalDate.of(2024, 1, 31)
        val historyList = TransactionHistoryList(startDate, endDate)

        assertEquals(startDate, historyList.startDate)
        assertEquals(endDate, historyList.endDate)
        assertTrue(historyList.transactions.isEmpty())
    }

    @Test
    @DisplayName("Should add transactions to TransactionHistoryList")
    fun `should add transactions to TransactionHistoryList`() {
        val historyList =
                TransactionHistoryList(
                        startDate = LocalDate.of(2024, 1, 1),
                        endDate = LocalDate.of(2024, 1, 31)
                )

        val transaction1 =
                TransactionHistoryDetail(id = 1L, amount = 100.0, description = "Transaction 1")

        val transaction2 =
                TransactionHistoryDetail(id = 2L, amount = 200.0, description = "Transaction 2")

        historyList.add(transaction1)
        historyList.add(transaction2)

        assertEquals(2, historyList.transactions.size)
        assertEquals(transaction1, historyList.transactions[0])
        assertEquals(transaction2, historyList.transactions[1])
    }

    @Test
    @DisplayName("Should handle edge case amounts")
    fun `should handle edge case amounts`() {
        val zeroAmount =
                TransactionHistoryDetail(id = 1L, amount = 0.0, description = "Zero amount")
        val negativeAmount =
                TransactionHistoryDetail(id = 2L, amount = -50.0, description = "Negative amount")
        val largeAmount =
                TransactionHistoryDetail(
                        id = 3L,
                        amount = Double.MAX_VALUE,
                        description = "Large amount"
                )

        assertEquals(0.0, zeroAmount.amount)
        assertEquals(-50.0, negativeAmount.amount)
        assertEquals(Double.MAX_VALUE, largeAmount.amount)
    }

    @Test
    @DisplayName("Should handle null optional fields")
    fun `should handle null optional fields`() {
        val detail =
                TransactionHistoryDetail(
                        id = 1L,
                        transactionReference = null,
                        account = null,
                        card = null,
                        transactionDate = null,
                        transactionTime = null,
                        amount = 100.0,
                        transactionType = null,
                        description = "Required description",
                        transactionStatus = null,
                        friendlyDescription = null
                )

        assertEquals(1L, detail.id)
        assertNull(detail.transactionReference)
        assertNull(detail.account)
        assertNull(detail.card)
        assertNull(detail.transactionDate)
        assertNull(detail.transactionTime)
        assertEquals(100.0, detail.amount)
        assertNull(detail.transactionType)
        assertEquals("Required description", detail.description)
        assertNull(detail.transactionStatus)
        assertNull(detail.friendlyDescription)
    }

    @Test
    @DisplayName("Should handle date range validation")
    fun `should handle date range validation`() {
        val startDate = LocalDate.of(2024, 1, 15)
        val endDate = LocalDate.of(2024, 1, 10) // End before start

        val historyList = TransactionHistoryList(startDate, endDate)

        assertEquals(startDate, historyList.startDate)
        assertEquals(endDate, historyList.endDate)
        // Note: The model doesn't validate date logic, it just stores the values
    }

    @Test
    @DisplayName("Should handle very long description")
    fun `should handle very long description`() {
        val longDescription = "A".repeat(10000)
        val detail =
                TransactionHistoryDetail(id = 1L, amount = 100.0, description = longDescription)

        assertEquals(longDescription, detail.description)
        assertEquals(10000, detail.description.length)
    }

    @Test
    @DisplayName("Should handle special characters in descriptions")
    fun `should handle special characters in descriptions`() {
        val specialDescription = "Payment to 北京 Coffee ☕ @#$%^&*()_+-=[]{}|;':\",./<>?"
        val detail =
                TransactionHistoryDetail(id = 1L, amount = 100.0, description = specialDescription)

        assertEquals(specialDescription, detail.description)
    }
}
