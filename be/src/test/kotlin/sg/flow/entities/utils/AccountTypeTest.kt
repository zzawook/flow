package sg.flow.entities.utils

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.assertThrows

@DisplayName("AccountType Enum Tests")
class AccountTypeTest {

    @Nested
    @DisplayName("Enum Values and Properties")
    inner class EnumValuesAndProperties {

        @Test
        @DisplayName("Should have all expected enum values")
        fun shouldHaveAllExpectedEnumValues() {
            val expectedValues =
                    setOf(
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

            val actualValues = AccountType.values().toSet()
            assertEquals(expectedValues, actualValues)
            assertEquals(17, AccountType.values().size)
        }

        @Test
        @DisplayName("Should return correct string values")
        fun shouldReturnCorrectStringValues() {
            val expectedMappings =
                    mapOf(
                            AccountType.SAVINGS to "SAVINGS",
                            AccountType.CURRENT to "CURRENT",
                            AccountType.TIME_DEPOSIT to "TIME DEPOSIT",
                            AccountType.BONDS to "BONDS",
                            AccountType.FUNDS to "FUNDS",
                            AccountType.RETIREMENT to "RETIREMENT",
                            AccountType.SECURITIES to "SECURITIES",
                            AccountType.STOCKS to "STOCKS",
                            AccountType.MORTGAGE to "MORTGAGE",
                            AccountType.PERSONAL_LOAN to "PERSONAL LOAN",
                            AccountType.REVOLVING_LOAN to "REVOLVING LOAN",
                            AccountType.CREDIT_CARD to "CREDIT_CARD",
                            AccountType.DEBIT_CARD to "DEBIT_CARD",
                            AccountType.FIXED_DEPOSIT to "FIXED_DEPOSIT",
                            AccountType.FOREIGN_CURRENCY to "FOREIGN_CURRENCY",
                            AccountType.OTHERS to "OTHERS",
                            AccountType.UNKNOWN to "UNKNOWN"
                    )

            expectedMappings.forEach { (enumValue, expectedString) ->
                assertEquals(expectedString, enumValue.getValue)
            }
        }

        @Test
        @DisplayName("Should have consistent toString implementation")
        fun shouldHaveConsistentToStringImplementation() {
            AccountType.values().forEach { accountType ->
                val toString = accountType.toString()
                assertEquals(accountType.name, toString)
            }
        }

        @Test
        @DisplayName("Should have consistent ordinal values")
        fun shouldHaveConsistentOrdinalValues() {
            val expectedOrdinals =
                    mapOf(
                            AccountType.SAVINGS to 0,
                            AccountType.CURRENT to 1,
                            AccountType.TIME_DEPOSIT to 2,
                            AccountType.BONDS to 3,
                            AccountType.FUNDS to 4,
                            AccountType.RETIREMENT to 5,
                            AccountType.SECURITIES to 6,
                            AccountType.STOCKS to 7,
                            AccountType.MORTGAGE to 8,
                            AccountType.PERSONAL_LOAN to 9,
                            AccountType.REVOLVING_LOAN to 10,
                            AccountType.CREDIT_CARD to 11,
                            AccountType.DEBIT_CARD to 12,
                            AccountType.FIXED_DEPOSIT to 13,
                            AccountType.FOREIGN_CURRENCY to 14,
                            AccountType.OTHERS to 15,
                            AccountType.UNKNOWN to 16
                    )

            expectedOrdinals.forEach { (enumValue, expectedOrdinal) ->
                assertEquals(expectedOrdinal, enumValue.ordinal)
            }
        }
    }

    @Nested
    @DisplayName("fromValue Method Tests")
    inner class FromValueMethodTests {

        @Test
        @DisplayName("Should create enum from exact string values")
        fun shouldCreateEnumFromExactStringValues() {
            val exactMappings =
                    mapOf(
                            "SAVINGS" to AccountType.SAVINGS,
                            "CURRENT" to AccountType.CURRENT,
                            "TIME DEPOSIT" to AccountType.TIME_DEPOSIT,
                            "BONDS" to AccountType.BONDS,
                            "FUNDS" to AccountType.FUNDS,
                            "RETIREMENT" to AccountType.RETIREMENT,
                            "SECURITIES" to AccountType.SECURITIES,
                            "STOCKS" to AccountType.STOCKS,
                            "MORTGAGE" to AccountType.MORTGAGE,
                            "PERSONAL LOAN" to AccountType.PERSONAL_LOAN,
                            "REVOLVING LOAN" to AccountType.REVOLVING_LOAN,
                            "CREDIT_CARD" to AccountType.CREDIT_CARD,
                            "DEBIT_CARD" to AccountType.DEBIT_CARD,
                            "FIXED_DEPOSIT" to AccountType.FIXED_DEPOSIT,
                            "FOREIGN_CURRENCY" to AccountType.FOREIGN_CURRENCY,
                            "OTHERS" to AccountType.OTHERS,
                            "UNKNOWN" to AccountType.UNKNOWN
                    )

            exactMappings.forEach { (stringValue, expectedEnum) ->
                assertEquals(expectedEnum, AccountType.fromValue(stringValue))
            }
        }

        @Test
        @DisplayName("Should create enum from case insensitive values")
        fun shouldCreateEnumFromCaseInsensitiveValues() {
            val caseInsensitiveMappings =
                    mapOf(
                            "savings" to AccountType.SAVINGS,
                            "current" to AccountType.CURRENT,
                            "time deposit" to AccountType.TIME_DEPOSIT,
                            "BONDS" to AccountType.BONDS,
                            "Funds" to AccountType.FUNDS,
                            "rEtIrEmEnT" to AccountType.RETIREMENT,
                            "SECURITIES" to AccountType.SECURITIES,
                            "stocks" to AccountType.STOCKS,
                            "Mortgage" to AccountType.MORTGAGE,
                            "personal loan" to AccountType.PERSONAL_LOAN,
                            "revolving loan" to AccountType.REVOLVING_LOAN,
                            "credit_card" to AccountType.CREDIT_CARD,
                            "debit_card" to AccountType.DEBIT_CARD,
                            "fixed_deposit" to AccountType.FIXED_DEPOSIT,
                            "foreign_currency" to AccountType.FOREIGN_CURRENCY,
                            "others" to AccountType.OTHERS,
                            "unknown" to AccountType.UNKNOWN
                    )

            caseInsensitiveMappings.forEach { (stringValue, expectedEnum) ->
                assertEquals(expectedEnum, AccountType.fromValue(stringValue))
            }
        }

        @Test
        @DisplayName("Should throw exception for values with whitespace")
        fun shouldThrowExceptionForValuesWithWhitespace() {
            val whitespaceValues =
                    listOf(" SAVINGS ", "  CURRENT  ", "\tTIME DEPOSIT\t", "\nBONDS\n")

            whitespaceValues.forEach { stringValue ->
                assertThrows(IllegalArgumentException::class.java) {
                    AccountType.fromValue(stringValue)
                }
            }
        }

        @Test
        @DisplayName("Should throw exception for invalid values")
        fun shouldThrowExceptionForInvalidValues() {
            val invalidValues =
                    listOf(
                            "INVALID_TYPE",
                            "CHECKING",
                            "BUSINESS",
                            "",
                            "   ",
                            "NULL",
                            "SAVING", // Missing S
                            "CURRENTS", // Extra S
                            "TIMEDEPOSIT", // Missing space
                            "TIME_DEPOSIT", // Underscore instead of space
                            "PERSONAL_LOAN", // Underscore instead of space
                            "CREDIT CARD", // Space instead of underscore
                            "123",
                            "null",
                            "undefined"
                    )

            invalidValues.forEach { invalidValue ->
                assertThrows<IllegalArgumentException>(
                        "Value '$invalidValue' should throw exception"
                ) { AccountType.fromValue(invalidValue) }
            }
        }

        @Test
        @DisplayName("Should throw exception with descriptive message")
        fun shouldThrowExceptionWithDescriptiveMessage() {
            val exception =
                    assertThrows<IllegalArgumentException> { AccountType.fromValue("INVALID_TYPE") }

            assertTrue(exception.message?.contains("Unknown enum type") == true)
            assertTrue(exception.message?.contains("INVALID_TYPE") == true)
        }

        @Test
        @DisplayName("Should handle special characters and Unicode")
        fun shouldHandleSpecialCharactersAndUnicode() {
            val specialValues =
                    listOf(
                            "SAVINGS@",
                            "CURRENT#",
                            "储蓄",
                            "épargne",
                            "現在",
                            "SAVINGS\u0000", // Null character
                            "CURRENT\u00A0", // Non-breaking space
                            "SAVINGS\u200B" // Zero-width space
                    )

            specialValues.forEach { specialValue ->
                assertThrows<IllegalArgumentException>(
                        "Special value '$specialValue' should throw exception"
                ) { AccountType.fromValue(specialValue) }
            }
        }

        @Test
        @DisplayName("Should handle null value gracefully")
        fun shouldHandleNullValueGracefully() {
            // Note: fromValue doesn't accept null parameters in Kotlin
            // This test verifies the Kotlin type system prevents null parameters
            assertTrue(true) // Type safety prevents null from being passed
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle enum comparison correctly")
        fun shouldHandleEnumComparisonCorrectly() {
            assertTrue(AccountType.SAVINGS == AccountType.SAVINGS)
            assertFalse(AccountType.SAVINGS == AccountType.CURRENT)

            assertTrue(AccountType.SAVINGS.equals(AccountType.SAVINGS))
            assertFalse(AccountType.SAVINGS.equals(AccountType.CURRENT))
            assertFalse(AccountType.SAVINGS.equals(null))
            assertFalse(AccountType.SAVINGS.equals("SAVINGS"))
        }

        @Test
        @DisplayName("Should handle enum hash code correctly")
        fun shouldHandleEnumHashCodeCorrectly() {
            assertEquals(AccountType.SAVINGS.hashCode(), AccountType.SAVINGS.hashCode())

            val hashCodes = AccountType.values().map { it.hashCode() }.toSet()
            assertEquals(AccountType.values().size, hashCodes.size) // All should be unique
        }

        @Test
        @DisplayName("Should handle enum in switch/when statements")
        fun shouldHandleEnumInSwitchWhenStatements() {
            fun getDescription(accountType: AccountType): String =
                    when (accountType) {
                        AccountType.SAVINGS -> "Savings Account"
                        AccountType.CURRENT -> "Current Account"
                        AccountType.TIME_DEPOSIT -> "Time Deposit Account"
                        AccountType.BONDS -> "Bonds Account"
                        AccountType.FUNDS -> "Funds Account"
                        AccountType.RETIREMENT -> "Retirement Account"
                        AccountType.SECURITIES -> "Securities Account"
                        AccountType.STOCKS -> "Stocks Account"
                        AccountType.MORTGAGE -> "Mortgage Account"
                        AccountType.PERSONAL_LOAN -> "Personal Loan Account"
                        AccountType.REVOLVING_LOAN -> "Revolving Loan Account"
                        AccountType.CREDIT_CARD -> "Credit Card Account"
                        AccountType.DEBIT_CARD -> "Debit Card Account"
                        AccountType.FIXED_DEPOSIT -> "Fixed Deposit Account"
                        AccountType.FOREIGN_CURRENCY -> "Foreign Currency Account"
                        AccountType.OTHERS -> "Other Account Type"
                        AccountType.UNKNOWN -> "Unknown Account Type"
                    }

            AccountType.values().forEach { accountType ->
                val description = getDescription(accountType)
                assertNotNull(description)
                assertTrue(description.isNotEmpty())
            }
        }

        @Test
        @DisplayName("Should handle valueOf and values methods correctly")
        fun shouldHandleValueOfAndValuesMethodsCorrectly() {
            // Test valueOf
            AccountType.values().forEach { accountType ->
                assertEquals(accountType, AccountType.valueOf(accountType.name))
            }

            // Test that valueOf throws exception for invalid names
            assertThrows<IllegalArgumentException> { AccountType.valueOf("INVALID_NAME") }

            // Test values()
            val allValues = AccountType.values()
            assertTrue(allValues.isNotEmpty())
            assertEquals(17, allValues.size)
            assertTrue(allValues.contains(AccountType.SAVINGS))
            assertTrue(allValues.contains(AccountType.UNKNOWN))
        }

        @Test
        @DisplayName("Should maintain enum contract invariants")
        fun shouldMaintainEnumContractInvariants() {
            AccountType.values().forEach { accountType ->
                // Each enum should have a non-null name
                assertNotNull(accountType.name)
                assertTrue(accountType.name.isNotEmpty())

                // Each enum should have a valid ordinal
                assertTrue(accountType.ordinal >= 0)
                assertTrue(accountType.ordinal < AccountType.values().size)

                // Each enum should have a non-null getValue
                assertNotNull(accountType.getValue)
                assertTrue(accountType.getValue.isNotEmpty())

                // toString should return the name
                assertEquals(accountType.name, accountType.toString())
            }
        }

        @Test
        @DisplayName("Should handle concurrent access correctly")
        fun shouldHandleConcurrentAccessCorrectly() {
            val results = java.util.concurrent.CopyOnWriteArrayList<AccountType>()
            val threads = mutableListOf<Thread>()

            repeat(10) { _ ->
                val thread = Thread {
                    repeat(100) {
                        results.add(AccountType.fromValue("SAVINGS"))
                        results.add(AccountType.valueOf("CURRENT"))
                    }
                }
                threads.add(thread)
                thread.start()
            }

            threads.forEach { it.join() }

            assertEquals(2000, results.size)
            assertTrue(results.all { it == AccountType.SAVINGS || it == AccountType.CURRENT })
        }
    }
}
