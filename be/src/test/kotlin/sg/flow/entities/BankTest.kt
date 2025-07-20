package sg.flow.entities

import jakarta.validation.Validation
import jakarta.validation.Validator
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("Bank Entity Tests")
class BankTest {

    private lateinit var validator: Validator

    @BeforeEach
    fun setup() {
        val factory = Validation.buildDefaultValidatorFactory()
        validator = factory.validator
    }

    @Nested
    @DisplayName("Valid Bank Creation")
    inner class ValidBankCreation {

        @Test
        @DisplayName("Should create bank with all valid fields")
        fun shouldCreateBankWithValidFields() {
            val bank = Bank(id = 1, name = "Development Bank of Singapore", bankCode = "DBS")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())

            assertEquals(1, bank.id)
            assertEquals("Development Bank of Singapore", bank.name)
            assertEquals("DBS", bank.bankCode)
        }

        @Test
        @DisplayName("Should create bank with null ID")
        fun shouldCreateBankWithNullId() {
            val bank = Bank(id = null, name = "United Overseas Bank", bankCode = "UOB")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertNull(bank.id)
            assertEquals("United Overseas Bank", bank.name)
            assertEquals("UOB", bank.bankCode)
        }

        @Test
        @DisplayName("Should create bank with various valid bank codes")
        fun shouldCreateBankWithVariousBankCodes() {
            val validBankCodes =
                    listOf(
                            "DBS",
                            "UOB",
                            "OCBC",
                            "HSBC",
                            "CITI",
                            "SCB",
                            "MAYBANK",
                            "ANZ",
                            "RHB",
                            "CIMB",
                            "BOC",
                            "ICBC",
                            "BNP",
                            "DB"
                    )

            validBankCodes.forEach { bankCode ->
                val bank = Bank(id = 1, name = "Test Bank for $bankCode", bankCode = bankCode)

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Bank code $bankCode should be valid")
                assertEquals(bankCode, bank.bankCode)
            }
        }

        @Test
        @DisplayName("Should create bank with numeric bank codes")
        fun shouldCreateBankWithNumericBankCodes() {
            val numericBankCodes = listOf("001", "123", "7890", "999999")

            numericBankCodes.forEach { bankCode ->
                val bank = Bank(id = 1, name = "Test Bank", bankCode = bankCode)

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Numeric bank code $bankCode should be valid")
            }
        }

        @Test
        @DisplayName("Should create bank with alphanumeric bank codes")
        fun shouldCreateBankWithAlphanumericBankCodes() {
            val alphanumericBankCodes = listOf("DBS001", "UOB123", "BANK2023", "TEST123ABC")

            alphanumericBankCodes.forEach { bankCode ->
                val bank = Bank(id = 1, name = "Test Bank", bankCode = bankCode)

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Alphanumeric bank code $bankCode should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Bank Name Validation")
    inner class BankNameValidation {

        @Test
        @DisplayName("Should reject bank with empty name")
        fun shouldRejectEmptyName() {
            val bank = Bank(id = 1, name = "", bankCode = "DBS")

            val violations = validator.validate(bank)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "name" })
        }

        @Test
        @DisplayName("Should reject bank with blank name")
        fun shouldRejectBlankName() {
            val bank = Bank(id = 1, name = "   ", bankCode = "DBS")

            val violations = validator.validate(bank)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "name" })
        }

        @Test
        @DisplayName("Should accept bank names with special characters")
        fun shouldAcceptBankNamesWithSpecialCharacters() {
            val specialNames =
                    listOf(
                            "Standard Chartered Bank (Singapore) Limited",
                            "HSBC Bank (Singapore) Ltd.",
                            "BNP Paribas S.A.",
                            "Crédit Agricole CIB",
                            "Société Générale",
                            "Deutsche Bank AG",
                            "The Royal Bank of Scotland N.V.",
                            "Citibank N.A.",
                            "Bank of America, N.A.",
                            "J.P. Morgan Chase Bank, N.A."
                    )

            specialNames.forEach { name ->
                val bank = Bank(id = 1, name = name, bankCode = "TEST")

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Bank name '$name' should be valid")
                assertEquals(name, bank.name)
            }
        }

        @Test
        @DisplayName("Should accept very long bank names")
        fun shouldAcceptVeryLongBankNames() {
            val longName = "Very Long Bank Name ".repeat(20)
            val bank = Bank(id = 1, name = longName, bankCode = "LONG")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(longName, bank.name)
        }

        @Test
        @DisplayName("Should accept single character bank name")
        fun shouldAcceptSingleCharacterBankName() {
            val bank = Bank(id = 1, name = "A", bankCode = "A")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept bank names with numbers")
        fun shouldAcceptBankNamesWithNumbers() {
            val bank = Bank(id = 1, name = "Bank 2023 Digital Holdings Ltd", bankCode = "B2023")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept bank names with Unicode characters")
        fun shouldAcceptBankNamesWithUnicodeCharacters() {
            val unicodeNames =
                    listOf(
                            "中国银行",
                            "Crédit Suisse",
                            "Société Générale",
                            "華僑銀行",
                            "日本銀行",
                            "بنك الإمارات دبي الوطني"
                    )

            unicodeNames.forEach { name ->
                val bank = Bank(id = 1, name = name, bankCode = "UNICODE")

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Unicode bank name '$name' should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Bank Code Validation")
    inner class BankCodeValidation {

        @Test
        @DisplayName("Should reject bank with empty bank code")
        fun shouldRejectEmptyBankCode() {
            val bank = Bank(id = 1, name = "Test Bank", bankCode = "")

            val violations = validator.validate(bank)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "bankCode" })
        }

        @Test
        @DisplayName("Should reject bank with blank bank code")
        fun shouldRejectBlankBankCode() {
            val bank = Bank(id = 1, name = "Test Bank", bankCode = "   ")

            val violations = validator.validate(bank)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "bankCode" })
        }

        @Test
        @DisplayName("Should accept bank codes with special characters")
        fun shouldAcceptBankCodesWithSpecialCharacters() {
            val specialBankCodes =
                    listOf(
                            "DBS-001",
                            "UOB_SG",
                            "OCBC.COM",
                            "HSBC@SG",
                            "SCB#001",
                            "BANK$123",
                            "TEST%CODE",
                            "CODE&MORE"
                    )

            specialBankCodes.forEach { bankCode ->
                val bank = Bank(id = 1, name = "Test Bank", bankCode = bankCode)

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Bank code '$bankCode' should be valid")
            }
        }

        @Test
        @DisplayName("Should accept single character bank code")
        fun shouldAcceptSingleCharacterBankCode() {
            val bank = Bank(id = 1, name = "Test Bank", bankCode = "A")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept very long bank codes")
        fun shouldAcceptVeryLongBankCodes() {
            val longBankCode = "VERYLONGBANKCODE".repeat(10)
            val bank = Bank(id = 1, name = "Test Bank", bankCode = longBankCode)

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(longBankCode, bank.bankCode)
        }

        @Test
        @DisplayName("Should accept bank codes with Unicode characters")
        fun shouldAcceptBankCodesWithUnicodeCharacters() {
            val unicodeBankCodes = listOf("中银", "華銀", "日銀", "Créd", "Socié")

            unicodeBankCodes.forEach { bankCode ->
                val bank = Bank(id = 1, name = "Test Bank", bankCode = bankCode)

                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Unicode bank code '$bankCode' should be valid")
            }
        }
    }

    @Nested
    @DisplayName("ID Validation and Edge Cases")
    inner class IdValidationAndEdgeCases {

        @Test
        @DisplayName("Should accept zero as valid ID")
        fun shouldAcceptZeroAsValidId() {
            val bank = Bank(id = 0, name = "Test Bank", bankCode = "TEST")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(0, bank.id)
        }

        @Test
        @DisplayName("Should accept negative ID")
        fun shouldAcceptNegativeId() {
            val bank = Bank(id = -1, name = "Test Bank", bankCode = "TEST")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(-1, bank.id)
        }

        @Test
        @DisplayName("Should accept maximum integer ID")
        fun shouldAcceptMaximumIntegerId() {
            val bank = Bank(id = Int.MAX_VALUE, name = "Test Bank", bankCode = "TEST")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(Int.MAX_VALUE, bank.id)
        }

        @Test
        @DisplayName("Should accept minimum integer ID")
        fun shouldAcceptMinimumIntegerId() {
            val bank = Bank(id = Int.MIN_VALUE, name = "Test Bank", bankCode = "TEST")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(Int.MIN_VALUE, bank.id)
        }
    }

    @Nested
    @DisplayName("Real World Bank Examples")
    inner class RealWorldBankExamples {

        @Test
        @DisplayName("Should handle Singapore banks correctly")
        fun shouldHandleSingaporeBanksCorrectly() {
            val singaporeBanks =
                    listOf(
                            Triple(1, "Development Bank of Singapore", "DBS"),
                            Triple(2, "United Overseas Bank Limited", "UOB"),
                            Triple(3, "Oversea-Chinese Banking Corporation Limited", "OCBC"),
                            Triple(4, "Standard Chartered Bank (Singapore) Limited", "SCB"),
                            Triple(5, "Citibank Singapore Limited", "CITIBANK"),
                            Triple(6, "HSBC Bank (Singapore) Limited", "HSBC"),
                            Triple(7, "Maybank Singapore Limited", "MAYBANK"),
                            Triple(8, "The Royal Bank of Scotland N.V.", "RBS"),
                            Triple(9, "ANZ Bank", "ANZ"),
                            Triple(10, "BNP Paribas", "BNP")
                    )

            singaporeBanks.forEach { (id, name, code) ->
                val bank = Bank(id = id, name = name, bankCode = code)
                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "Singapore bank $name should be valid")
                assertEquals(id, bank.id)
                assertEquals(name, bank.name)
                assertEquals(code, bank.bankCode)
            }
        }

        @Test
        @DisplayName("Should handle international banks correctly")
        fun shouldHandleInternationalBanksCorrectly() {
            val internationalBanks =
                    listOf(
                            Triple(1, "JPMorgan Chase Bank", "JPMC"),
                            Triple(2, "Bank of America", "BOA"),
                            Triple(3, "Wells Fargo Bank", "WFC"),
                            Triple(4, "Goldman Sachs Bank", "GS"),
                            Triple(5, "Morgan Stanley Bank", "MS"),
                            Triple(6, "Barclays Bank", "BARC"),
                            Triple(7, "Deutsche Bank", "DB"),
                            Triple(8, "Credit Suisse", "CS"),
                            Triple(9, "UBS Bank", "UBS"),
                            Triple(10, "ING Bank", "ING")
                    )

            internationalBanks.forEach { (id, name, code) ->
                val bank = Bank(id = id, name = name, bankCode = code)
                val violations = validator.validate(bank)
                assertTrue(violations.isEmpty(), "International bank $name should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Data Class Behavior")
    inner class DataClassBehavior {

        @Test
        @DisplayName("Should implement equals correctly")
        fun shouldImplementEqualsCorrectly() {
            val bank1 = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")
            val bank2 = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")
            val bank3 = Bank(id = 2, name = "DBS Bank", bankCode = "DBS")

            assertEquals(bank1, bank2)
            assertNotEquals(bank1, bank3)
        }

        @Test
        @DisplayName("Should implement hashCode correctly")
        fun shouldImplementHashCodeCorrectly() {
            val bank1 = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")
            val bank2 = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")

            assertEquals(bank1.hashCode(), bank2.hashCode())
        }

        @Test
        @DisplayName("Should implement toString correctly")
        fun shouldImplementToStringCorrectly() {
            val bank = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")
            val toString = bank.toString()

            assertTrue(toString.contains("Bank"))
            assertTrue(toString.contains("DBS Bank"))
            assertTrue(toString.contains("DBS"))
        }

        @Test
        @DisplayName("Should support copy with modifications")
        fun shouldSupportCopyWithModifications() {
            val originalBank = Bank(id = 1, name = "DBS Bank", bankCode = "DBS")
            val copiedBank = originalBank.copy(name = "DBS Bank Limited")

            assertEquals(1, copiedBank.id)
            assertEquals("DBS Bank Limited", copiedBank.name)
            assertEquals("DBS", copiedBank.bankCode)
        }

        @Test
        @DisplayName("Should handle null values in equals comparison")
        fun shouldHandleNullValuesInEqualsComparison() {
            val bank1 = Bank(id = null, name = "Test Bank", bankCode = "TEST")
            val bank2 = Bank(id = null, name = "Test Bank", bankCode = "TEST")
            val bank3 = Bank(id = 1, name = "Test Bank", bankCode = "TEST")

            assertEquals(bank1, bank2)
            assertNotEquals(bank1, bank3)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle minimum valid data")
        fun shouldHandleMinimumValidData() {
            val bank = Bank(id = null, name = "A", bankCode = "B")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle all fields as single characters")
        fun shouldHandleAllFieldsAsSingleCharacters() {
            val bank = Bank(id = 1, name = "X", bankCode = "Y")

            val violations = validator.validate(bank)
            assertTrue(violations.isEmpty())
            assertEquals(1, bank.id)
            assertEquals("X", bank.name)
            assertEquals("Y", bank.bankCode)
        }

        @Test
        @DisplayName("Should handle whitespace-only strings as invalid")
        fun shouldHandleWhitespaceOnlyStringsAsInvalid() {
            // Test name with only whitespace
            val bankWithWhitespaceName = Bank(id = 1, name = "\t\n\r ", bankCode = "TEST")

            val violationsName = validator.validate(bankWithWhitespaceName)
            assertFalse(violationsName.isEmpty())

            // Test bank code with only whitespace
            val bankWithWhitespaceCode = Bank(id = 1, name = "Test Bank", bankCode = "\t\n\r ")

            val violationsCode = validator.validate(bankWithWhitespaceCode)
            assertFalse(violationsCode.isEmpty())
        }
    }
}
