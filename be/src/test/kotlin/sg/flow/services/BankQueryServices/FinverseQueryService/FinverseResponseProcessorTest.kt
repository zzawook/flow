package sg.flow.services.BankQueryServices.FinverseQueryService

import io.mockk.*
import java.time.LocalDate
import java.time.LocalTime
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.entities.Account
import sg.flow.entities.utils.AccountType
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.responses.*
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.bank.BankRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.repositories.user.UserRepository
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

@DisplayName("FinverseResponseProcessor Tests")
class FinverseResponseProcessorTest {

        private lateinit var userRepository: UserRepository
        private lateinit var bankRepository: BankRepository
        private lateinit var accountRepository: AccountRepository
        private lateinit var transactionRepository: TransactionHistoryRepository
        private lateinit var finverseWebClient: WebClient

        private lateinit var finverseResponseProcessor: FinverseResponseProcessor

        @BeforeEach
        fun setUp() {
                userRepository = mockk()
                bankRepository = mockk()
                accountRepository = mockk()
                transactionRepository = mockk()
                finverseWebClient = mockk()

                finverseResponseProcessor =
                        FinverseResponseProcessor(
                                userRepository,
                                bankRepository,
                                accountRepository,
                                transactionRepository,
                                finverseWebClient
                        )
        }

        @Nested
        @DisplayName("Process Account List Tests")
        inner class ProcessAccountListTests {

                @Test
                @DisplayName("Should save all accounts in the list")
                fun shouldSaveAllAccountsInList() = runTest {
                        val accounts =
                                listOf(
                                        createMockAccount("1", "DBS Savings", "SAVINGS"),
                                        createMockAccount("2", "OCBC Current", "CURRENT"),
                                        createMockAccount("3", "UOB Fixed Deposit", "FIXED_DEPOSIT")
                                )

                        coEvery { accountRepository.save(any()) } returns mockk()

                        finverseResponseProcessor.processAccountList(accounts)

                        accounts.forEach { account -> coVerify { accountRepository.save(account) } }
                }

                @Test
                @DisplayName("Should handle empty account list")
                fun shouldHandleEmptyAccountList() = runTest {
                        val emptyAccounts = emptyList<Account>()

                        finverseResponseProcessor.processAccountList(emptyAccounts)

                        coVerify(exactly = 0) { accountRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle single account")
                fun shouldHandleSingleAccount() = runTest {
                        val singleAccount =
                                listOf(createMockAccount("1", "Single Account", "SAVINGS"))

                        coEvery { accountRepository.save(any()) } returns mockk()

                        finverseResponseProcessor.processAccountList(singleAccount)

                        coVerify(exactly = 1) { accountRepository.save(any()) }
                }
        }

        @Nested
        @DisplayName("Process Accounts Response Into Account List Tests")
        inner class ProcessAccountsResponseIntoAccountListTests {

                @Test
                @DisplayName(
                        "Should convert Finverse account response to account list successfully"
                )
                fun shouldConvertFinverseAccountResponseSuccessfully() = runTest {
                        val finverseAccountData =
                                listOf(
                                        FinverseAccountData(
                                                accountId = "finverse-acc-1",
                                                accountNumber = "123456789",
                                                accountName = "DBS Savings Account",
                                                accountType = "SAVINGS",
                                                balance = 1000.0,
                                                availableBalance = 950.0,
                                                currency = "SGD",
                                                institutionId = "dbs-sg",
                                                institutionName = "DBS Bank",
                                                bankCode = "DBS001"
                                        ),
                                        FinverseAccountData(
                                                accountId = "finverse-acc-2",
                                                accountNumber = "987654321",
                                                accountName = "OCBC Current Account",
                                                accountType = "CURRENT",
                                                balance = 2500.0,
                                                availableBalance = 2400.0,
                                                currency = "SGD",
                                                institutionId = "ocbc-sg",
                                                institutionName = "OCBC Bank",
                                                bankCode = "OCBC001"
                                        )
                                )

                        val response = FinverseAccountResponse(accounts = finverseAccountData)

                        val result =
                                finverseResponseProcessor.processAccountsResponseIntoAccountList(
                                        response
                                )

                        assertEquals(2, result.size)
                        // Note: We can't test the exact mapping without mocking the internal
                        // mappers
                        // but we can verify that the response was processed
                        assertNotNull(result)
                }

                @Test
                @DisplayName("Should throw exception when account response is empty")
                fun shouldThrowExceptionWhenAccountResponseEmpty() = runTest {
                        val emptyResponse = FinverseAccountResponse(accounts = emptyList())

                        val exception =
                                assertThrows<FinverseException> {
                                        finverseResponseProcessor
                                                .processAccountsResponseIntoAccountList(
                                                        emptyResponse
                                                )
                                }

                        assertEquals("ACCOUNT RESPONSE IS EMPTY", exception.detail)
                }

                @Test
                @DisplayName("Should throw exception when accounts field is null")
                fun shouldThrowExceptionWhenAccountsFieldNull() = runTest {
                        val nullResponse = FinverseAccountResponse(accounts = null)

                        val exception =
                                assertThrows<FinverseException> {
                                        finverseResponseProcessor
                                                .processAccountsResponseIntoAccountList(
                                                        nullResponse
                                                )
                                }

                        assertEquals("ACCOUNT RESPONSE IS EMPTY", exception.detail)
                }

                @Test
                @DisplayName("Should handle single account in response")
                fun shouldHandleSingleAccountInResponse() = runTest {
                        val singleAccountData =
                                listOf(
                                        FinverseAccountData(
                                                accountId = "finverse-acc-1",
                                                accountNumber = "123456789",
                                                accountName = "Single Account",
                                                accountType = "SAVINGS",
                                                balance = 1000.0,
                                                currency = "SGD",
                                                institutionId = "dbs-sg",
                                                institutionName = "DBS Bank"
                                        )
                                )

                        val response = FinverseAccountResponse(accounts = singleAccountData)

                        val result =
                                finverseResponseProcessor.processAccountsResponseIntoAccountList(
                                        response
                                )

                        assertEquals(1, result.size)
                }
        }

        @Nested
        @DisplayName("Process Transactions Response Tests")
        inner class ProcessTransactionsResponseTests {

                @BeforeEach
                fun setupMocks() {
                        coEvery { transactionRepository.save(any()) } returns mockk()
                }

                @Test
                @DisplayName("Should process transaction response and save all transactions")
                fun shouldProcessTransactionResponseAndSaveAll() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "txn-1",
                                                accountId = "acc-1",
                                                amount = -50.0,
                                                currency = "SGD",
                                                date = LocalDate.of(2024, 1, 15),
                                                time = LocalTime.of(14, 30),
                                                description = "Coffee Shop Purchase",
                                                transactionType = "DEBIT",
                                                status = "COMPLETED",
                                                merchantName = "Starbucks",
                                                cardNumber = "1234"
                                        ),
                                        FinverseTransactionData(
                                                transactionId = "txn-2",
                                                accountId = "acc-1",
                                                amount = 1000.0,
                                                currency = "SGD",
                                                date = LocalDate.of(2024, 1, 16),
                                                description = "Salary Deposit",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        )
                                )

                        val response =
                                FinverseTransactionResponse(
                                        transactions = transactionData,
                                        accountId = "acc-1"
                                )

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(2, result.size)
                        coVerify(exactly = 2) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle empty transaction response")
                fun shouldHandleEmptyTransactionResponse() = runTest {
                        val emptyResponse =
                                FinverseTransactionResponse(
                                        transactions = emptyList(),
                                        accountId = "acc-1"
                                )

                        val result =
                                finverseResponseProcessor.processTransactionsResponse(emptyResponse)

                        assertEquals(0, result.size)
                        coVerify(exactly = 0) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle null transactions field")
                fun shouldHandleNullTransactionsField() = runTest {
                        val nullResponse =
                                FinverseTransactionResponse(
                                        transactions = null,
                                        accountId = "acc-1"
                                )

                        val result =
                                finverseResponseProcessor.processTransactionsResponse(nullResponse)

                        assertEquals(0, result.size)
                        coVerify(exactly = 0) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle transactions with different currencies")
                fun shouldHandleTransactionsWithDifferentCurrencies() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "txn-sgd",
                                                accountId = "acc-1",
                                                amount = 100.0,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "SGD Transaction",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        ),
                                        FinverseTransactionData(
                                                transactionId = "txn-usd",
                                                accountId = "acc-1",
                                                amount = 75.0,
                                                currency = "USD",
                                                date = LocalDate.now(),
                                                description = "USD Transaction",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        ),
                                        FinverseTransactionData(
                                                transactionId = "txn-eur",
                                                accountId = "acc-1",
                                                amount = 85.0,
                                                currency = "EUR",
                                                date = LocalDate.now(),
                                                description = "EUR Transaction",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(3, result.size)
                        coVerify(exactly = 3) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle transactions with various statuses")
                fun shouldHandleTransactionsWithVariousStatuses() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "txn-completed",
                                                accountId = "acc-1",
                                                amount = 100.0,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "Completed Transaction",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        ),
                                        FinverseTransactionData(
                                                transactionId = "txn-pending",
                                                accountId = "acc-1",
                                                amount = 50.0,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "Pending Transaction",
                                                transactionType = "DEBIT",
                                                status = "PENDING"
                                        ),
                                        FinverseTransactionData(
                                                transactionId = "txn-failed",
                                                accountId = "acc-1",
                                                amount = 25.0,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "Failed Transaction",
                                                transactionType = "DEBIT",
                                                status = "FAILED"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(3, result.size)
                        coVerify(exactly = 3) { transactionRepository.save(any()) }
                }
        }

        @Nested
        @DisplayName("Process Identity Response Tests")
        inner class ProcessIdentityResponseTests {

                @Test
                @DisplayName("Should process identity response with complete data")
                fun shouldProcessIdentityResponseWithCompleteData() = runTest {
                        val identityData =
                                FinverseIdentityData(
                                        names = listOf("John Doe", "Johnny Doe"),
                                        emails = listOf("john.doe@email.com", "johnny@email.com"),
                                        phoneNumbers = listOf("+65 9123 4567", "+65 8765 4321"),
                                        addresses =
                                                listOf(
                                                        FinverseAddressData(
                                                                street = "123 Main Street",
                                                                city = "Singapore",
                                                                state = "Singapore",
                                                                postalCode = "123456",
                                                                country = "Singapore",
                                                                type = "primary"
                                                        )
                                                ),
                                        dateOfBirth = LocalDate.of(1990, 5, 15),
                                        nationalId = "S1234567A",
                                        citizenship = "Singapore",
                                        employmentStatus = "Employed",
                                        occupation = "Software Engineer"
                                )

                        val response = FinverseIdentityResponse(identity = identityData)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNotNull(result)
                        // Note: We can't test the exact User object without mocking the mapper
                        // but we can verify that the response was processed
                }

                @Test
                @DisplayName("Should handle identity response with minimal data")
                fun shouldHandleIdentityResponseWithMinimalData() = runTest {
                        val identityData =
                                FinverseIdentityData(
                                        names = listOf("Jane Doe"),
                                        emails = listOf("jane@email.com"),
                                        phoneNumbers = null,
                                        addresses = null,
                                        dateOfBirth = LocalDate.of(1985, 12, 25),
                                        nationalId = "S9876543B"
                                )

                        val response = FinverseIdentityResponse(identity = identityData)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNotNull(result)
                }

                @Test
                @DisplayName("Should return null when identity field is null")
                fun shouldReturnNullWhenIdentityFieldNull() = runTest {
                        val response = FinverseIdentityResponse(identity = null)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNull(result)
                }

                @Test
                @DisplayName("Should handle identity with multiple addresses")
                fun shouldHandleIdentityWithMultipleAddresses() = runTest {
                        val identityData =
                                FinverseIdentityData(
                                        names = listOf("John Doe"),
                                        emails = listOf("john@email.com"),
                                        addresses =
                                                listOf(
                                                        FinverseAddressData(
                                                                street = "123 Primary Street",
                                                                city = "Singapore",
                                                                type = "primary"
                                                        ),
                                                        FinverseAddressData(
                                                                street = "456 Secondary Street",
                                                                city = "Singapore",
                                                                type = "secondary"
                                                        ),
                                                        FinverseAddressData(
                                                                street = "789 Work Street",
                                                                city = "Singapore",
                                                                type = "work"
                                                        )
                                                ),
                                        dateOfBirth = LocalDate.of(1990, 1, 1),
                                        nationalId = "S1111111A"
                                )

                        val response = FinverseIdentityResponse(identity = identityData)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNotNull(result)
                }

                @Test
                @DisplayName("Should handle identity with multiple names and emails")
                fun shouldHandleIdentityWithMultipleNamesAndEmails() = runTest {
                        val identityData =
                                FinverseIdentityData(
                                        names =
                                                listOf(
                                                        "John Doe",
                                                        "Johnny Doe",
                                                        "J. Doe",
                                                        "Jonathan Doe"
                                                ),
                                        emails =
                                                listOf(
                                                        "john@work.com",
                                                        "johnny@personal.com",
                                                        "j.doe@company.com"
                                                ),
                                        phoneNumbers =
                                                listOf(
                                                        "+65 1111 1111",
                                                        "+65 2222 2222",
                                                        "+65 3333 3333"
                                                ),
                                        dateOfBirth = LocalDate.of(1990, 1, 1),
                                        nationalId = "S1111111A"
                                )

                        val response = FinverseIdentityResponse(identity = identityData)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNotNull(result)
                }
        }

        @Nested
        @DisplayName("Process Institution Response Tests")
        inner class ProcessInstitutionResponseTests {

                @Test
                @DisplayName("Should process institution response successfully")
                fun shouldProcessInstitutionResponseSuccessfully() = runTest {
                        val institution =
                                FinverseInstitution(
                                        institutionId = "dbs-sg",
                                        institutionName = "DBS Bank",
                                        institutionType = "BANK",
                                        countries = listOf("SGP"),
                                        color = "#FF0000",
                                        logoUrl = "https://dbs.com/logo.png",
                                        websiteUrl = "https://dbs.com",
                                        productsSupported = listOf("ACCOUNTS", "TRANSACTIONS"),
                                        isActive = true,
                                        isTest = false,
                                        status = "ACTIVE",
                                        bankCode = "DBS001",
                                        swiftCode = "DBSSSGSG",
                                        routingNumber = "021000021",
                                        institutionCategory = "COMMERCIAL_BANK",
                                        description = "DBS Bank Singapore",
                                        headquartersLocation = "Singapore",
                                        customerSupportPhone = "+65 6111 1111",
                                        customerSupportEmail = "support@dbs.com",
                                        lastUpdated = "2024-01-01T00:00:00Z"
                                )

                        val result =
                                finverseResponseProcessor.processInstitutionResponse(institution)

                        assertNotNull(result)
                        // Note: We can't test the exact Bank object without mocking the mapper
                        // but we can verify that the response was processed
                }

                @Test
                @DisplayName("Should handle institution with minimal fields")
                fun shouldHandleInstitutionWithMinimalFields() = runTest {
                        val institution =
                                FinverseInstitution(
                                        institutionId = "simple-bank",
                                        institutionName = "Simple Bank",
                                        institutionType = "BANK",
                                        countries = listOf("SGP")
                                )

                        val result =
                                finverseResponseProcessor.processInstitutionResponse(institution)

                        assertNotNull(result)
                }

                @Test
                @DisplayName("Should handle institution with multiple countries")
                fun shouldHandleInstitutionWithMultipleCountries() = runTest {
                        val institution =
                                FinverseInstitution(
                                        institutionId = "multi-country-bank",
                                        institutionName = "Multi Country Bank",
                                        institutionType = "BANK",
                                        countries = listOf("SGP", "MYS", "THA", "IDN")
                                )

                        val result =
                                finverseResponseProcessor.processInstitutionResponse(institution)

                        assertNotNull(result)
                }
        }

        @Nested
        @DisplayName("Edge Cases and Error Handling Tests")
        inner class EdgeCasesAndErrorHandlingTests {

                @Test
                @DisplayName("Should handle very large transaction amounts")
                fun shouldHandleVeryLargeTransactionAmounts() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "large-txn",
                                                accountId = "acc-1",
                                                amount = Double.MAX_VALUE,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "Large Transaction",
                                                transactionType = "CREDIT",
                                                status = "COMPLETED"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        coEvery { transactionRepository.save(any()) } returns mockk()

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(1, result.size)
                        coVerify(exactly = 1) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle negative transaction amounts")
                fun shouldHandleNegativeTransactionAmounts() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "negative-txn",
                                                accountId = "acc-1",
                                                amount = -999999.99,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description = "Negative Transaction",
                                                transactionType = "DEBIT",
                                                status = "COMPLETED"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        coEvery { transactionRepository.save(any()) } returns mockk()

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(1, result.size)
                        coVerify(exactly = 1) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle special characters in transaction descriptions")
                fun shouldHandleSpecialCharactersInTransactionDescriptions() = runTest {
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "special-chars-txn",
                                                accountId = "acc-1",
                                                amount = 100.0,
                                                currency = "SGD",
                                                date = LocalDate.now(),
                                                description =
                                                        "Café & Restaurant - 25% off! @#$%^&*()",
                                                transactionType = "DEBIT",
                                                status = "COMPLETED",
                                                merchantName = "Café & Restaurant éñ"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        coEvery { transactionRepository.save(any()) } returns mockk()

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(1, result.size)
                        coVerify(exactly = 1) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle very long account numbers")
                fun shouldHandleVeryLongAccountNumbers() = runTest {
                        val longAccountNumber = "1".repeat(100)
                        val finverseAccountData =
                                listOf(
                                        FinverseAccountData(
                                                accountId = "long-acc-1",
                                                accountNumber = longAccountNumber,
                                                accountName = "Long Account Number",
                                                accountType = "SAVINGS",
                                                balance = 1000.0,
                                                currency = "SGD",
                                                institutionId = "test-bank",
                                                institutionName = "Test Bank"
                                        )
                                )

                        val response = FinverseAccountResponse(accounts = finverseAccountData)

                        val result =
                                finverseResponseProcessor.processAccountsResponseIntoAccountList(
                                        response
                                )

                        assertEquals(1, result.size)
                }

                @Test
                @DisplayName("Should handle future dates in transactions")
                fun shouldHandleFutureDatesInTransactions() = runTest {
                        val futureDate = LocalDate.now().plusYears(1)
                        val transactionData =
                                listOf(
                                        FinverseTransactionData(
                                                transactionId = "future-txn",
                                                accountId = "acc-1",
                                                amount = 100.0,
                                                currency = "SGD",
                                                date = futureDate,
                                                description = "Future Transaction",
                                                transactionType = "CREDIT",
                                                status = "PENDING"
                                        )
                                )

                        val response = FinverseTransactionResponse(transactions = transactionData)

                        coEvery { transactionRepository.save(any()) } returns mockk()

                        val result = finverseResponseProcessor.processTransactionsResponse(response)

                        assertEquals(1, result.size)
                        coVerify(exactly = 1) { transactionRepository.save(any()) }
                }

                @Test
                @DisplayName("Should handle very old dates in identity")
                fun shouldHandleVeryOldDatesInIdentity() = runTest {
                        val veryOldDate = LocalDate.of(1900, 1, 1)
                        val identityData =
                                FinverseIdentityData(
                                        names = listOf("Very Old Person"),
                                        emails = listOf("old@email.com"),
                                        dateOfBirth = veryOldDate,
                                        nationalId = "OLD123456A"
                                )

                        val response = FinverseIdentityResponse(identity = identityData)

                        val result = finverseResponseProcessor.processIdentityResponse(response)

                        assertNotNull(result)
                }
        }

        // Helper methods
        private fun createMockAccount(id: String, name: String, type: String): Account {
                val mockAccount = mockk<Account>()
                every { mockAccount.id } returns id.toLong()
                every { mockAccount.accountName } returns name
                every { mockAccount.accountType } returns AccountType.fromValue(type)
                return mockAccount
        }
}
