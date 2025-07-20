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
import sg.flow.entities.utils.CardType

@DisplayName("Card Entity Tests")
class CardTest {

    private lateinit var validator: Validator
    private lateinit var testUser: User
    private lateinit var testBank: Bank
    private lateinit var testAccount: Account

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
    }

    @Nested
    @DisplayName("Valid Card Creation")
    inner class ValidCardCreation {

        @Test
        @DisplayName("Should create card with all valid fields")
        fun shouldCreateCardWithValidFields() {
            val card =
                    Card(
                            id = 1L,
                            owner = testUser,
                            cardNumber = "4111111111111111",
                            issuingBank = testBank,
                            linkedAccount = testAccount,
                            cardType = CardType.CREDIT,
                            cvv = "123",
                            expiryDate = LocalDate.of(2026, 12, 31),
                            cardHolderName = "John Doe",
                            pin = "1234",
                            cardStatus = "ACTIVE",
                            addressLine1 = "123 Main Street",
                            addressLine2 = "Apartment 4B",
                            city = "Singapore",
                            state = "Singapore",
                            country = "Singapore",
                            zipCode = "123456",
                            phone = "+65-91234567",
                            dailyLimit = 5000.0,
                            monthlyLimit = 50000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())

            assertEquals(1L, card.id)
            assertEquals(testUser, card.owner)
            assertEquals("4111111111111111", card.cardNumber)
            assertEquals(testBank, card.issuingBank)
            assertEquals(testAccount, card.linkedAccount)
            assertEquals(CardType.CREDIT, card.cardType)
            assertEquals("123", card.cvv)
            assertEquals(LocalDate.of(2026, 12, 31), card.expiryDate)
            assertEquals("John Doe", card.cardHolderName)
            assertEquals("1234", card.pin)
            assertEquals("ACTIVE", card.cardStatus)
        }

        @Test
        @DisplayName("Should create card with null ID")
        fun shouldCreateCardWithNullId() {
            val card =
                    Card(
                            id = null,
                            owner = testUser,
                            cardNumber = "5555555555554444",
                            issuingBank = testBank,
                            linkedAccount = testAccount,
                            cardType = CardType.DEBIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertNull(card.id)
        }

        @Test
        @DisplayName("Should create card with nullable relationships set to null")
        fun shouldCreateCardWithNullableRelationshipsSetToNull() {
            val card =
                    Card(
                            id = 1L,
                            owner = null,
                            cardNumber = "4111111111111111",
                            issuingBank = null,
                            linkedAccount = null,
                            cardType = CardType.PREPAID,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 500.0,
                            monthlyLimit = 5000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertNull(card.owner)
            assertNull(card.issuingBank)
            assertNull(card.linkedAccount)
        }

        @Test
        @DisplayName("Should create card with default values")
        fun shouldCreateCardWithDefaultValues() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())

            // Check default values
            assertEquals("", card.cvv)
            assertEquals(LocalDate.now(), card.expiryDate)
            assertEquals("", card.cardHolderName)
            assertEquals("", card.pin)
            assertEquals("", card.cardStatus)
        }
    }

    @Nested
    @DisplayName("Card Number Validation")
    inner class CardNumberValidation {

        @Test
        @DisplayName("Should reject card with empty card number")
        fun shouldRejectEmptyCardNumber() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "cardNumber" })
        }

        @Test
        @DisplayName("Should accept various card number formats")
        fun shouldAcceptVariousCardNumberFormats() {
            val validCardNumbers =
                    listOf(
                            "4111111111111111", // Visa
                            "5555555555554444", // Mastercard
                            "378282246310005", // American Express
                            "30569309025904", // Diners Club
                            "6011111111111117", // Discover
                            "3530111333300000", // JCB
                            "5019717010103742", // Dankort
                            "6331101999990016", // Switch/Solo
                            "1234567890123456", // Generic 16-digit
                            "123456789012345", // 15-digit
                            "12345678901234567890" // 20-digit
                    )

            validCardNumbers.forEach { cardNumber ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = cardNumber,
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Card number $cardNumber should be valid")
            }
        }

        @Test
        @DisplayName("Should accept card numbers with spaces and dashes")
        fun shouldAcceptCardNumbersWithSpacesAndDashes() {
            val formattedCardNumbers =
                    listOf(
                            "4111 1111 1111 1111",
                            "5555-5555-5555-4444",
                            "3782 822463 10005",
                            "4111.1111.1111.1111"
                    )

            formattedCardNumbers.forEach { cardNumber ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = cardNumber,
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(
                        violations.isEmpty(),
                        "Formatted card number $cardNumber should be valid"
                )
            }
        }

        @Test
        @DisplayName("Should accept test card numbers")
        fun shouldAcceptTestCardNumbers() {
            val testCardNumbers =
                    listOf(
                            "0000000000000000",
                            "1111111111111111",
                            "9999999999999999",
                            "1234567890123456"
                    )

            testCardNumbers.forEach { cardNumber ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = cardNumber,
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Test card number $cardNumber should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Card Type Validation")
    inner class CardTypeValidation {

        @Test
        @DisplayName("Should accept all card types")
        fun shouldAcceptAllCardTypes() {
            CardType.values().forEach { cardType ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = cardType,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Card type $cardType should be valid")
                assertEquals(cardType, card.cardType)
            }
        }
    }

    @Nested
    @DisplayName("CVV Validation")
    inner class CvvValidation {

        @Test
        @DisplayName("Should accept various CVV formats")
        fun shouldAcceptVariousCvvFormats() {
            val validCvvs =
                    listOf(
                            "",
                            "123",
                            "456",
                            "0000",
                            "9999",
                            "1234", // 4-digit for American Express
                            "12", // 2-digit
                            "12345" // 5-digit
                    )

            validCvvs.forEach { cvv ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                cvv = cvv,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "CVV $cvv should be valid")
                assertEquals(cvv, card.cvv)
            }
        }
    }

    @Nested
    @DisplayName("Expiry Date Validation")
    inner class ExpiryDateValidation {

        @Test
        @DisplayName("Should accept past expiry dates")
        fun shouldAcceptPastExpiryDates() {
            val pastDate = LocalDate.of(2020, 1, 1)
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            expiryDate = pastDate,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertEquals(pastDate, card.expiryDate)
        }

        @Test
        @DisplayName("Should accept future expiry dates")
        fun shouldAcceptFutureExpiryDates() {
            val futureDate = LocalDate.of(2030, 12, 31)
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            expiryDate = futureDate,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertEquals(futureDate, card.expiryDate)
        }

        @Test
        @DisplayName("Should accept current date as expiry")
        fun shouldAcceptCurrentDateAsExpiry() {
            val currentDate = LocalDate.now()
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            expiryDate = currentDate,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("PIN Validation")
    inner class PinValidation {

        @Test
        @DisplayName("Should accept various PIN formats")
        fun shouldAcceptVariousPinFormats() {
            val validPins =
                    listOf(
                            "",
                            "1234",
                            "0000",
                            "9999",
                            "123456", // 6-digit PIN
                            "12345678", // 8-digit PIN
                            "123", // 3-digit
                            "12" // 2-digit
                    )

            validPins.forEach { pin ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.DEBIT,
                                pin = pin,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "PIN $pin should be valid")
                assertEquals(pin, card.pin)
            }
        }
    }

    @Nested
    @DisplayName("Address Validation")
    inner class AddressValidation {

        @Test
        @DisplayName("Should reject card with empty address line 1")
        fun shouldRejectEmptyAddressLine1() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "addressLine1" })
        }

        @Test
        @DisplayName("Should accept empty address line 2")
        fun shouldAcceptEmptyAddressLine2() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "123 Main Street",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertEquals("", card.addressLine2)
        }

        @Test
        @DisplayName("Should accept various address formats")
        fun shouldAcceptVariousAddressFormats() {
            val addressTestCases =
                    listOf(
                            Triple("123 Main St", "Apt 4B", "New York"),
                            Triple("Block 123, #04-567", "Toa Payoh", "Singapore"),
                            Triple("Flat 2, 456 High Street", "", "London"),
                            Triple("789 Oak Avenue", "Suite 100", "Los Angeles"),
                            Triple("1-2-3 Ginza", "Chuo-ku", "Tokyo"),
                            Triple("Calle Mayor 123", "Piso 4", "Madrid")
                    )

            addressTestCases.forEach { (line1, line2, city) ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                addressLine1 = line1,
                                addressLine2 = line2,
                                city = city,
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Address '$line1, $line2, $city' should be valid")
            }
        }

        @Test
        @DisplayName("Should reject cards with empty required address fields")
        fun shouldRejectCardsWithEmptyRequiredAddressFields() {
            val requiredFields = listOf("city", "state", "country", "zipCode", "phone")

            requiredFields.forEach { field ->
                val card =
                        when (field) {
                            "city" ->
                                    Card(
                                            id = 1L,
                                            cardNumber = "4111111111111111",
                                            cardType = CardType.CREDIT,
                                            addressLine1 = "Test",
                                            addressLine2 = "",
                                            city = "",
                                            state = "Test",
                                            country = "Test",
                                            zipCode = "12345",
                                            phone = "+65-12345678",
                                            dailyLimit = 1000.0,
                                            monthlyLimit = 10000.0
                                    )
                            "state" ->
                                    Card(
                                            id = 1L,
                                            cardNumber = "4111111111111111",
                                            cardType = CardType.CREDIT,
                                            addressLine1 = "Test",
                                            addressLine2 = "",
                                            city = "Test",
                                            state = "",
                                            country = "Test",
                                            zipCode = "12345",
                                            phone = "+65-12345678",
                                            dailyLimit = 1000.0,
                                            monthlyLimit = 10000.0
                                    )
                            "country" ->
                                    Card(
                                            id = 1L,
                                            cardNumber = "4111111111111111",
                                            cardType = CardType.CREDIT,
                                            addressLine1 = "Test",
                                            addressLine2 = "",
                                            city = "Test",
                                            state = "Test",
                                            country = "",
                                            zipCode = "12345",
                                            phone = "+65-12345678",
                                            dailyLimit = 1000.0,
                                            monthlyLimit = 10000.0
                                    )
                            "zipCode" ->
                                    Card(
                                            id = 1L,
                                            cardNumber = "4111111111111111",
                                            cardType = CardType.CREDIT,
                                            addressLine1 = "Test",
                                            addressLine2 = "",
                                            city = "Test",
                                            state = "Test",
                                            country = "Test",
                                            zipCode = "",
                                            phone = "+65-12345678",
                                            dailyLimit = 1000.0,
                                            monthlyLimit = 10000.0
                                    )
                            "phone" ->
                                    Card(
                                            id = 1L,
                                            cardNumber = "4111111111111111",
                                            cardType = CardType.CREDIT,
                                            addressLine1 = "Test",
                                            addressLine2 = "",
                                            city = "Test",
                                            state = "Test",
                                            country = "Test",
                                            zipCode = "12345",
                                            phone = "",
                                            dailyLimit = 1000.0,
                                            monthlyLimit = 10000.0
                                    )
                            else -> throw IllegalArgumentException("Unknown field: $field")
                        }

                val violations = validator.validate(card)
                assertFalse(violations.isEmpty(), "Empty $field should cause validation failure")
                assertTrue(violations.any { it.propertyPath.toString() == field })
            }
        }
    }

    @Nested
    @DisplayName("Limits Validation")
    inner class LimitsValidation {

        @Test
        @DisplayName("Should accept various daily limits")
        fun shouldAcceptVariousDailyLimits() {
            val validLimits = listOf(0.0, 0.01, 100.0, 1000.0, 10000.0, 100000.0, Double.MAX_VALUE)

            validLimits.forEach { limit ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = limit,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Daily limit $limit should be valid")
                assertEquals(limit, card.dailyLimit, 0.001)
            }
        }

        @Test
        @DisplayName("Should accept various monthly limits")
        fun shouldAcceptVariousMonthlyLimits() {
            val validLimits =
                    listOf(0.0, 0.01, 1000.0, 10000.0, 100000.0, 1000000.0, Double.MAX_VALUE)

            validLimits.forEach { limit ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = limit
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Monthly limit $limit should be valid")
                assertEquals(limit, card.monthlyLimit, 0.001)
            }
        }

        @Test
        @DisplayName("Should accept negative limits")
        fun shouldAcceptNegativeLimits() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = -1000.0,
                            monthlyLimit = -10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
            assertEquals(-1000.0, card.dailyLimit, 0.001)
            assertEquals(-10000.0, card.monthlyLimit, 0.001)
        }
    }

    @Nested
    @DisplayName("Card Status Validation")
    inner class CardStatusValidation {

        @Test
        @DisplayName("Should accept various card statuses")
        fun shouldAcceptVariousCardStatuses() {
            val validStatuses =
                    listOf(
                            "",
                            "ACTIVE",
                            "INACTIVE",
                            "BLOCKED",
                            "EXPIRED",
                            "CANCELLED",
                            "PENDING",
                            "SUSPENDED",
                            "LOST",
                            "STOLEN",
                            "DAMAGED"
                    )

            validStatuses.forEach { status ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                cardStatus = status,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = 1000.0,
                                monthlyLimit = 10000.0
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Card status '$status' should be valid")
                assertEquals(status, card.cardStatus)
            }
        }
    }

    @Nested
    @DisplayName("Relationship Validation")
    inner class RelationshipValidation {

        @Test
        @DisplayName("Should handle nullable owner correctly")
        fun shouldHandleNullableOwnerCorrectly() {
            val cardWithOwner =
                    Card(
                            id = 1L,
                            owner = testUser,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val cardWithoutOwner = cardWithOwner.copy(owner = null)

            val violationsWithOwner = validator.validate(cardWithOwner)
            val violationsWithoutOwner = validator.validate(cardWithoutOwner)

            assertTrue(violationsWithOwner.isEmpty())
            assertTrue(violationsWithoutOwner.isEmpty())
            assertEquals(testUser, cardWithOwner.owner)
            assertNull(cardWithoutOwner.owner)
        }

        @Test
        @DisplayName("Should handle nullable issuing bank correctly")
        fun shouldHandleNullableIssuingBankCorrectly() {
            val cardWithBank =
                    Card(
                            id = 1L,
                            issuingBank = testBank,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val cardWithoutBank = cardWithBank.copy(issuingBank = null)

            val violationsWithBank = validator.validate(cardWithBank)
            val violationsWithoutBank = validator.validate(cardWithoutBank)

            assertTrue(violationsWithBank.isEmpty())
            assertTrue(violationsWithoutBank.isEmpty())
            assertEquals(testBank, cardWithBank.issuingBank)
            assertNull(cardWithoutBank.issuingBank)
        }

        @Test
        @DisplayName("Should handle nullable linked account correctly")
        fun shouldHandleNullableLinkedAccountCorrectly() {
            val cardWithAccount =
                    Card(
                            id = 1L,
                            linkedAccount = testAccount,
                            cardNumber = "4111111111111111",
                            cardType = CardType.DEBIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val cardWithoutAccount = cardWithAccount.copy(linkedAccount = null)

            val violationsWithAccount = validator.validate(cardWithAccount)
            val violationsWithoutAccount = validator.validate(cardWithoutAccount)

            assertTrue(violationsWithAccount.isEmpty())
            assertTrue(violationsWithoutAccount.isEmpty())
            assertEquals(testAccount, cardWithAccount.linkedAccount)
            assertNull(cardWithoutAccount.linkedAccount)
        }
    }

    @Nested
    @DisplayName("Data Class Behavior")
    inner class DataClassBehavior {

        @Test
        @DisplayName("Should implement equals correctly")
        fun shouldImplementEqualsCorrectly() {
            val card1 =
                    Card(
                            id = 1L,
                            owner = testUser,
                            cardNumber = "4111111111111111",
                            issuingBank = testBank,
                            linkedAccount = testAccount,
                            cardType = CardType.CREDIT,
                            cvv = "123",
                            expiryDate = LocalDate.of(2026, 12, 31),
                            cardHolderName = "John Doe",
                            pin = "1234",
                            cardStatus = "ACTIVE",
                            addressLine1 = "123 Main Street",
                            addressLine2 = "Apt 4B",
                            city = "Singapore",
                            state = "Singapore",
                            country = "Singapore",
                            zipCode = "123456",
                            phone = "+65-91234567",
                            dailyLimit = 5000.0,
                            monthlyLimit = 50000.0
                    )

            val card2 = card1.copy()
            val card3 = card1.copy(id = 2L)

            assertEquals(card1, card2)
            assertNotEquals(card1, card3)
        }

        @Test
        @DisplayName("Should implement hashCode correctly")
        fun shouldImplementHashCodeCorrectly() {
            val card1 =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val card2 = card1.copy()

            assertEquals(card1.hashCode(), card2.hashCode())
        }

        @Test
        @DisplayName("Should implement toString correctly")
        fun shouldImplementToStringCorrectly() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val toString = card.toString()
            assertTrue(toString.contains("Card"))
            assertTrue(toString.contains("4111111111111111"))
            assertTrue(toString.contains("CREDIT"))
        }

        @Test
        @DisplayName("Should support copy with modifications")
        fun shouldSupportCopyWithModifications() {
            val originalCard =
                    Card(
                            id = 1L,
                            cardNumber = "4111111111111111",
                            cardType = CardType.CREDIT,
                            cardStatus = "ACTIVE",
                            addressLine1 = "Test Address",
                            addressLine2 = "",
                            city = "Test City",
                            state = "Test State",
                            country = "Test Country",
                            zipCode = "12345",
                            phone = "+65-12345678",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val modifiedCard = originalCard.copy(cardStatus = "BLOCKED", dailyLimit = 0.0)

            assertEquals(1L, modifiedCard.id)
            assertEquals("4111111111111111", modifiedCard.cardNumber)
            assertEquals(CardType.CREDIT, modifiedCard.cardType)
            assertEquals("BLOCKED", modifiedCard.cardStatus)
            assertEquals(0.0, modifiedCard.dailyLimit, 0.001)
            assertEquals(10000.0, modifiedCard.monthlyLimit, 0.001)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle minimum valid data")
        fun shouldHandleMinimumValidData() {
            val card =
                    Card(
                            id = null,
                            cardNumber = "1",
                            cardType = CardType.OTHERS,
                            addressLine1 = "A",
                            addressLine2 = "",
                            city = "B",
                            state = "C",
                            country = "D",
                            zipCode = "E",
                            phone = "F",
                            dailyLimit = Double.MIN_VALUE,
                            monthlyLimit = Double.MIN_VALUE
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle maximum reasonable values")
        fun shouldHandleMaximumReasonableValues() {
            val longString = "A".repeat(1000)
            val card =
                    Card(
                            id = Long.MAX_VALUE,
                            owner = testUser,
                            cardNumber = "9".repeat(50),
                            issuingBank = testBank,
                            linkedAccount = testAccount,
                            cardType = CardType.CORPORATE,
                            cvv = "9".repeat(10),
                            expiryDate = LocalDate.MAX,
                            cardHolderName = longString,
                            pin = "9".repeat(20),
                            cardStatus = longString,
                            addressLine1 = longString,
                            addressLine2 = longString,
                            city = longString,
                            state = longString,
                            country = longString,
                            zipCode = longString,
                            phone = longString,
                            dailyLimit = Double.MAX_VALUE,
                            monthlyLimit = Double.MAX_VALUE
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle special floating point values")
        fun shouldHandleSpecialFloatingPointValues() {
            val specialValues =
                    listOf(Double.POSITIVE_INFINITY, Double.NEGATIVE_INFINITY, Double.NaN)

            specialValues.forEach { value ->
                val card =
                        Card(
                                id = 1L,
                                cardNumber = "4111111111111111",
                                cardType = CardType.CREDIT,
                                addressLine1 = "Test Address",
                                addressLine2 = "",
                                city = "Test City",
                                state = "Test State",
                                country = "Test Country",
                                zipCode = "12345",
                                phone = "+65-12345678",
                                dailyLimit = value,
                                monthlyLimit = value
                        )

                val violations = validator.validate(card)
                assertTrue(violations.isEmpty(), "Special value $value should be handled")
            }
        }

        @Test
        @DisplayName("Should handle Unicode characters in all string fields")
        fun shouldHandleUnicodeCharactersInAllStringFields() {
            val card =
                    Card(
                            id = 1L,
                            cardNumber = "测试卡号123456789",
                            cardType = CardType.CREDIT,
                            cvv = "测试",
                            cardHolderName = "测试用户 🙋‍♀️",
                            pin = "测试密码",
                            cardStatus = "激活状态 ✅",
                            addressLine1 = "测试地址 123号",
                            addressLine2 = "公寓 4B 🏠",
                            city = "新加坡 🇸🇬",
                            state = "新加坡州",
                            country = "新加坡共和国",
                            zipCode = "测试123",
                            phone = "+65-测试123",
                            dailyLimit = 1000.0,
                            monthlyLimit = 10000.0
                    )

            val violations = validator.validate(card)
            assertTrue(violations.isEmpty())
        }
    }
}
