package sg.flow.entities

import jakarta.validation.Validation
import jakarta.validation.Validator
import java.time.LocalDate
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("User Entity Tests")
class UserTest {

    private lateinit var validator: Validator

    @BeforeEach
    fun setup() {
        val factory = Validation.buildDefaultValidatorFactory()
        validator = factory.validator
    }

    @Nested
    @DisplayName("Valid User Creation")
    inner class ValidUserCreation {

        @Test
        @DisplayName("Should create user with all valid fields")
        fun shouldCreateUserWithValidFields() {
            val user =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john.doe@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street, Singapore 123456",
                            settingJson = """{"theme": "dark", "notifications": true}"""
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())

            assertEquals(1, user.id)
            assertEquals("John Doe", user.name)
            assertEquals("john.doe@example.com", user.email)
            assertEquals("S1234567A", user.identificationNumber)
            assertEquals("+65-91234567", user.phoneNumber)
            assertEquals(LocalDate.of(1990, 5, 15), user.dateOfBirth)
            assertEquals("123 Main Street, Singapore 123456", user.address)
            assertEquals("""{"theme": "dark", "notifications": true}""", user.settingJson)
        }

        @Test
        @DisplayName("Should create user with null ID")
        fun shouldCreateUserWithNullId() {
            val user =
                    User(
                            id = null,
                            name = "Jane Doe",
                            email = "jane.doe@example.com",
                            identificationNumber = "S7654321B",
                            phoneNumber = "+65-98765432",
                            dateOfBirth = LocalDate.of(1985, 12, 25),
                            address = "456 Second Street, Singapore 654321"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertNull(user.id)
        }

        @Test
        @DisplayName("Should create user with default empty JSON settings")
        fun shouldCreateUserWithDefaultSettingJson() {
            val user =
                    User(
                            id = 2,
                            name = "Default User",
                            email = "default@example.com",
                            identificationNumber = "S1111111C",
                            phoneNumber = "+65-11111111",
                            dateOfBirth = LocalDate.of(1995, 1, 1),
                            address = "Default Address"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertEquals("{}", user.settingJson)
        }
    }

    @Nested
    @DisplayName("Name Validation")
    inner class NameValidation {

        @Test
        @DisplayName("Should reject user with empty name")
        fun shouldRejectEmptyName() {
            val user =
                    User(
                            id = 1,
                            name = "",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "name" })
        }

        @Test
        @DisplayName("Should reject user with blank name")
        fun shouldRejectBlankName() {
            val user =
                    User(
                            id = 1,
                            name = "   ",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "name" })
        }

        @Test
        @DisplayName("Should accept user with special characters in name")
        fun shouldAcceptNameWithSpecialCharacters() {
            val user =
                    User(
                            id = 1,
                            name = "José María O'Connor-Smith",
                            email = "jose@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept very long name")
        fun shouldAcceptVeryLongName() {
            val longName = "A".repeat(500)
            val user =
                    User(
                            id = 1,
                            name = longName,
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertEquals(longName, user.name)
        }
    }

    @Nested
    @DisplayName("Email Validation")
    inner class EmailValidation {

        @Test
        @DisplayName("Should reject user with empty email")
        fun shouldRejectEmptyEmail() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "email" })
        }

        @Test
        @DisplayName("Should accept various email formats")
        fun shouldAcceptVariousEmailFormats() {
            val validEmails =
                    listOf(
                            "simple@example.com",
                            "test.email@domain.co.uk",
                            "user+tag@example.org",
                            "user123@sub.domain.com",
                            "a@b.co"
                    )

            validEmails.forEach { email ->
                val user =
                        User(
                                id = 1,
                                name = "Test User",
                                email = email,
                                identificationNumber = "S1234567A",
                                phoneNumber = "+65-91234567",
                                dateOfBirth = LocalDate.of(1990, 5, 15),
                                address = "Test Address"
                        )

                val violations = validator.validate(user)
                assertTrue(violations.isEmpty(), "Email $email should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Identification Number Validation")
    inner class IdentificationNumberValidation {

        @Test
        @DisplayName("Should reject empty identification number")
        fun shouldRejectEmptyIdentificationNumber() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "identificationNumber" })
        }

        @Test
        @DisplayName("Should accept various identification number formats")
        fun shouldAcceptVariousIdFormats() {
            val validIds = listOf("S1234567A", "T9876543Z", "G1111111M", "F5555555N", "M1234567K")

            validIds.forEach { idNumber ->
                val user =
                        User(
                                id = 1,
                                name = "Test User",
                                email = "test@example.com",
                                identificationNumber = idNumber,
                                phoneNumber = "+65-91234567",
                                dateOfBirth = LocalDate.of(1990, 5, 15),
                                address = "Test Address"
                        )

                val violations = validator.validate(user)
                assertTrue(violations.isEmpty(), "ID $idNumber should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Phone Number Validation")
    inner class PhoneNumberValidation {

        @Test
        @DisplayName("Should reject empty phone number")
        fun shouldRejectEmptyPhoneNumber() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "phoneNumber" })
        }

        @Test
        @DisplayName("Should accept various phone number formats")
        fun shouldAcceptVariousPhoneFormats() {
            val validPhones =
                    listOf(
                            "+65-91234567",
                            "+1-555-123-4567",
                            "+44-20-7946-0958",
                            "91234567",
                            "+65 9123 4567",
                            "+65.9123.4567"
                    )

            validPhones.forEach { phoneNumber ->
                val user =
                        User(
                                id = 1,
                                name = "Test User",
                                email = "test@example.com",
                                identificationNumber = "S1234567A",
                                phoneNumber = phoneNumber,
                                dateOfBirth = LocalDate.of(1990, 5, 15),
                                address = "Test Address"
                        )

                val violations = validator.validate(user)
                assertTrue(violations.isEmpty(), "Phone $phoneNumber should be valid")
            }
        }
    }

    @Nested
    @DisplayName("Date of Birth Validation")
    inner class DateOfBirthValidation {

        @Test
        @DisplayName("Should accept past dates")
        fun shouldAcceptPastDates() {
            val pastDates =
                    listOf(
                            LocalDate.of(1950, 1, 1),
                            LocalDate.of(1990, 6, 15),
                            LocalDate.of(2000, 12, 31),
                            LocalDate.now().minusYears(18)
                    )

            pastDates.forEach { date ->
                val user =
                        User(
                                id = 1,
                                name = "Test User",
                                email = "test@example.com",
                                identificationNumber = "S1234567A",
                                phoneNumber = "+65-91234567",
                                dateOfBirth = date,
                                address = "Test Address"
                        )

                val violations = validator.validate(user)
                assertTrue(violations.isEmpty(), "Date $date should be valid")
            }
        }

        @Test
        @DisplayName("Should accept today as birth date")
        fun shouldAcceptTodayAsBirthDate() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.now(),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept future dates")
        fun shouldAcceptFutureDates() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.now().plusDays(1),
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            // Note: We accept future dates as there might be business logic to handle this
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should accept leap year dates")
        fun shouldAcceptLeapYearDates() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(2000, 2, 29), // Leap year
                            address = "Test Address"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("Address Validation")
    inner class AddressValidation {

        @Test
        @DisplayName("Should reject empty address")
        fun shouldRejectEmptyAddress() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = ""
                    )

            val violations = validator.validate(user)
            assertFalse(violations.isEmpty())
            assertTrue(violations.any { it.propertyPath.toString() == "address" })
        }

        @Test
        @DisplayName("Should accept multiline addresses")
        fun shouldAcceptMultilineAddresses() {
            val multilineAddress =
                    """
                123 Main Street
                Apartment 4B
                Singapore 123456
                Republic of Singapore
            """.trimIndent()

            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = multilineAddress
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertEquals(multilineAddress, user.address)
        }

        @Test
        @DisplayName("Should accept addresses with special characters")
        fun shouldAcceptAddressesWithSpecialCharacters() {
            val specialAddress =
                    "123 Main St. #04-567, Block A, Building @ Complex, Singapore 123456"

            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = specialAddress
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("Settings JSON Validation")
    inner class SettingsJsonValidation {

        @Test
        @DisplayName("Should accept valid JSON")
        fun shouldAcceptValidJson() {
            val validJsonSettings =
                    listOf(
                            "{}",
                            """{"theme": "dark"}""",
                            """{"notifications": true, "language": "en"}""",
                            """{"preferences": {"theme": "light", "notifications": {"email": true, "sms": false}}}"""
                    )

            validJsonSettings.forEach { json ->
                val user =
                        User(
                                id = 1,
                                name = "Test User",
                                email = "test@example.com",
                                identificationNumber = "S1234567A",
                                phoneNumber = "+65-91234567",
                                dateOfBirth = LocalDate.of(1990, 5, 15),
                                address = "Test Address",
                                settingJson = json
                        )

                val violations = validator.validate(user)
                assertTrue(violations.isEmpty(), "JSON $json should be valid")
                assertEquals(json, user.settingJson)
            }
        }

        @Test
        @DisplayName("Should accept empty string as settings JSON")
        fun shouldAcceptEmptyStringAsSettingsJson() {
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address",
                            settingJson = ""
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertEquals("", user.settingJson)
        }

        @Test
        @DisplayName("Should accept non-JSON string as settings")
        fun shouldAcceptNonJsonStringAsSettings() {
            // Note: The entity doesn't validate JSON format, so any string should be accepted
            val user =
                    User(
                            id = 1,
                            name = "Test User",
                            email = "test@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "Test Address",
                            settingJson = "not a json string"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
            assertEquals("not a json string", user.settingJson)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Boundary Conditions")
    inner class EdgeCasesAndBoundaryConditions {

        @Test
        @DisplayName("Should handle minimum valid data")
        fun shouldHandleMinimumValidData() {
            val user =
                    User(
                            id = null,
                            name = "A",
                            email = "a@b.c",
                            identificationNumber = "1",
                            phoneNumber = "1",
                            dateOfBirth = LocalDate.of(1, 1, 1),
                            address = "A"
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle maximum reasonable data lengths")
        fun shouldHandleMaximumReasonableDataLengths() {
            val longString = "A".repeat(1000)
            val user =
                    User(
                            id = Int.MAX_VALUE,
                            name = longString,
                            email = "$longString@$longString.com",
                            identificationNumber = longString,
                            phoneNumber = longString,
                            dateOfBirth = LocalDate.of(9999, 12, 31),
                            address = longString,
                            settingJson = """{"data": "$longString"}"""
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }

        @Test
        @DisplayName("Should handle Unicode characters in all fields")
        fun shouldHandleUnicodeCharacters() {
            val user =
                    User(
                            id = 1,
                            name = "测试用户 🙋‍♀️",
                            email = "测试@example.中国",
                            identificationNumber = "测试123",
                            phoneNumber = "+65-测试123",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 测试街道, 新加坡 🇸🇬",
                            settingJson = """{"theme": "测试主题", "emoji": "🎉"}"""
                    )

            val violations = validator.validate(user)
            assertTrue(violations.isEmpty())
        }
    }

    @Nested
    @DisplayName("Data Class Behavior")
    inner class DataClassBehavior {

        @Test
        @DisplayName("Should implement equals correctly")
        fun shouldImplementEqualsCorrectly() {
            val user1 =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            val user2 =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            val user3 =
                    User(
                            id = 2,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            assertEquals(user1, user2)
            assertNotEquals(user1, user3)
        }

        @Test
        @DisplayName("Should implement hashCode correctly")
        fun shouldImplementHashCodeCorrectly() {
            val user1 =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            val user2 =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            assertEquals(user1.hashCode(), user2.hashCode())
        }

        @Test
        @DisplayName("Should implement toString correctly")
        fun shouldImplementToStringCorrectly() {
            val user =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            val toString = user.toString()
            assertTrue(toString.contains("User"))
            assertTrue(toString.contains("John Doe"))
            assertTrue(toString.contains("john@example.com"))
        }

        @Test
        @DisplayName("Should support copy with modifications")
        fun shouldSupportCopyWithModifications() {
            val originalUser =
                    User(
                            id = 1,
                            name = "John Doe",
                            email = "john@example.com",
                            identificationNumber = "S1234567A",
                            phoneNumber = "+65-91234567",
                            dateOfBirth = LocalDate.of(1990, 5, 15),
                            address = "123 Main Street",
                            settingJson = "{}"
                    )

            val copiedUser = originalUser.copy(name = "Jane Doe", email = "jane@example.com")

            assertEquals(1, copiedUser.id)
            assertEquals("Jane Doe", copiedUser.name)
            assertEquals("jane@example.com", copiedUser.email)
            assertEquals("S1234567A", copiedUser.identificationNumber)
            assertEquals("+65-91234567", copiedUser.phoneNumber)
            assertEquals(LocalDate.of(1990, 5, 15), copiedUser.dateOfBirth)
            assertEquals("123 Main Street", copiedUser.address)
            assertEquals("{}", copiedUser.settingJson)
        }
    }
}
