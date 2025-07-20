package sg.flow.entities

import jakarta.validation.Validation
import jakarta.validation.Validator
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.entities.utils.AccountType
import sg.flow.entities.utils.CardType
import sg.flow.models.card.BriefCard

@DisplayName("TransactionHistory Entity Tests")
class TransactionHistoryTest {

    private lateinit var validator: Validator
    private lateinit var testUser: User
    private lateinit var testBank: Bank
    private lateinit var testAccount: Account
    private lateinit var testBriefCard: BriefCard

    @BeforeEach
    fun setup() {
        val factory = Validation.buildDefaultValidatorFactory()
        validator = factory.validator

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

        testBank = Bank(id = 1, name = "Test Bank", bankCode = "TB001")

        testAccount =
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

        testBriefCard =
                BriefCard(id = 1L, cardNumber = "4111111111111111", cardType = CardType.CREDIT)
    }

    @Nested
    @DisplayName("Valid TransactionHistory Creation")
    inner class ValidTransactionHistoryCreation {

        @Test
        @DisplayName("Should create transaction with all valid fields")
        fun shouldCreateTransactionWithValidFields() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123456789",
                            account = testAccount,
                            card = testBriefCard,
                            transactionDate = LocalDate.of(2023, 12, 1),
                            transactionTime = LocalTime.of(14, 30, 45),
                            amount = 150.75,
                            transactionType = "DEBIT",
                            description = "Coffee purchase at Starbucks",
                            transactionStatus = "COMPLETED",
                            friendlyDescription = "Coffee at Starbucks"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())

            assertEquals(1L, transaction.id)
            assertEquals("TXN123456789", transaction.transactionReference)
            assertEquals(testAccount, transaction.account)
            assertEquals(testBriefCard, transaction.card)
            assertEquals(LocalDate.of(2023, 12, 1), transaction.transactionDate)
            assertEquals(LocalTime.of(14, 30, 45), transaction.transactionTime)
            assertEquals(150.75, transaction.amount, 0.001)
            assertEquals("DEBIT", transaction.transactionType)
            assertEquals("Coffee purchase at Starbucks", transaction.description)
            assertEquals("COMPLETED", transaction.transactionStatus)
            assertEquals("Coffee at Starbucks", transaction.friendlyDescription)
        }

        @Test
        @DisplayName("Should create transaction with null ID")
        fun shouldCreateTransactionWithNullId() {
            val transaction =
                    TransactionHistory(
                            id = null,
                            transactionReference = "TXN987654321",
                            account = testAccount,
                            transactionDate = LocalDate.now(),
                            amount = 50.0,
                            transactionType = "CREDIT",
                            transactionStatus = "PENDING"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertNull(transaction.id)
        }

        @Test
        @DisplayName("Should create transaction with nullable fields set to null")
        fun shouldCreateTransactionWithNullableFieldsSetToNull() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN111222333",
                            account = null,
                            card = null,
                            transactionDate = LocalDate.now(),
                            transactionTime = null,
                            amount = 100.0,
                            transactionType = "TRANSFER",
                            description = "",
                            transactionStatus = "COMPLETED",
                            friendlyDescription = ""
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertNull(transaction.account)
            assertNull(transaction.card)
            assertNull(transaction.transactionTime)
            assertEquals("", transaction.description)
            assertEquals("", transaction.friendlyDescription)
        }

        @Test
        @DisplayName("Should create transaction with default values")
        fun shouldCreateTransactionWithDefaultValues() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN444555666",
                            transactionDate = LocalDate.now(),
                            amount = 75.0,
                            transactionType = "PAYMENT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())

            // Check default values
            assertNull(transaction.account)
            assertNull(transaction.card)
            assertNull(transaction.transactionTime)
            assertEquals("", transaction.description)
            assertEquals("", transaction.friendlyDescription)
        }
    }

    @Nested
    @DisplayName("Transaction Reference Validation")
    inner class TransactionReferenceValidation {

        @Test
        @DisplayName("Should reject transaction with empty reference")
        fun shouldRejectEmptyReference() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "transactionReference" })
        }

        @Test
        @DisplayName("Should reject transaction with blank reference")
        fun shouldRejectBlankReference() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "   ",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "transactionReference" })
        }

        @Test
        @DisplayName("Should accept various transaction reference formats")
        fun shouldAcceptVariousTransactionReferenceFormats() {
            val validReferences =
                    listOf(
                            "TXN123456789",
                            "REF-2023-12-01-001",
                            "PAYMENT_12345",
                            "TRF/001/2023",
                            "DEBIT.CARD.123456",
                            "ONLINE_BANKING_TXN_789",
                            "ATM_WITHDRAWAL_456",
                            "1234567890",
                            "ABC123XYZ789",
                            "uuid-123e4567-e89b-12d3-a456-426614174000",
                            "简单交易参考号",
                            "Référence de transaction",
                            "取引参照番号"
                    )

            validReferences.forEach { reference ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = reference,
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(
                        violations.isEmpty(),
                        "Transaction reference '$reference' should be valid"
                )
                assertEquals(reference, transaction.transactionReference)
            }
        }

        @Test
        @DisplayName("Should accept very long transaction references")
        fun shouldAcceptVeryLongTransactionReferences() {
            val longReference = "TXN_" + "A".repeat(1000)
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = longReference,
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(longReference, transaction.transactionReference)
        }

        @Test
        @DisplayName("Should accept single character transaction reference")
        fun shouldAcceptSingleCharacterTransactionReference() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "A",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("Amount Validation")
    inner class AmountValidation {

        @Test
        @DisplayName("Should accept positive amounts")
        fun shouldAcceptPositiveAmounts() {
            val positiveAmounts = listOf(0.01, 1.0, 10.50, 100.99, 1000000.0, Double.MAX_VALUE)

            positiveAmounts.forEach { amount ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = amount,
                                transactionType = "CREDIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Amount $amount should be valid")
                assertEquals(amount, transaction.amount, 0.001)
            }
        }

        @Test
        @DisplayName("Should accept negative amounts")
        fun shouldAcceptNegativeAmounts() {
            val negativeAmounts =
                    listOf(-0.01, -10.50, -100.99, -1000000.0, -Double.MAX_VALUE, Double.MIN_VALUE)

            negativeAmounts.forEach { amount ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = amount,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Negative amount $amount should be valid")
                assertEquals(amount, transaction.amount, 0.001)
            }
        }

        @Test
        @DisplayName("Should accept zero amount")
        fun shouldAcceptZeroAmount() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 0.0,
                            transactionType = "ADJUSTMENT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(0.0, transaction.amount, 0.001)
        }

        @Test
        @DisplayName("Should handle currency precision correctly")
        fun shouldHandleCurrencyPrecisionCorrectly() {
            val preciseAmounts = listOf(123.45, 999.99, 0.12, 1234567.89, 0.001, 0.0001)

            preciseAmounts.forEach { amount ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = amount,
                                transactionType = "PAYMENT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty())
                assertEquals(amount, transaction.amount, 0.0001)
            }
        }

        @Test
        @DisplayName("Should handle special floating point values")
        fun shouldHandleSpecialFloatingPointValues() {
            val specialAmounts =
                    listOf(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NaN)

            specialAmounts.forEach { amount ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = amount,
                                transactionType = "SPECIAL",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Special amount $amount should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Date and Time Validation")
    inner class DateAndTimeValidation {

        @Test
        @DisplayName("Should accept past transaction dates")
        fun shouldAcceptPastTransactionDates() {
            val pastDates =
                    listOf(
                            LocalDate.of(2020, 1, 1),
                            LocalDate.of(2022, 6, 15),
                            LocalDate.of(2023, 11, 30),
                            LocalDate.now().minusDays(1)
                    )

            pastDates.forEach { date ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = date,
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Past date $date should be valid")
                assertEquals(date, transaction.transactionDate)
            }
        }

        @Test
        @DisplayName("Should accept current transaction date")
        fun shouldAcceptCurrentTransactionDate() {
            val currentDate = LocalDate.now()
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = currentDate,
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(currentDate, transaction.transactionDate)
        }

        @Test
        @DisplayName("Should accept future transaction dates")
        fun shouldAcceptFutureTransactionDates() {
            val futureDate = LocalDate.now().plusDays(30)
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = futureDate,
                            amount = 100.0,
                            transactionType = "SCHEDULED",
                            transactionStatus = "PENDING"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(futureDate, transaction.transactionDate)
        }

        @Test
        @DisplayName("Should accept various time formats")
        fun shouldAcceptVariousTimeFormats() {
            val validTimes =
                    listOf(
                            LocalTime.of(0, 0, 0),
                            LocalTime.of(12, 0, 0),
                            LocalTime.of(23, 59, 59),
                            LocalTime.of(14, 30, 45),
                            LocalTime.of(9, 15, 30, 123456789),
                            LocalTime.MIDNIGHT,
                            LocalTime.NOON
                    )

            validTimes.forEach { time ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                transactionTime = time,
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Time $time should be valid")
                assertEquals(time, transaction.transactionTime)
            }
        }

        @Test
        @DisplayName("Should accept null transaction time")
        fun shouldAcceptNullTransactionTime() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            transactionTime = null,
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertNull(transaction.transactionTime)
        }

        @Test
        @DisplayName("Should handle extreme date values")
        fun shouldHandleExtremeDateValues() {
            val extremeDates =
                    listOf(
                            LocalDate.MIN,
                            LocalDate.MAX,
                            LocalDate.of(1, 1, 1),
                            LocalDate.of(9999, 12, 31)
                    )

            extremeDates.forEach { date ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = date,
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Extreme date $date should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Transaction Type Validation")
    inner class TransactionTypeValidation {

        @Test
        @DisplayName("Should reject transaction with empty type")
        fun shouldRejectEmptyType() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "transactionType" })
        }

        @Test
        @DisplayName("Should accept various transaction types")
        fun shouldAcceptVariousTransactionTypes() {
            val validTypes =
                    listOf(
                            "DEBIT",
                            "CREDIT",
                            "TRANSFER",
                            "PAYMENT",
                            "WITHDRAWAL",
                            "DEPOSIT",
                            "REFUND",
                            "ADJUSTMENT",
                            "FEE",
                            "INTEREST",
                            "DIVIDEND",
                            "CHARGE",
                            "REVERSAL",
                            "AUTHORIZATION",
                            "PURCHASE",
                            "CASH_ADVANCE",
                            "STANDING_ORDER",
                            "DIRECT_DEBIT",
                            "CARD_PAYMENT",
                            "ATM_WITHDRAWAL",
                            "ONLINE_TRANSFER",
                            "MOBILE_PAYMENT",
                            "QR_PAYMENT",
                            "CONTACTLESS"
                    )

            validTypes.forEach { type ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = type,
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Transaction type '$type' should be valid")
                assertEquals(type, transaction.transactionType)
            }
        }

        @Test
        @DisplayName("Should accept custom transaction types")
        fun shouldAcceptCustomTransactionTypes() {
            val customTypes =
                    listOf(
                            "CUSTOM_TYPE_1",
                            "Special Payment",
                            "转账",
                            "Paiement",
                            "支払い",
                            "TYPE-WITH-DASHES",
                            "Type.With.Dots",
                            "TYPE_123",
                            "Type (with parentheses)"
                    )

            customTypes.forEach { type ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = type,
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Custom transaction type '$type' should be valid")
            }
        }

        @Test
        @DisplayName("Should accept single character transaction type")
        fun shouldAcceptSingleCharacterTransactionType() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "D",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("Transaction Status Validation")
    inner class TransactionStatusValidation {

        @Test
        @DisplayName("Should reject transaction with empty status")
        fun shouldRejectEmptyStatus() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = ""
                    )

            val violations = validator.validate(transaction)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "transactionStatus" })
        }

        @Test
        @DisplayName("Should accept various transaction statuses")
        fun shouldAcceptVariousTransactionStatuses() {
            val validStatuses =
                    listOf(
                            "COMPLETED",
                            "PENDING",
                            "FAILED",
                            "CANCELLED",
                            "REVERSED",
                            "AUTHORIZED",
                            "DECLINED",
                            "PROCESSING",
                            "SETTLED",
                            "REFUNDED",
                            "DISPUTED",
                            "CHARGEBACK",
                            "TIMEOUT",
                            "EXPIRED",
                            "VOIDED",
                            "ON_HOLD",
                            "APPROVED",
                            "REJECTED"
                    )

            validStatuses.forEach { status ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = status
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Transaction status '$status' should be valid")
                assertEquals(status, transaction.transactionStatus)
            }
        }

        @Test
        @DisplayName("Should accept custom transaction statuses")
        fun shouldAcceptCustomTransactionStatuses() {
            val customStatuses =
                    listOf(
                            "CUSTOM_STATUS_1",
                            "Waiting for approval",
                            "处理中",
                            "En cours",
                            "処理中",
                            "STATUS-WITH-DASHES",
                            "Status.With.Dots",
                            "STATUS_123",
                            "Status (with details)"
                    )

            customStatuses.forEach { status ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = status
                        )

                val violations = validator.validate(transaction)
                assertTrue(
                        violations.isEmpty(),
                        "Custom transaction status '$status' should be valid"
                )
            }
        }
    }

    @Nested
    @DisplayName("Description Validation")
    inner class DescriptionValidation {

        @Test
        @DisplayName("Should accept empty description")
        fun shouldAcceptEmptyDescription() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            description = "",
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals("", transaction.description)
        }

        @Test
        @DisplayName("Should accept various description formats")
        fun shouldAcceptVariousDescriptionFormats() {
            val validDescriptions =
                    listOf(
                            "Purchase at Starbucks",
                            "ATM Withdrawal - Main Street Branch",
                            "Online Transfer to John Doe",
                            "Direct Debit - Electric Bill",
                            "Salary Payment from ABC Corp",
                            "Refund for cancelled order #12345",
                            "Interest payment on savings account",
                            "Card payment at Amazon.com",
                            "Mobile payment via PayLah!",
                            "QR code payment at hawker center",
                            "Cash deposit at branch",
                            "Standing order to mortgage account",
                            "Foreign exchange transaction",
                            "Investment purchase - Tech Stock",
                            "Insurance premium payment"
                    )

            validDescriptions.forEach { description ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                description = description,
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Description '$description' should be valid")
                assertEquals(description, transaction.description)
            }
        }

        @Test
        @DisplayName("Should accept multiline descriptions")
        fun shouldAcceptMultilineDescriptions() {
            val multilineDescription =
                    """
                Purchase at Starbucks
                Location: Marina Bay Sands
                Card ending in 1111
                Merchant ID: 123456789
            """.trimIndent()

            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            description = multilineDescription,
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(multilineDescription, transaction.description)
        }

        @Test
        @DisplayName("Should accept Unicode descriptions")
        fun shouldAcceptUnicodeDescriptions() {
            val unicodeDescriptions =
                    listOf(
                            "咖啡店购物 ☕",
                            "Achat au café ☕",
                            "コーヒーショップでの購入 ☕",
                            "مشتريات من المقهى ☕",
                            "Compra en cafetería ☕",
                            "Покупка в кафе ☕"
                    )

            unicodeDescriptions.forEach { description ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                description = description,
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(
                        violations.isEmpty(),
                        "Unicode description '$description' should be valid"
                )
            }
        }

        @Test
        @DisplayName("Should accept very long descriptions")
        fun shouldAcceptVeryLongDescriptions() {
            val longDescription = "Purchase at merchant ".repeat(100)
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            description = longDescription,
                            transactionStatus = "COMPLETED"
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals(longDescription, transaction.description)
        }
    }

    @Nested
    @DisplayName("Friendly Description Validation")
    inner class FriendlyDescriptionValidation {

        @Test
        @DisplayName("Should accept empty friendly description")
        fun shouldAcceptEmptyFriendlyDescription() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED",
                            friendlyDescription = ""
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertEquals("", transaction.friendlyDescription)
        }

        @Test
        @DisplayName("Should accept various friendly description formats")
        fun shouldAcceptVariousFriendlyDescriptionFormats() {
            val validFriendlyDescriptions =
                    listOf(
                            "Coffee ☕",
                            "Lunch 🍽️",
                            "Gas ⛽",
                            "Groceries 🛒",
                            "Salary 💰",
                            "Rent 🏠",
                            "Netflix 📺",
                            "Uber 🚗",
                            "Amazon 📦",
                            "Pharmacy 💊",
                            "Gym 💪",
                            "Movie 🎬",
                            "Insurance 🛡️",
                            "Utilities ⚡",
                            "Internet 🌐"
                    )

            validFriendlyDescriptions.forEach { friendlyDescription ->
                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED",
                                friendlyDescription = friendlyDescription
                        )

                val violations = validator.validate(transaction)
                assertTrue(
                        violations.isEmpty(),
                        "Friendly description '$friendlyDescription' should be valid"
                )
                assertEquals(friendlyDescription, transaction.friendlyDescription)
            }
        }
    }

    @Nested
    @DisplayName("Relationship Validation")
    inner class RelationshipValidation {

        @Test
        @DisplayName("Should handle nullable account correctly")
        fun shouldHandleNullableAccountCorrectly() {
            val transactionWithAccount =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            account = testAccount,
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val transactionWithoutAccount = transactionWithAccount.copy(account = null)

            val violationsWithAccount = validator.validate(transactionWithAccount)
            val violationsWithoutAccount = validator.validate(transactionWithoutAccount)

            assertTrue(violationsWithAccount.isEmpty())
            assertTrue(violationsWithoutAccount.isEmpty())
            assertEquals(testAccount, transactionWithAccount.account)
            assertNull(transactionWithoutAccount.account)
        }

        @Test
        @DisplayName("Should handle nullable card correctly")
        fun shouldHandleNullableCardCorrectly() {
            val transactionWithCard =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            card = testBriefCard,
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val transactionWithoutCard = transactionWithCard.copy(card = null)

            val violationsWithCard = validator.validate(transactionWithCard)
            val violationsWithoutCard = validator.validate(transactionWithoutCard)

            assertTrue(violationsWithCard.isEmpty())
            assertTrue(violationsWithoutCard.isEmpty())
            assertEquals(testBriefCard, transactionWithCard.card)
            assertNull(transactionWithoutCard.card)
        }

        @Test
        @DisplayName("Should handle different card types in BriefCard")
        fun shouldHandleDifferentCardTypesInBriefCard() {
            CardType.values().forEach { cardType ->
                val briefCard =
                        BriefCard(id = 1L, cardNumber = "4111111111111111", cardType = cardType)

                val transaction =
                        TransactionHistory(
                                id = 1L,
                                transactionReference = "TXN123",
                                card = briefCard,
                                transactionDate = LocalDate.now(),
                                amount = 100.0,
                                transactionType = "DEBIT",
                                transactionStatus = "COMPLETED"
                        )

                val violations = validator.validate(transaction)
                assertTrue(violations.isEmpty(), "Card type $cardType should be valid")
                assertEquals(cardType, transaction.card?.cardType)
            }
        }
    }

    @Nested
    @DisplayName("Data Class Behavior")
    inner class DataClassBehavior {

        @Test
        @DisplayName("Should implement equals correctly")
        fun shouldImplementEqualsCorrectly() {
            val transaction1 =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123456789",
                            account = testAccount,
                            card = testBriefCard,
                            transactionDate = LocalDate.of(2023, 12, 1),
                            transactionTime = LocalTime.of(14, 30, 45),
                            amount = 150.75,
                            transactionType = "DEBIT",
                            description = "Coffee purchase",
                            transactionStatus = "COMPLETED",
                            friendlyDescription = "Coffee ☕"
                    )

            val transaction2 = transaction1.copy()
            val transaction3 = transaction1.copy(id = 2L)

            assertEquals(transaction1, transaction2)
            assertNotEquals(transaction1, transaction3)
        }

        @Test
        @DisplayName("Should implement hashCode correctly")
        fun shouldImplementHashCodeCorrectly() {
            val transaction1 =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123",
                            transactionDate = LocalDate.now(),
                            amount = 100.0,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val transaction2 = transaction1.copy()

            assertEquals(transaction1.hashCode(), transaction2.hashCode())
        }

        @Test
        @DisplayName("Should implement toString correctly")
        fun shouldImplementToStringCorrectly() {
            val transaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123456789",
                            transactionDate = LocalDate.now(),
                            amount = 150.75,
                            transactionType = "DEBIT",
                            transactionStatus = "COMPLETED"
                    )

            val toString = transaction.toString()
            assertTrue(toString.contains("TransactionHistory"))
            assertTrue(toString.contains("TXN123456789"))
            assertTrue(toString.contains("DEBIT"))
        }

        @Test
        @DisplayName("Should support copy with modifications")
        fun shouldSupportCopyWithModifications() {
            val originalTransaction =
                    TransactionHistory(
                            id = 1L,
                            transactionReference = "TXN123456789",
                            account = testAccount,
                            transactionDate = LocalDate.of(2023, 12, 1),
                            amount = 150.75,
                            transactionType = "DEBIT",
                            description = "Original description",
                            transactionStatus = "PENDING",
                            friendlyDescription = "Original friendly"
                    )

            val modifiedTransaction =
                    originalTransaction.copy(
                            transactionStatus = "COMPLETED",
                            friendlyDescription = "Modified friendly"
                    )

            assertEquals(1L, modifiedTransaction.id)
            assertEquals("TXN123456789", modifiedTransaction.transactionReference)
            assertEquals(testAccount, modifiedTransaction.account)
            assertEquals(LocalDate.of(2023, 12, 1), modifiedTransaction.transactionDate)
            assertEquals(150.75, modifiedTransaction.amount, 0.001)
            assertEquals("DEBIT", modifiedTransaction.transactionType)
            assertEquals("Original description", modifiedTransaction.description)
            assertEquals("COMPLETED", modifiedTransaction.transactionStatus)
            assertEquals("Modified friendly", modifiedTransaction.friendlyDescription)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle minimum valid data")
        fun shouldHandleMinimumValidData() {
            val transaction =
                    TransactionHistory(
                            id = null,
                            transactionReference = "T",
                            account = null,
                            card = null,
                            transactionDate = LocalDate.MIN,
                            transactionTime = null,
                            amount = Double.MIN_VALUE,
                            transactionType = "T",
                            description = "",
                            transactionStatus = "S",
                            friendlyDescription = ""
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle maximum reasonable values")
        fun shouldHandleMaximumReasonableValues() {
            val longString = "A".repeat(1000)
            val transaction =
                    TransactionHistory(
                            id = Long.MAX_VALUE,
                            transactionReference = longString,
                            account = testAccount,
                            card = testBriefCard,
                            transactionDate = LocalDate.MAX,
                            transactionTime = LocalTime.of(23, 59, 59, 999999999),
                            amount = Double.MAX_VALUE,
                            transactionType = longString,
                            description = longString,
                            transactionStatus = longString,
                            friendlyDescription = longString
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle all null optional fields")
        fun shouldHandleAllNullOptionalFields() {
            val transaction =
                    TransactionHistory(
                            id = null,
                            transactionReference = "TXN123",
                            account = null,
                            card = null,
                            transactionDate = LocalDate.now(),
                            transactionTime = null,
                            amount = 0.0,
                            transactionType = "TEST",
                            description = "",
                            transactionStatus = "TEST",
                            friendlyDescription = ""
                    )

            val violations = validator.validate(transaction)
            assertTrue(violations.isEmpty())
            assertNull(transaction.id)
            assertNull(transaction.account)
            assertNull(transaction.card)
            assertNull(transaction.transactionTime)
        }
    }
}
