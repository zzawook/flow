package sg.flow.services.TransferServices

import io.mockk.*
import java.time.LocalDateTime
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.entities.Bank
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult
import sg.flow.services.BankQueryServices.BankQueryService
import sg.flow.services.BankQueryServices.PayNowQueryService

@DisplayName("TransferService Tests")
class TransferServiceTest {

    private lateinit var payNowQueryService: PayNowQueryService
    private lateinit var bankQueryService: BankQueryService
    private lateinit var transferService: TransferService

    @BeforeEach
    fun setUp() {
        payNowQueryService = mockk()
        bankQueryService = mockk()
        transferService = TransferServiceImpl(payNowQueryService, bankQueryService)
    }

    @Nested
    @DisplayName("Send Transaction Tests")
    inner class SendTransactionTests {

        @Test
        @DisplayName("Should delegate to PayNowQueryService for send transaction")
        fun shouldDelegateToPayNowQueryService() = runTest {
            val recipient =
                    TransferRecepient(
                            name = "Test Recipient",
                            accountNumber = "123456789",
                            bankCode = "DBS001"
                    )

            val transferRequest =
                    TransferRequestBody(
                            senderAccountNumber = "987654321",
                            recepient = recipient,
                            amount = 100.00,
                            note = "Test transfer",
                            scheduledAt = null
                    )

            val expectedResult = TransferResult(success = true, message = "Transfer completed")
            coEvery { payNowQueryService.sendTransaction(transferRequest) } returns expectedResult

            val result = transferService.sendTransaction(transferRequest)

            assertEquals(expectedResult, result)
            coVerify { payNowQueryService.sendTransaction(transferRequest) }
        }

        @Test
        @DisplayName("Should handle scheduled transfers")
        fun shouldHandleScheduledTransfers() = runTest {
            val recipient =
                    TransferRecepient(
                            name = "Future Recipient",
                            accountNumber = "123456789",
                            bankCode = "OCBC001"
                    )

            val futureTime = LocalDateTime.now().plusDays(1)
            val transferRequest =
                    TransferRequestBody(
                            senderAccountNumber = "987654321",
                            recepient = recipient,
                            amount = 250.00,
                            note = "Scheduled transfer",
                            scheduledAt = futureTime
                    )

            val expectedResult = TransferResult(success = true, message = "Transfer scheduled")
            coEvery { payNowQueryService.sendTransaction(transferRequest) } returns expectedResult

            val result = transferService.sendTransaction(transferRequest)

            assertEquals(expectedResult, result)
            coVerify { payNowQueryService.sendTransaction(transferRequest) }
        }

        @Test
        @DisplayName("Should handle transfer failures")
        fun shouldHandleTransferFailures() = runTest {
            val recipient =
                    TransferRecepient(
                            name = "Failed Recipient",
                            accountNumber = "123456789",
                            bankCode = "FAIL001"
                    )

            val transferRequest =
                    TransferRequestBody(
                            senderAccountNumber = "987654321",
                            recepient = recipient,
                            amount = 100.00,
                            note = "Failed transfer",
                            scheduledAt = null
                    )

            val expectedResult = TransferResult(success = false, message = "Transfer failed")
            coEvery { payNowQueryService.sendTransaction(transferRequest) } returns expectedResult

            val result = transferService.sendTransaction(transferRequest)

            assertFalse(result.success)
            assertEquals("Transfer failed", result.message)
            coVerify { payNowQueryService.sendTransaction(transferRequest) }
        }
    }

    @Nested
    @DisplayName("Get Relevant Recipients Tests")
    inner class GetRelevantRecipientsTests {

        @Test
        @DisplayName("Should return empty list from getRelevantRecepient")
        fun shouldReturnEmptyListFromGetRelevantRecepient() = runTest {
            // The current implementation returns emptyList() from getRecentTransactionTargets()
            val result = transferService.getRelevantRecepient()

            assertTrue(result.isEmpty())
        }

        @Test
        @DisplayName("Should delegate to BankQueryService for account number search")
        fun shouldDelegateToBankQueryServiceForAccountNumber() = runTest {
            val accountNumber = "123456789"
            val expectedBanks =
                    listOf(
                            Bank(id = 1, name = "DBS Bank", bankCode = "DBS001"),
                            Bank(id = 2, name = "OCBC Bank", bankCode = "OCBC001")
                    )

            coEvery { bankQueryService.getBanksWithAccountNumber(accountNumber) } returns
                    expectedBanks

            val result = transferService.getRelevantRecepientByAccountNumber(accountNumber)

            assertEquals(expectedBanks, result)
            coVerify { bankQueryService.getBanksWithAccountNumber(accountNumber) }
        }

        @Test
        @DisplayName("Should delegate to PayNowQueryService for contact search")
        fun shouldDelegateToPayNowQueryServiceForContact() = runTest {
            val contact = "john.doe@email.com"
            val expectedRecipient =
                    TransferRecepient(
                            name = "John Doe",
                            accountNumber = "123456789",
                            bankCode = "DBS001"
                    )

            coEvery { payNowQueryService.getRecepientByContact(contact) } returns expectedRecipient

            val result = transferService.getRelevantRecepientByContact(contact)

            assertEquals(expectedRecipient, result)
            coVerify { payNowQueryService.getRecepientByContact(contact) }
        }

        @Test
        @DisplayName("Should handle empty account number")
        fun shouldHandleEmptyAccountNumber() = runTest {
            val emptyAccountNumber = ""

            coEvery { bankQueryService.getBanksWithAccountNumber(emptyAccountNumber) } returns
                    emptyList()

            val result = transferService.getRelevantRecepientByAccountNumber(emptyAccountNumber)

            assertTrue(result.isEmpty())
            coVerify { bankQueryService.getBanksWithAccountNumber(emptyAccountNumber) }
        }

        @Test
        @DisplayName("Should handle special characters in contact")
        fun shouldHandleSpecialCharactersInContact() = runTest {
            val specialContact = "user+test@domain.co.uk"
            val expectedRecipient =
                    TransferRecepient(
                            name = "Special User",
                            accountNumber = "123456789",
                            bankCode = "SPEC001"
                    )

            coEvery { payNowQueryService.getRecepientByContact(specialContact) } returns
                    expectedRecipient

            val result = transferService.getRelevantRecepientByContact(specialContact)

            assertEquals(expectedRecipient, result)
            coVerify { payNowQueryService.getRecepientByContact(specialContact) }
        }
    }

    @Nested
    @DisplayName("Service Integration Tests")
    inner class ServiceIntegrationTests {

        @Test
        @DisplayName("Should handle multiple operations without interference")
        fun shouldHandleMultipleOperationsWithoutInterference() = runTest {
            // Setup for bank query
            val accountNumber = "123456789"
            val expectedBanks = listOf(Bank(id = 1, name = "Test Bank", bankCode = "TEST001"))
            coEvery { bankQueryService.getBanksWithAccountNumber(accountNumber) } returns
                    expectedBanks

            // Setup for contact query
            val contact = "test@example.com"
            val expectedRecipient = TransferRecepient("Test User", "987654321", "TEST002")
            coEvery { payNowQueryService.getRecepientByContact(contact) } returns expectedRecipient

            // Setup for transaction
            val transferRequest =
                    TransferRequestBody(
                            senderAccountNumber = "111222333",
                            recepient = expectedRecipient,
                            amount = 50.0,
                            note = "Integration test",
                            scheduledAt = null
                    )
            val expectedResult = TransferResult(success = true, message = "Success")
            coEvery { payNowQueryService.sendTransaction(transferRequest) } returns expectedResult

            // Execute all operations
            val bankResult = transferService.getRelevantRecepientByAccountNumber(accountNumber)
            val contactResult = transferService.getRelevantRecepientByContact(contact)
            val transferResult = transferService.sendTransaction(transferRequest)
            val recipientListResult = transferService.getRelevantRecepient()

            // Verify results
            assertEquals(expectedBanks, bankResult)
            assertEquals(expectedRecipient, contactResult)
            assertEquals(expectedResult, transferResult)
            assertTrue(recipientListResult.isEmpty())

            // Verify all service calls were made
            coVerify { bankQueryService.getBanksWithAccountNumber(accountNumber) }
            coVerify { payNowQueryService.getRecepientByContact(contact) }
            coVerify { payNowQueryService.sendTransaction(transferRequest) }
        }
    }
}
