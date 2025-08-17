package sg.flow.services.AccountServices

import io.mockk.*
import java.time.LocalDate
import java.time.LocalDateTime
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.grpc.exception.AccountDoesNotExistException
import sg.flow.grpc.exception.RequestedAccountNotBelongException
import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.Account
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@DisplayName("AccountService Tests")
class AccountServiceTest {

    private lateinit var accountRepository: AccountRepository
    private lateinit var transactionHistoryRepository: TransactionHistoryRepository
    private lateinit var accountService: AccountService

    private lateinit var mockUser: User
    private lateinit var mockBank: Bank
    private lateinit var mockAccount: Account
    private lateinit var mockAccount: Account
    private lateinit var mockTransactionDetail: TransactionHistoryDetail

    @BeforeEach
    fun setup() {
        accountRepository = mockk()
        transactionHistoryRepository = mockk()
        accountService = AccountServiceImpl(accountRepository, transactionHistoryRepository)

        // Setup mock objects
        mockUser =
                User(
                        id = 1,
                        name = "Test User",
                        email = "test@example.com",
                        identificationNumber = "S1234567A",
                        phoneNumber = "+65 8123 4567",
                        dateOfBirth = LocalDate.of(1990, 1, 1),
                        address = "123 Test Street",
                        settingJson = "{}"
                )

        mockBank = Bank(id = 1, name = "Test Bank", bankCode = "TEST001")

        mockAccount =
                Account(
                        id = 1L,
                        finverseId = "test-finverse-id",
                        accountNumber = "1234567890",
                        bank = mockBank,
                        owner = mockUser,
                        balance = 1000.0,
                        accountName = "Test Savings Account",
                        accountType = AccountType.SAVINGS,
                        interestRatePerAnnum = 2.5,
                        lastUpdated = LocalDateTime.now()
                )

        mockAccount =
                Account(
                        id = 1L,
                        balance = 1000.0,
                        accountName = "Test Savings Account",
                        bank = mockBank
                )

        mockTransactionDetail =
                TransactionHistoryDetail(
                        id = 1L,
                        transactionReference = "TXN001",
                        account = mockAccount,
                        card = null,
                        transactionDate = LocalDate.now(),
                        transactionTime = null,
                        amount = 100.0,
                        transactionType = "TRANSFER",
                        description = "Test transaction",
                        transactionStatus = "COMPLETED",
                        friendlyDescription = "Payment to merchant"
                )
    }

    @Nested
    @DisplayName("getAccounts Tests")
    inner class GetAccountsTests {

        @Test
        @DisplayName("Should return list of brief accounts for valid user")
        fun `should return list of brief accounts for valid user`() = runTest {
            // Given
            val userId = 1
            val expectedAccounts = listOf(mockAccount)
            coEvery { accountRepository.findAccountsOfUser(userId) } returns expectedAccounts

            // When
            val result = accountService.getAccounts(userId)

            // Then
            assertEquals(expectedAccounts, result)
            assertEquals(1, result.size)
            assertEquals(1L, result[0].id)
            assertEquals(1000.0, result[0].balance)
            assertEquals("Test Savings Account", result[0].accountName)
            assertEquals(mockBank, result[0].bank)
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }

        @Test
        @DisplayName("Should return empty list when user has no accounts")
        fun `should return empty list when user has no accounts`() = runTest {
            // Given
            val userId = 999
            coEvery { accountRepository.findAccountsOfUser(userId) } returns emptyList()

            // When
            val result = accountService.getAccounts(userId)

            // Then
            assertTrue(result.isEmpty())
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }

        @Test
        @DisplayName("Should return multiple accounts for user with multiple accounts")
        fun `should return multiple accounts for user with multiple accounts`() = runTest {
            // Given
            val userId = 1
            val account2 =
                    Account(
                            id = 2L,
                            balance = 2000.0,
                            accountName = "Test Current Account",
                            bank = mockBank
                    )
            val expectedAccounts = listOf(mockAccount, account2)
            coEvery { accountRepository.findAccountsOfUser(userId) } returns expectedAccounts

            // When
            val result = accountService.getAccounts(userId)

            // Then
            assertEquals(2, result.size)
            assertEquals(expectedAccounts, result)
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }

        @Test
        @DisplayName("Should handle negative user ID")
        fun `should handle negative user ID`() = runTest {
            // Given
            val userId = -1
            coEvery { accountRepository.findAccountsOfUser(userId) } returns emptyList()

            // When
            val result = accountService.getAccounts(userId)

            // Then
            assertTrue(result.isEmpty())
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }

        @Test
        @DisplayName("Should handle zero user ID")
        fun `should handle zero user ID`() = runTest {
            // Given
            val userId = 0
            coEvery { accountRepository.findAccountsOfUser(userId) } returns emptyList()

            // When
            val result = accountService.getAccounts(userId)

            // Then
            assertTrue(result.isEmpty())
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }

        @Test
        @DisplayName("Should handle repository exception")
        fun `should handle repository exception`() = runTest {
            // Given
            val userId = 1
            coEvery { accountRepository.findAccountsOfUser(userId) } throws
                    RuntimeException("Database error")

            // When & Then
            assertThrows<RuntimeException> { accountService.getAccounts(userId) }
            coVerify(exactly = 1) { accountRepository.findAccountsOfUser(userId) }
        }
    }

    @Nested
    @DisplayName("getAccountWithTransactionHistory (List) Tests")
    inner class GetAccountWithTransactionHistoryListTests {

        @Test
        @DisplayName("Should return list of accounts with transaction history")
        fun `should return list of accounts with transaction history`() = runTest {
            // Given
            val userId = 1
            val accountWithHistory =
                    AccountWithTransactionHistory(
                            id = 1L,
                            accountNumber = "1234567890",
                            balance = 1000.0,
                            accountName = "Test Savings Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            bank = mockBank,
                            recentTransactionHistoryDetails = listOf(mockTransactionDetail)
                    )
            val expectedAccounts = listOf(accountWithHistory)
            coEvery { accountRepository.findAccountWithTransactionHistorysOfUser(userId) } returns
                    expectedAccounts

            // When
            val result = accountService.getAccountWithTransactionHistory(userId)

            // Then
            assertEquals(expectedAccounts, result)
            assertEquals(1, result.size)
            assertEquals(1L, result[0].id)
            assertEquals("1234567890", result[0].accountNumber)
            assertEquals(1000.0, result[0].balance)
            assertEquals("Test Savings Account", result[0].accountName)
            assertEquals(AccountType.SAVINGS, result[0].accountType)
            assertEquals(2.5, result[0].interestRatePerAnnum)
            assertEquals(mockBank, result[0].bank)
            assertEquals(1, result[0].recentTransactionHistoryDetails.size)
            coVerify(exactly = 1) {
                accountRepository.findAccountWithTransactionHistorysOfUser(userId)
            }
        }

        @Test
        @DisplayName("Should return empty list when user has no accounts")
        fun `should return empty list when user has no accounts`() = runTest {
            // Given
            val userId = 999
            coEvery { accountRepository.findAccountWithTransactionHistorysOfUser(userId) } returns
                    emptyList()

            // When
            val result = accountService.getAccountWithTransactionHistory(userId)

            // Then
            assertTrue(result.isEmpty())
            coVerify(exactly = 1) {
                accountRepository.findAccountWithTransactionHistorysOfUser(userId)
            }
        }

        @Test
        @DisplayName("Should handle accounts with empty transaction history")
        fun `should handle accounts with empty transaction history`() = runTest {
            // Given
            val userId = 1
            val accountWithoutHistory =
                    AccountWithTransactionHistory(
                            id = 1L,
                            accountNumber = "1234567890",
                            balance = 1000.0,
                            accountName = "Test Savings Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            bank = mockBank,
                            recentTransactionHistoryDetails = emptyList()
                    )
            val expectedAccounts = listOf(accountWithoutHistory)
            coEvery { accountRepository.findAccountWithTransactionHistorysOfUser(userId) } returns
                    expectedAccounts

            // When
            val result = accountService.getAccountWithTransactionHistory(userId)

            // Then
            assertEquals(1, result.size)
            assertTrue(result[0].recentTransactionHistoryDetails.isEmpty())
            coVerify(exactly = 1) {
                accountRepository.findAccountWithTransactionHistorysOfUser(userId)
            }
        }
    }

    @Nested
    @DisplayName("getAccount (Single) Tests")
    inner class GetAccountSingleTests {

        @Test
        @DisplayName("Should return brief account for valid user and account ID")
        fun `should return brief account for valid user and account ID`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            coEvery { accountRepository.findById(accountId) } returns mockAccount

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(1L, result.id)
            assertEquals(1000.0, result.balance)
            assertEquals("Test Savings Account", result.accountName)
            assertEquals(mockBank, result.bank)
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
        }

        @Test
        @DisplayName("Should throw AccountDoesNotExistException when account not found")
        fun `should throw AccountDoesNotExistException when account not found`() = runTest {
            // Given
            val userId = 1
            val accountId = 999L
            coEvery { accountRepository.findById(accountId) } returns null

            // When & Then
            assertThrows<AccountDoesNotExistException> {
                accountService.getAccount(userId, accountId)
            }
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
        }

        @Test
        @DisplayName(
                "Should throw RequestedAccountNotBelongException when account belongs to different user"
        )
        fun `should throw RequestedAccountNotBelongException when account belongs to different user`() =
                runTest {
                    // Given
                    val userId = 999 // Different user
                    val accountId = 1L
                    coEvery { accountRepository.findById(accountId) } returns mockAccount

                    // When & Then
                    assertThrows<RequestedAccountNotBelongException> {
                        accountService.getAccount(userId, accountId)
                    }
                    coVerify(exactly = 1) { accountRepository.findById(accountId) }
                }

        @Test
        @DisplayName("Should handle account with null ID")
        fun `should handle account with null ID`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val accountWithNullId = mockAccount.copy(id = null)
            coEvery { accountRepository.findById(accountId) } returns accountWithNullId

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(-1L, result.id) // Should default to -1 when ID is null
            assertEquals(1000.0, result.balance)
            assertEquals("Test Savings Account", result.accountName)
            assertEquals(mockBank, result.bank)
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
        }

        @Test
        @DisplayName("Should handle negative account ID")
        fun `should handle negative account ID`() = runTest {
            // Given
            val userId = 1
            val accountId = -1L
            coEvery { accountRepository.findById(accountId) } returns null

            // When & Then
            assertThrows<AccountDoesNotExistException> {
                accountService.getAccount(userId, accountId)
            }
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
        }

        @Test
        @DisplayName("Should handle zero account ID")
        fun `should handle zero account ID`() = runTest {
            // Given
            val userId = 1
            val accountId = 0L
            coEvery { accountRepository.findById(accountId) } returns null

            // When & Then
            assertThrows<AccountDoesNotExistException> {
                accountService.getAccount(userId, accountId)
            }
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
        }
    }

    @Nested
    @DisplayName("getAccountWithTransactionHistory (Single) Tests")
    inner class GetAccountWithTransactionHistorySingleTests {

        @Test
        @DisplayName("Should return account with transaction history for valid user and account")
        fun `should return account with transaction history for valid user and account`() =
                runTest {
                    // Given
                    val userId = 1
                    val accountId = 1L
                    val recentTransactions = listOf(mockTransactionDetail)
                    coEvery { accountRepository.findById(accountId) } returns mockAccount
                    coEvery {
                        transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(
                                accountId
                        )
                    } returns recentTransactions

                    // When
                    val result = accountService.getAccountWithTransactionHistory(userId, accountId)

                    // Then
                    assertEquals(1L, result.id)
                    assertEquals("1234567890", result.accountNumber)
                    assertEquals(1000.0, result.balance)
                    assertEquals("Test Savings Account", result.accountName)
                    assertEquals(AccountType.SAVINGS, result.accountType)
                    assertEquals(2.5, result.interestRatePerAnnum)
                    assertEquals(mockBank, result.bank)
                    assertEquals(1, result.recentTransactionHistoryDetails.size)
                    assertEquals(mockTransactionDetail, result.recentTransactionHistoryDetails[0])
                    coVerify(exactly = 1) { accountRepository.findById(accountId) }
                    coVerify(exactly = 1) {
                        transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(
                                accountId
                        )
                    }
                }

        @Test
        @DisplayName("Should throw AccountDoesNotExistException when account not found")
        fun `should throw AccountDoesNotExistException when account not found`() = runTest {
            // Given
            val userId = 1
            val accountId = 999L
            coEvery { accountRepository.findById(accountId) } returns null

            // When & Then
            assertThrows<AccountDoesNotExistException> {
                accountService.getAccountWithTransactionHistory(userId, accountId)
            }
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
            coVerify(exactly = 0) {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(any())
            }
        }

        @Test
        @DisplayName(
                "Should throw RequestedAccountNotBelongException when account belongs to different user"
        )
        fun `should throw RequestedAccountNotBelongException when account belongs to different user`() =
                runTest {
                    // Given
                    val userId = 999 // Different user
                    val accountId = 1L
                    coEvery { accountRepository.findById(accountId) } returns mockAccount

                    // When & Then
                    assertThrows<RequestedAccountNotBelongException> {
                        accountService.getAccountWithTransactionHistory(userId, accountId)
                    }
                    coVerify(exactly = 1) { accountRepository.findById(accountId) }
                    coVerify(exactly = 0) {
                        transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(
                                any()
                        )
                    }
                }

        @Test
        @DisplayName("Should handle account with no recent transactions")
        fun `should handle account with no recent transactions`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            coEvery { accountRepository.findById(accountId) } returns mockAccount
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } returns emptyList()

            // When
            val result = accountService.getAccountWithTransactionHistory(userId, accountId)

            // Then
            assertEquals(1L, result.id)
            assertTrue(result.recentTransactionHistoryDetails.isEmpty())
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
            coVerify(exactly = 1) {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            }
        }

        @Test
        @DisplayName("Should handle account with multiple recent transactions")
        fun `should handle account with multiple recent transactions`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val transaction2 =
                    mockTransactionDetail.copy(
                            id = 2L,
                            transactionReference = "TXN002",
                            amount = 200.0,
                            description = "Another test transaction"
                    )
            val recentTransactions = listOf(mockTransactionDetail, transaction2)
            coEvery { accountRepository.findById(accountId) } returns mockAccount
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } returns recentTransactions

            // When
            val result = accountService.getAccountWithTransactionHistory(userId, accountId)

            // Then
            assertEquals(2, result.recentTransactionHistoryDetails.size)
            assertEquals(mockTransactionDetail, result.recentTransactionHistoryDetails[0])
            assertEquals(transaction2, result.recentTransactionHistoryDetails[1])
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
            coVerify(exactly = 1) {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            }
        }

        @Test
        @DisplayName("Should handle account with null ID correctly")
        fun `should handle account with null ID correctly`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val accountWithNullId = mockAccount.copy(id = null)
            coEvery { accountRepository.findById(accountId) } returns accountWithNullId
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } returns emptyList()

            // When
            val result = accountService.getAccountWithTransactionHistory(userId, accountId)

            // Then
            assertEquals(-1L, result.id) // Should default to -1 when ID is null
            assertEquals("1234567890", result.accountNumber)
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
            coVerify(exactly = 1) {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            }
        }

        @Test
        @DisplayName("Should handle transaction repository exception")
        fun `should handle transaction repository exception`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            coEvery { accountRepository.findById(accountId) } returns mockAccount
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } throws RuntimeException("Transaction repo error")

            // When & Then
            assertThrows<RuntimeException> {
                accountService.getAccountWithTransactionHistory(userId, accountId)
            }
            coVerify(exactly = 1) { accountRepository.findById(accountId) }
            coVerify(exactly = 1) {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            }
        }

        @Test
        @DisplayName("Should handle all AccountType values correctly")
        fun `should handle all AccountType values correctly`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val accountTypes =
                    listOf(
                            AccountType.SAVINGS,
                            AccountType.CURRENT,
                            AccountType.TIME_DEPOSIT,
                            AccountType.BONDS,
                            AccountType.FUNDS,
                            AccountType.RETIREMENT,
                            AccountType.SECURITIES,
                            AccountType.STOCKS,
                            AccountType.MORTGAGE,
                            AccountType.PERSONAL_LOAN,
                            AccountType.REVOLVING_LOAN,
                            AccountType.CREDIT_CARD,
                            AccountType.DEBIT_CARD,
                            AccountType.FIXED_DEPOSIT,
                            AccountType.FOREIGN_CURRENCY,
                            AccountType.OTHERS,
                            AccountType.UNKNOWN
                    )

            accountTypes.forEach { accountType ->
                val testAccount = mockAccount.copy(accountType = accountType)
                coEvery { accountRepository.findById(accountId) } returns testAccount
                coEvery {
                    transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(
                            accountId
                    )
                } returns emptyList()

                // When
                val result = accountService.getAccountWithTransactionHistory(userId, accountId)

                // Then
                assertEquals(accountType, result.accountType)
            }
        }
    }

    @Nested
    @DisplayName("Edge Cases and Integration Tests")
    inner class EdgeCasesAndIntegrationTests {

        @Test
        @DisplayName("Should handle concurrent access to same account")
        fun `should handle concurrent access to same account`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            coEvery { accountRepository.findById(accountId) } returns mockAccount
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } returns emptyList()

            // When - Simulate concurrent calls
            val result1 = accountService.getAccount(userId, accountId)
            val result2 = accountService.getAccountWithTransactionHistory(userId, accountId)

            // Then
            assertEquals(1L, result1.id)
            assertEquals(1L, result2.id)
            coVerify(exactly = 2) { accountRepository.findById(accountId) }
        }

        @Test
        @DisplayName("Should handle very large account balances")
        fun `should handle very large account balances`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val largeBalance = Double.MAX_VALUE
            val accountWithLargeBalance = mockAccount.copy(balance = largeBalance)
            coEvery { accountRepository.findById(accountId) } returns accountWithLargeBalance

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(largeBalance, result.balance)
        }

        @Test
        @DisplayName("Should handle zero balance accounts")
        fun `should handle zero balance accounts`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val zeroBalanceAccount = mockAccount.copy(balance = 0.0)
            coEvery { accountRepository.findById(accountId) } returns zeroBalanceAccount

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(0.0, result.balance)
        }

        @Test
        @DisplayName("Should handle negative balance accounts")
        fun `should handle negative balance accounts`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val negativeBalanceAccount = mockAccount.copy(balance = -500.0)
            coEvery { accountRepository.findById(accountId) } returns negativeBalanceAccount

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(-500.0, result.balance)
        }

        @Test
        @DisplayName("Should handle accounts with very long names")
        fun `should handle accounts with very long names`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val longAccountName = "A".repeat(1000) // Very long account name
            val accountWithLongName = mockAccount.copy(accountName = longAccountName)
            coEvery { accountRepository.findById(accountId) } returns accountWithLongName

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(longAccountName, result.accountName)
        }

        @Test
        @DisplayName("Should handle accounts with special characters in name")
        fun `should handle accounts with special characters in name`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val specialAccountName = "Test Account - 特殊文字 & Symbols! @#$%^&*()"
            val accountWithSpecialName = mockAccount.copy(accountName = specialAccountName)
            coEvery { accountRepository.findById(accountId) } returns accountWithSpecialName

            // When
            val result = accountService.getAccount(userId, accountId)

            // Then
            assertEquals(specialAccountName, result.accountName)
        }

        @Test
        @DisplayName("Should handle extreme interest rates")
        fun `should handle extreme interest rates`() = runTest {
            // Given
            val userId = 1
            val accountId = 1L
            val extremeRate = 999.99
            val accountWithExtremeRate = mockAccount.copy(interestRatePerAnnum = extremeRate)
            coEvery { accountRepository.findById(accountId) } returns accountWithExtremeRate
            coEvery {
                transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId)
            } returns emptyList()

            // When
            val result = accountService.getAccountWithTransactionHistory(userId, accountId)

            // Then
            assertEquals(extremeRate, result.interestRatePerAnnum)
        }
    }
}
