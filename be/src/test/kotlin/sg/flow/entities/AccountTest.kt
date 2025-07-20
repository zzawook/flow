package sg.flow.entities

import jakarta.validation.Validation
import jakarta.validation.Validator
import java.time.LocalDate
import java.time.LocalDateTime
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.entities.utils.AccountType

@DisplayName("Account Entity Tests")
class AccountTest {

    private lateinit var validator: Validator
    private lateinit var testBank: Bank
    private lateinit var testUser: User

    @BeforeEach
    fun setup() {
        val factory = Validation.buildDefaultValidatorFactory()
        validator = factory.validator

        testBank = Bank(id = 1, name = "Test Bank", bankCode = "TB001")

        testUser =
                User(
                        id = 1,
                        name = "Test User",
                        email = "test@example.com",
                        identificationNumber = "S1234567A",
                        phoneNumber = "+65-91234567",
                        dateOfBirth = LocalDate.of(1990, 5, 15),
                        address = "123 Test Street"
                )
    }

    @Nested
    @DisplayName("Valid Account Creation")
    inner class ValidAccountCreation {

        @Test
        @DisplayName("Should create account with all valid fields")
        fun shouldCreateAccountWithValidFields() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "finverse_123",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.50,
                            accountName = "My Savings Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            lastUpdated = LocalDateTime.of(2023, 12, 1, 10, 30, 0)
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())

            assertEquals(1L, account.id)
            assertEquals("finverse_123", account.finverseId)
            assertEquals("123456789", account.accountNumber)
            assertEquals(testBank, account.bank)
            assertEquals(testUser, account.owner)
            assertEquals(1000.50, account.balance, 0.001)
            assertEquals("My Savings Account", account.accountName)
            assertEquals(AccountType.SAVINGS, account.accountType)
            assertEquals(2.5, account.interestRatePerAnnum, 0.001)
        }

        @Test
        @DisplayName("Should create account with null ID")
        fun shouldCreateAccountWithNullId() {
            val account =
                    Account(
                            id = null,
                            finverseId = null,
                            accountNumber = "987654321",
                            bank = testBank,
                            owner = testUser,
                            balance = 500.0,
                            accountName = "Current Account",
                            accountType = AccountType.CURRENT,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertNull(account.id)
            assertNull(account.finverseId)
        }

        @Test
        @DisplayName("Should create account with null finverseId")
        fun shouldCreateAccountWithNullFinverseId() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = null,
                            accountNumber = "555666777",
                            bank = testBank,
                            owner = testUser,
                            balance = 0.0,
                            accountName = "New Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertNull(account.finverseId)
        }

        @Test
        @DisplayName("Should create account with zero balance")
        fun shouldCreateAccountWithZeroBalance() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "000000000",
                            bank = testBank,
                            owner = testUser,
                            balance = 0.0,
                            accountName = "Zero Balance Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(0.0, account.balance, 0.001)
        }

        @Test
        @DisplayName("Should create account with default interest rate")
        fun shouldCreateAccountWithDefaultInterestRate() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "111222333",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Default Interest Account",
                            accountType = AccountType.CURRENT,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(0.0, account.interestRatePerAnnum, 0.001)
        }
    }

    @Nested
    @DisplayName("Account Number Validation")
    inner class AccountNumberValidation {

        @Test
        @DisplayName("Should reject account with empty account number")
        fun shouldRejectEmptyAccountNumber() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "accountNumber" })
        }

        @Test
        @DisplayName("Should reject account with blank account number")
        fun shouldRejectBlankAccountNumber() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "   ",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "accountNumber" })
        }

        @Test
        @DisplayName("Should accept various account number formats")
        fun shouldAcceptVariousAccountNumberFormats() {
            val validAccountNumbers =
                    listOf(
                            "123456789",
                            "0001234567890123",
                            "SG-123-456-789",
                            "ACC_001_2023",
                            "1234.5678.9012",
                            "A1B2C3D4E5F6",
                            "000000001",
                            "999999999999999999"
                    )

            validAccountNumbers.forEach { accountNumber ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = accountNumber,
                                bank = testBank,
                                owner = testUser,
                                balance = 1000.0,
                                accountName = "Test Account",
                                accountType = AccountType.SAVINGS,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Account number $accountNumber should be valid")
            }
        }

        @Test
        @DisplayName("Should allow updating account number")
        fun shouldAllowUpdatingAccountNumber() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            // Test that accountNumber is var (mutable)
            account.accountNumber = "987654321"
            assertEquals("987654321", account.accountNumber)
        }
    }

    @Nested
    @DisplayName("Account Name Validation")
    inner class AccountNameValidation {

        @Test
        @DisplayName("Should reject account with empty account name")
        fun shouldRejectEmptyAccountName() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "accountName" })
        }

        @Test
        @DisplayName("Should accept various account name formats")
        fun shouldAcceptVariousAccountNameFormats() {
            val validAccountNames =
                    listOf(
                            "Savings Account",
                            "My Primary Checking",
                            "Emergency Fund 2023",
                            "Joint Account - Spouse",
                            "Business Operating Account",
                            "USD$ Foreign Currency",
                            "高息储蓄账户",
                            "Compte d'épargne",
                            "Account #1",
                            "A",
                            "Very Long Account Name That Contains Many Words And Characters To Test Length Limits"
                    )

            validAccountNames.forEach { accountName ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = 1000.0,
                                accountName = accountName,
                                accountType = AccountType.SAVINGS,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Account name '$accountName' should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Balance Validation")
    inner class BalanceValidation {

        @Test
        @DisplayName("Should accept positive balances")
        fun shouldAcceptPositiveBalances() {
            val positiveBalances = listOf(0.01, 1.0, 100.50, 1000000.99, Double.MAX_VALUE)

            positiveBalances.forEach { balance ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = balance,
                                accountName = "Test Account",
                                accountType = AccountType.SAVINGS,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Balance $balance should be valid")
            }
        }

        @Test
        @DisplayName("Should accept negative balances")
        fun shouldAcceptNegativeBalances() {
            val negativeBalances =
                    listOf(-0.01, -100.50, -1000000.99, Double.MIN_VALUE, -Double.MAX_VALUE)

            negativeBalances.forEach { balance ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = balance,
                                accountName = "Test Account",
                                accountType = AccountType.CURRENT,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Negative balance $balance should be valid")
            }
        }

        @Test
        @DisplayName("Should handle very small decimal amounts")
        fun shouldHandleVerySmallDecimalAmounts() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 0.001,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(0.001, account.balance, 0.0001)
        }

        @Test
        @DisplayName("Should handle currency precision correctly")
        fun shouldHandleCurrencyPrecisionCorrectly() {
            val preciseAmounts = listOf(123.45, 999.99, 0.12, 1234567.89)

            preciseAmounts.forEach { amount ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = amount,
                                accountName = "Test Account",
                                accountType = AccountType.SAVINGS,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty())
                assertEquals(amount, account.balance, 0.001)
            }
        }
    }

    @Nested
    @DisplayName("Interest Rate Validation")
    inner class InterestRateValidation {

        @Test
        @DisplayName("Should accept various interest rates")
        fun shouldAcceptVariousInterestRates() {
            val validRates = listOf(0.0, 0.5, 2.5, 5.0, 10.0, 25.0, 100.0)

            validRates.forEach { rate ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = 1000.0,
                                accountName = "Test Account",
                                accountType = AccountType.SAVINGS,
                                interestRatePerAnnum = rate,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Interest rate $rate should be valid")
                assertEquals(rate, account.interestRatePerAnnum, 0.001)
            }
        }

        @Test
        @DisplayName("Should accept negative interest rates")
        fun shouldAcceptNegativeInterestRates() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = -0.5,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(-0.5, account.interestRatePerAnnum, 0.001)
        }

        @Test
        @DisplayName("Should handle very precise interest rates")
        fun shouldHandleVeryPreciseInterestRates() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.375,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(2.375, account.interestRatePerAnnum, 0.001)
        }
    }

    @Nested
    @DisplayName("Account Type Validation")
    inner class AccountTypeValidation {

        @Test
        @DisplayName("Should accept all account types")
        fun shouldAcceptAllAccountTypes() {
            AccountType.values().forEach { accountType ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = 1000.0,
                                accountName = "Test Account",
                                accountType = accountType,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Account type $accountType should be valid")
                assertEquals(accountType, account.accountType)
            }
        }
    }

    @Nested
    @DisplayName("Date and Time Validation")
    inner class DateAndTimeValidation {

        @Test
        @DisplayName("Should accept past dates")
        fun shouldAcceptPastDates() {
            val pastDate = LocalDateTime.of(2020, 1, 1, 0, 0, 0)
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = pastDate
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(pastDate, account.lastUpdated)
        }

        @Test
        @DisplayName("Should accept current date and time")
        fun shouldAcceptCurrentDateTime() {
            val currentDate = LocalDateTime.now()
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = currentDate
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept future dates")
        fun shouldAcceptFutureDates() {
            val futureDate = LocalDateTime.of(2030, 12, 31, 23, 59, 59)
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = futureDate
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(futureDate, account.lastUpdated)
        }

        @Test
        @DisplayName("Should handle precise time components")
        fun shouldHandlePreciseTimeComponents() {
            val preciseDate = LocalDateTime.of(2023, 6, 15, 14, 30, 45, 123456789)
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = preciseDate
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(preciseDate, account.lastUpdated)
        }
    }

    @Nested
    @DisplayName("Relationship Validation")
    inner class RelationshipValidation {

        @Test
        @DisplayName("Should require valid bank")
        fun shouldRequireValidBank() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(testBank, account.bank)
        }

        @Test
        @DisplayName("Should require valid owner")
        fun shouldRequireValidOwner() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(testUser, account.owner)
        }

        @Test
        @DisplayName("Should handle different bank instances")
        fun shouldHandleDifferentBankInstances() {
            val anotherBank = Bank(id = 2, name = "Another Bank", bankCode = "AB002")

            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = anotherBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(anotherBank, account.bank)
        }

        @Test
        @DisplayName("Should handle different user instances")
        fun shouldHandleDifferentUserInstances() {
            val anotherUser =
                    User(
                            id = 2,
                            name = "Another User",
                            email = "another@example.com",
                            identificationNumber = "S9876543Z",
                            phoneNumber = "+65-98765432",
                            dateOfBirth = LocalDate.of(1985, 10, 20),
                            address = "456 Another Street"
                    )

            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = anotherUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals(anotherUser, account.owner)
        }
    }

    @Nested
    @DisplayName("Finverse ID Validation")
    inner class FinverseIdValidation {

        @Test
        @DisplayName("Should accept various finverse ID formats")
        fun shouldAcceptVariousFinverseIdFormats() {
            val validFinverseIds =
                    listOf(
                            "finverse_123",
                            "FV-456-789",
                            "uuid-123e4567-e89b-12d3-a456-426614174000",
                            "simple_id",
                            "ID123456789",
                            "very-long-finverse-identifier-with-many-characters",
                            "123",
                            "A"
                    )

            validFinverseIds.forEach { finverseId ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = finverseId,
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = 1000.0,
                                accountName = "Test Account",
                                accountType = AccountType.SAVINGS,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Finverse ID '$finverseId' should be valid")
                assertEquals(finverseId, account.finverseId)
            }
        }

        @Test
        @DisplayName("Should accept empty finverse ID")
        fun shouldAcceptEmptyFinverseId() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.now()
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
            assertEquals("", account.finverseId)
        }
    }

    @Nested
    @DisplayName("Data Class Behavior")
    inner class DataClassBehavior {

        @Test
        @DisplayName("Should implement equals correctly")
        fun shouldImplementEqualsCorrectly() {
            val account1 =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            val account2 =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            val account3 =
                    Account(
                            id = 2L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            interestRatePerAnnum = 2.5,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            assertEquals(account1, account2)
            assertNotEquals(account1, account3)
        }

        @Test
        @DisplayName("Should implement hashCode correctly")
        fun shouldImplementHashCodeCorrectly() {
            val account1 =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            val account2 =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            assertEquals(account1.hashCode(), account2.hashCode())
        }

        @Test
        @DisplayName("Should implement toString correctly")
        fun shouldImplementToStringCorrectly() {
            val account =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Test Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            val toString = account.toString()
            assertTrue(toString.contains("Account"))
            assertTrue(toString.contains("123456789"))
            assertTrue(toString.contains("Test Account"))
        }

        @Test
        @DisplayName("Should support copy with modifications")
        fun shouldSupportCopyWithModifications() {
            val originalAccount =
                    Account(
                            id = 1L,
                            finverseId = "test",
                            accountNumber = "123456789",
                            bank = testBank,
                            owner = testUser,
                            balance = 1000.0,
                            accountName = "Original Account",
                            accountType = AccountType.SAVINGS,
                            lastUpdated = LocalDateTime.of(2023, 1, 1, 12, 0, 0)
                    )

            val copiedAccount =
                    originalAccount.copy(accountName = "Modified Account", balance = 2000.0)

            assertEquals(1L, copiedAccount.id)
            assertEquals("test", copiedAccount.finverseId)
            assertEquals("123456789", copiedAccount.accountNumber)
            assertEquals(testBank, copiedAccount.bank)
            assertEquals(testUser, copiedAccount.owner)
            assertEquals(2000.0, copiedAccount.balance, 0.001)
            assertEquals("Modified Account", copiedAccount.accountName)
            assertEquals(AccountType.SAVINGS, copiedAccount.accountType)
            assertEquals(0.0, copiedAccount.interestRatePerAnnum, 0.001)
            assertEquals(LocalDateTime.of(2023, 1, 1, 12, 0, 0), copiedAccount.lastUpdated)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle minimum valid data")
        fun shouldHandleMinimumValidData() {
            val account =
                    Account(
                            id = null,
                            finverseId = null,
                            accountNumber = "1",
                            bank = testBank,
                            owner = testUser,
                            balance = Double.MIN_VALUE,
                            accountName = "A",
                            accountType = AccountType.OTHERS,
                            interestRatePerAnnum = Double.MIN_VALUE,
                            lastUpdated = LocalDateTime.MIN
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle maximum reasonable values")
        fun shouldHandleMaximumReasonableValues() {
            val account =
                    Account(
                            id = Long.MAX_VALUE,
                            finverseId = "A".repeat(1000),
                            accountNumber = "9".repeat(50),
                            bank = testBank,
                            owner = testUser,
                            balance = Double.MAX_VALUE,
                            accountName = "Maximum Account Name ".repeat(100),
                            accountType = AccountType.UNKNOWN,
                            interestRatePerAnnum = Double.MAX_VALUE,
                            lastUpdated = LocalDateTime.MAX
                    )

            val violations = validator.validate(account)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle special floating point values")
        fun shouldHandleSpecialFloatingPointValues() {
            val specialValues =
                    listOf(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NaN)

            specialValues.forEach { value ->
                val account =
                        Account(
                                id = 1L,
                                finverseId = "test",
                                accountNumber = "123456789",
                                bank = testBank,
                                owner = testUser,
                                balance = value,
                                accountName = "Special Value Account",
                                accountType = AccountType.SAVINGS,
                                interestRatePerAnnum = value,
                                lastUpdated = LocalDateTime.now()
                        )

                val violations = validator.validate(account)
                assertTrue(violations.isEmpty(), "Special value $value should be handled")
            }
        }
    }
}
