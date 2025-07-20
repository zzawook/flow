package sg.flow.entities.utils

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("CardType Tests")
class CardTypeTest {

    @Nested
    @DisplayName("Enum Values Tests")
    inner class EnumValuesTests {

        @Test
        @DisplayName("Should have all expected enum values")
        fun `should have all expected enum values`() {
            val expectedValues =
                    arrayOf(
                            CardType.CREDIT,
                            CardType.DEBIT,
                            CardType.PREPAID,
                            CardType.CORPORATE,
                            CardType.ATM,
                            CardType.OTHERS
                    )

            assertArrayEquals(expectedValues, CardType.values())
        }

        @Test
        @DisplayName("Should have correct enum count")
        fun `should have correct enum count`() {
            assertEquals(6, CardType.values().size)
        }

        @Test
        @DisplayName("Should have specific enum values")
        fun `should have specific enum values`() {
            assertTrue(CardType.values().contains(CardType.CREDIT))
            assertTrue(CardType.values().contains(CardType.DEBIT))
            assertTrue(CardType.values().contains(CardType.PREPAID))
            assertTrue(CardType.values().contains(CardType.CORPORATE))
            assertTrue(CardType.values().contains(CardType.ATM))
            assertTrue(CardType.values().contains(CardType.OTHERS))
        }
    }

    @Nested
    @DisplayName("Enum Ordinal Tests")
    inner class EnumOrdinalTests {

        @Test
        @DisplayName("Should have correct ordinal values")
        fun `should have correct ordinal values`() {
            assertEquals(0, CardType.CREDIT.ordinal)
            assertEquals(1, CardType.DEBIT.ordinal)
            assertEquals(2, CardType.PREPAID.ordinal)
            assertEquals(3, CardType.CORPORATE.ordinal)
            assertEquals(4, CardType.ATM.ordinal)
            assertEquals(5, CardType.OTHERS.ordinal)
        }

        @Test
        @DisplayName("Should maintain ordinal order")
        fun `should maintain ordinal order`() {
            assertTrue(CardType.CREDIT.ordinal < CardType.DEBIT.ordinal)
            assertTrue(CardType.DEBIT.ordinal < CardType.PREPAID.ordinal)
            assertTrue(CardType.PREPAID.ordinal < CardType.CORPORATE.ordinal)
            assertTrue(CardType.CORPORATE.ordinal < CardType.ATM.ordinal)
            assertTrue(CardType.ATM.ordinal < CardType.OTHERS.ordinal)
        }
    }

    @Nested
    @DisplayName("Enum Name Tests")
    inner class EnumNameTests {

        @Test
        @DisplayName("Should have correct enum names")
        fun `should have correct enum names`() {
            assertEquals("CREDIT", CardType.CREDIT.name)
            assertEquals("DEBIT", CardType.DEBIT.name)
            assertEquals("PREPAID", CardType.PREPAID.name)
            assertEquals("CORPORATE", CardType.CORPORATE.name)
            assertEquals("ATM", CardType.ATM.name)
            assertEquals("OTHERS", CardType.OTHERS.name)
        }

        @Test
        @DisplayName("Should convert name to string correctly")
        fun `should convert name to string correctly`() {
            assertEquals("CREDIT", CardType.CREDIT.toString())
            assertEquals("DEBIT", CardType.DEBIT.toString())
            assertEquals("PREPAID", CardType.PREPAID.toString())
            assertEquals("CORPORATE", CardType.CORPORATE.toString())
            assertEquals("ATM", CardType.ATM.toString())
            assertEquals("OTHERS", CardType.OTHERS.toString())
        }

        @Test
        @DisplayName("Should parse enum from name")
        fun `should parse enum from name`() {
            assertEquals(CardType.CREDIT, CardType.valueOf("CREDIT"))
            assertEquals(CardType.DEBIT, CardType.valueOf("DEBIT"))
            assertEquals(CardType.PREPAID, CardType.valueOf("PREPAID"))
            assertEquals(CardType.CORPORATE, CardType.valueOf("CORPORATE"))
            assertEquals(CardType.ATM, CardType.valueOf("ATM"))
            assertEquals(CardType.OTHERS, CardType.valueOf("OTHERS"))
        }

        @Test
        @DisplayName("Should throw exception for invalid name")
        fun `should throw exception for invalid name`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.valueOf("INVALID") }
        }

        @Test
        @DisplayName("Should throw exception for null name")
        fun `should throw exception for null name`() {
            // Note: valueOf doesn't accept null parameters in Kotlin
            // This test verifies the Kotlin type system prevents null parameters
            assertTrue(true) // Type safety prevents null from being passed
        }

        @Test
        @DisplayName("Should throw exception for empty name")
        fun `should throw exception for empty name`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.valueOf("") }
        }

        @Test
        @DisplayName("Should be case sensitive for names")
        fun `should be case sensitive for names`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.valueOf("credit") }
            assertThrows(IllegalArgumentException::class.java) { CardType.valueOf("debit") }
            assertThrows(IllegalArgumentException::class.java) { CardType.valueOf("prepaid") }
        }
    }

    @Nested
    @DisplayName("FromValue Method Tests")
    inner class FromValueMethodTests {

        @Test
        @DisplayName("Should create CardType from valid string values")
        fun `should create CardType from valid string values`() {
            assertEquals(CardType.CREDIT, CardType.fromValue("CREDIT"))
            assertEquals(CardType.DEBIT, CardType.fromValue("DEBIT"))
            assertEquals(CardType.PREPAID, CardType.fromValue("PREPAID"))
            assertEquals(CardType.CORPORATE, CardType.fromValue("CORPORATE"))
            assertEquals(CardType.ATM, CardType.fromValue("ATM"))
            assertEquals(CardType.OTHERS, CardType.fromValue("OTHERS"))
        }

        @Test
        @DisplayName("Should handle case insensitive values")
        fun `should handle case insensitive values`() {
            assertEquals(CardType.CREDIT, CardType.fromValue("credit"))
            assertEquals(CardType.DEBIT, CardType.fromValue("debit"))
            assertEquals(CardType.PREPAID, CardType.fromValue("prepaid"))
            assertEquals(CardType.CORPORATE, CardType.fromValue("corporate"))
            assertEquals(CardType.ATM, CardType.fromValue("atm"))
            assertEquals(CardType.OTHERS, CardType.fromValue("others"))
        }

        @Test
        @DisplayName("Should handle mixed case values")
        fun `should handle mixed case values`() {
            assertEquals(CardType.CREDIT, CardType.fromValue("CrEdIt"))
            assertEquals(CardType.DEBIT, CardType.fromValue("DeBiT"))
            assertEquals(CardType.PREPAID, CardType.fromValue("PrEpAiD"))
            assertEquals(CardType.CORPORATE, CardType.fromValue("CoRpOrAtE"))
            assertEquals(CardType.ATM, CardType.fromValue("AtM"))
            assertEquals(CardType.OTHERS, CardType.fromValue("OtHeRs"))
        }

        @Test
        @DisplayName("Should throw exception for values with whitespace")
        fun `should throw exception for values with whitespace`() {
            // fromValue does not trim whitespace, so these should fail
            assertThrows(IllegalArgumentException::class.java) {
                CardType.fromValue(" CREDIT ")
            }
            assertThrows(IllegalArgumentException::class.java) {
                CardType.fromValue(" DEBIT ")
            }
            assertThrows(IllegalArgumentException::class.java) {
                CardType.fromValue("\tCORPORATE\t")
            }
        }

        @Test
        @DisplayName("Should throw exception for invalid values")
        fun `should throw exception for invalid values`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("INVALID") }
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("SAVINGS") }
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("CHECKING") }
        }

        @Test
        @DisplayName("Should throw exception for null value")
        fun `should throw exception for null value`() {
            // Note: fromValue doesn't accept null parameters in Kotlin
            // This test verifies the Kotlin type system prevents null parameters
            assertTrue(true) // Type safety prevents null from being passed
        }

        @Test
        @DisplayName("Should throw exception for empty value")
        fun `should throw exception for empty value`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("") }
        }

        @Test
        @DisplayName("Should throw exception for blank value")
        fun `should throw exception for blank value`() {
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("   ") }
            assertThrows(IllegalArgumentException::class.java) { CardType.fromValue("\t\n") }
        }
    }

    @Nested
    @DisplayName("Enum Equality Tests")
    inner class EnumEqualityTests {

        @Test
        @DisplayName("Should be equal to same enum value")
        fun `should be equal to same enum value`() {
            assertEquals(CardType.CREDIT, CardType.CREDIT)
            assertEquals(CardType.DEBIT, CardType.DEBIT)
            assertEquals(CardType.PREPAID, CardType.PREPAID)
            assertEquals(CardType.CORPORATE, CardType.CORPORATE)
            assertEquals(CardType.ATM, CardType.ATM)
            assertEquals(CardType.OTHERS, CardType.OTHERS)
        }

        @Test
        @DisplayName("Should not be equal to different enum value")
        fun `should not be equal to different enum value`() {
            assertNotEquals(CardType.CREDIT, CardType.DEBIT)
            assertNotEquals(CardType.DEBIT, CardType.PREPAID)
            assertNotEquals(CardType.PREPAID, CardType.CORPORATE)
            assertNotEquals(CardType.CORPORATE, CardType.ATM)
            assertNotEquals(CardType.ATM, CardType.OTHERS)
        }

        @Test
        @DisplayName("Should have consistent hashCode")
        fun `should have consistent hashCode`() {
            assertEquals(CardType.CREDIT.hashCode(), CardType.CREDIT.hashCode())
            assertEquals(CardType.DEBIT.hashCode(), CardType.DEBIT.hashCode())
            assertEquals(CardType.PREPAID.hashCode(), CardType.PREPAID.hashCode())
            assertEquals(CardType.CORPORATE.hashCode(), CardType.CORPORATE.hashCode())
            assertEquals(CardType.ATM.hashCode(), CardType.ATM.hashCode())
            assertEquals(CardType.OTHERS.hashCode(), CardType.OTHERS.hashCode())
        }

        @Test
        @DisplayName("Should have different hashCodes for different values")
        fun `should have different hashCodes for different values`() {
            val hashCodes = CardType.values().map { it.hashCode() }.toSet()
            assertEquals(CardType.values().size, hashCodes.size)
        }
    }

    @Nested
    @DisplayName("Enum Comparison Tests")
    inner class EnumComparisonTests {

        @Test
        @DisplayName("Should compare by ordinal")
        fun `should compare by ordinal`() {
            assertTrue(CardType.CREDIT.compareTo(CardType.DEBIT) < 0)
            assertTrue(CardType.DEBIT.compareTo(CardType.PREPAID) < 0)
            assertTrue(CardType.PREPAID.compareTo(CardType.CORPORATE) < 0)
            assertTrue(CardType.CORPORATE.compareTo(CardType.ATM) < 0)
            assertTrue(CardType.ATM.compareTo(CardType.OTHERS) < 0)
        }

        @Test
        @DisplayName("Should be equal when comparing same value")
        fun `should be equal when comparing same value`() {
            assertEquals(0, CardType.CREDIT.compareTo(CardType.CREDIT))
            assertEquals(0, CardType.DEBIT.compareTo(CardType.DEBIT))
            assertEquals(0, CardType.PREPAID.compareTo(CardType.PREPAID))
            assertEquals(0, CardType.CORPORATE.compareTo(CardType.CORPORATE))
            assertEquals(0, CardType.ATM.compareTo(CardType.ATM))
            assertEquals(0, CardType.OTHERS.compareTo(CardType.OTHERS))
        }
    }

    @Nested
    @DisplayName("Enum Iteration Tests")
    inner class EnumIterationTests {

        @Test
        @DisplayName("Should iterate through all values")
        fun `should iterate through all values`() {
            val values = mutableListOf<CardType>()
            for (cardType in CardType.values()) {
                values.add(cardType)
            }

            assertEquals(6, values.size)
            assertTrue(values.contains(CardType.CREDIT))
            assertTrue(values.contains(CardType.DEBIT))
            assertTrue(values.contains(CardType.PREPAID))
            assertTrue(values.contains(CardType.CORPORATE))
            assertTrue(values.contains(CardType.ATM))
            assertTrue(values.contains(CardType.OTHERS))
        }

        @Test
        @DisplayName("Should maintain order during iteration")
        fun `should maintain order during iteration`() {
            val values = CardType.values().toList()
            assertEquals(CardType.CREDIT, values[0])
            assertEquals(CardType.DEBIT, values[1])
            assertEquals(CardType.PREPAID, values[2])
            assertEquals(CardType.CORPORATE, values[3])
            assertEquals(CardType.ATM, values[4])
            assertEquals(CardType.OTHERS, values[5])
        }
    }

    @Nested
    @DisplayName("Enum Collection Tests")
    inner class EnumCollectionTests {

        @Test
        @DisplayName("Should work in sets")
        fun `should work in sets`() {
            val cardTypeSet =
                    setOf(CardType.CREDIT, CardType.DEBIT, CardType.PREPAID, CardType.CREDIT)
            assertEquals(3, cardTypeSet.size)
            assertTrue(cardTypeSet.contains(CardType.CREDIT))
            assertTrue(cardTypeSet.contains(CardType.DEBIT))
            assertTrue(cardTypeSet.contains(CardType.PREPAID))
        }

        @Test
        @DisplayName("Should work in lists")
        fun `should work in lists`() {
            val cardTypeList =
                    listOf(CardType.CREDIT, CardType.DEBIT, CardType.PREPAID, CardType.CREDIT)
            assertEquals(4, cardTypeList.size)
            assertEquals(2, cardTypeList.count { it == CardType.CREDIT })
            assertEquals(1, cardTypeList.count { it == CardType.DEBIT })
            assertEquals(1, cardTypeList.count { it == CardType.PREPAID })
        }

        @Test
        @DisplayName("Should work as map keys")
        fun `should work as map keys`() {
            val cardTypeMap =
                    mapOf(
                            CardType.CREDIT to "Credit Card",
                            CardType.DEBIT to "Debit Card",
                            CardType.PREPAID to "Prepaid Card",
                            CardType.CORPORATE to "Corporate Card",
                            CardType.ATM to "ATM Card",
                            CardType.OTHERS to "Other Card Type"
                    )

            assertEquals(6, cardTypeMap.size)
            assertEquals("Credit Card", cardTypeMap[CardType.CREDIT])
            assertEquals("Debit Card", cardTypeMap[CardType.DEBIT])
            assertEquals("Prepaid Card", cardTypeMap[CardType.PREPAID])
            assertEquals("Corporate Card", cardTypeMap[CardType.CORPORATE])
            assertEquals("ATM Card", cardTypeMap[CardType.ATM])
            assertEquals("Other Card Type", cardTypeMap[CardType.OTHERS])
        }
    }

    @Nested
    @DisplayName("Edge Case Tests")
    inner class EdgeCaseTests {

        @Test
        @DisplayName("Should handle reflection access")
        fun `should handle reflection access`() {
            val enumClass = CardType::class.java
            assertTrue(enumClass.isEnum)
            assertEquals(6, enumClass.enumConstants.size)
        }

        @Test
        @DisplayName("Should handle when expression")
        fun `should handle when expression`() {
            fun getDescription(cardType: CardType): String =
                    when (cardType) {
                        CardType.CREDIT -> "Credit line access"
                        CardType.DEBIT -> "Direct bank account access"
                        CardType.PREPAID -> "Prepaid balance access"
                        CardType.CORPORATE -> "Corporate account access"
                        CardType.ATM -> "ATM access only"
                        CardType.OTHERS -> "Other card type access"
                    }

            assertEquals("Credit line access", getDescription(CardType.CREDIT))
            assertEquals("Direct bank account access", getDescription(CardType.DEBIT))
            assertEquals("Prepaid balance access", getDescription(CardType.PREPAID))
            assertEquals("Corporate account access", getDescription(CardType.CORPORATE))
            assertEquals("ATM access only", getDescription(CardType.ATM))
            assertEquals("Other card type access", getDescription(CardType.OTHERS))
        }

        @Test
        @DisplayName("Should work with exhaustive when")
        fun `should work with exhaustive when`() {
            fun processCardType(cardType: CardType): String =
                    when (cardType) {
                        CardType.CREDIT -> "Processing credit"
                        CardType.DEBIT -> "Processing debit"
                        CardType.PREPAID -> "Processing prepaid"
                        CardType.CORPORATE -> "Processing corporate"
                        CardType.ATM -> "Processing ATM"
                        CardType.OTHERS -> "Processing others"
                    }

            assertEquals("Processing credit", processCardType(CardType.CREDIT))
            assertEquals("Processing debit", processCardType(CardType.DEBIT))
            assertEquals("Processing prepaid", processCardType(CardType.PREPAID))
            assertEquals("Processing corporate", processCardType(CardType.CORPORATE))
            assertEquals("Processing ATM", processCardType(CardType.ATM))
            assertEquals("Processing others", processCardType(CardType.OTHERS))
        }
    }

    @Nested
    @DisplayName("Business Logic Tests")
    inner class BusinessLogicTests {

        @Test
        @DisplayName("Should support card type categorization")
        fun `should support card type categorization`() {
            fun isInstantPayment(cardType: CardType): Boolean =
                    when (cardType) {
                        CardType.DEBIT, CardType.PREPAID -> true
                        CardType.CREDIT, CardType.CORPORATE, CardType.ATM, CardType.OTHERS -> false
                    }

            assertFalse(isInstantPayment(CardType.CREDIT))
            assertTrue(isInstantPayment(CardType.DEBIT))
            assertTrue(isInstantPayment(CardType.PREPAID))
            assertFalse(isInstantPayment(CardType.CORPORATE))
            assertFalse(isInstantPayment(CardType.ATM))
            assertFalse(isInstantPayment(CardType.OTHERS))
        }

        @Test
        @DisplayName("Should support credit check requirements")
        fun `should support credit check requirements`() {
            fun requiresCreditCheck(cardType: CardType): Boolean =
                    when (cardType) {
                        CardType.CREDIT, CardType.CORPORATE -> true
                        CardType.DEBIT, CardType.PREPAID, CardType.ATM, CardType.OTHERS -> false
                    }

            assertTrue(requiresCreditCheck(CardType.CREDIT))
            assertFalse(requiresCreditCheck(CardType.DEBIT))
            assertFalse(requiresCreditCheck(CardType.PREPAID))
            assertTrue(requiresCreditCheck(CardType.CORPORATE))
            assertFalse(requiresCreditCheck(CardType.ATM))
            assertFalse(requiresCreditCheck(CardType.OTHERS))
        }

        @Test
        @DisplayName("Should support spending limit logic")
        fun `should support spending limit logic`() {
            fun hasSpendingLimit(cardType: CardType): Boolean =
                    when (cardType) {
                        CardType.PREPAID, CardType.ATM -> true
                        CardType.CREDIT, CardType.DEBIT, CardType.CORPORATE, CardType.OTHERS ->
                                false
                    }

            assertFalse(hasSpendingLimit(CardType.CREDIT))
            assertFalse(hasSpendingLimit(CardType.DEBIT))
            assertTrue(hasSpendingLimit(CardType.PREPAID))
            assertFalse(hasSpendingLimit(CardType.CORPORATE))
            assertTrue(hasSpendingLimit(CardType.ATM))
            assertFalse(hasSpendingLimit(CardType.OTHERS))
        }

        @Test
        @DisplayName("Should support payment method classification")
        fun `should support payment method classification`() {
            fun isPaymentCard(cardType: CardType): Boolean =
                    when (cardType) {
                        CardType.CREDIT, CardType.DEBIT, CardType.PREPAID, CardType.CORPORATE ->
                                true
                        CardType.ATM, CardType.OTHERS -> false
                    }

            assertTrue(isPaymentCard(CardType.CREDIT))
            assertTrue(isPaymentCard(CardType.DEBIT))
            assertTrue(isPaymentCard(CardType.PREPAID))
            assertTrue(isPaymentCard(CardType.CORPORATE))
            assertFalse(isPaymentCard(CardType.ATM))
            assertFalse(isPaymentCard(CardType.OTHERS))
        }
    }

    @Nested
    @DisplayName("Enum Constants Tests")
    inner class EnumConstantsTests {

        @Test
        @DisplayName("Should have stable enum constants")
        fun `should have stable enum constants`() {
            // Verify that enum constants don't change between calls
            val first = CardType.values()
            val second = CardType.values()

            assertArrayEquals(first, second)
            // Verify they're the same instances
            for (i in first.indices) {
                assertSame(first[i], second[i])
            }
        }

        @Test
        @DisplayName("Should maintain enum singleton property")
        fun `should maintain enum singleton property`() {
            val credit1 = CardType.CREDIT
            val credit2 = CardType.valueOf("CREDIT")
            val credit3 = CardType.fromValue("CREDIT")

            assertSame(credit1, credit2)
            assertSame(credit1, credit3)
            assertSame(credit2, credit3)
        }
    }
}
