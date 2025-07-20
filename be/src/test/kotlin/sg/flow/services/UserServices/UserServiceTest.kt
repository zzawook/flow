package sg.flow.services.UserServices

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import sg.flow.models.user.UpdateUserProfile

@DisplayName("UserService Tests - Basic")
class UserServiceTest {

    @Test
    @DisplayName("Should test UpdateUserProfile model")
    fun `should test UpdateUserProfile model`() {
        val updateProfile =
                UpdateUserProfile(
                        name = "Updated Name",
                        email = "updated@email.com",
                        identificationNumber = "S9876543Z",
                        phoneNumber = "+65 9876 5432"
                )

        assertEquals("Updated Name", updateProfile.name)
        assertEquals("updated@email.com", updateProfile.email)
        assertEquals("S9876543Z", updateProfile.identificationNumber)
        assertEquals("+65 9876 5432", updateProfile.phoneNumber)
    }

    @Test
    @DisplayName("Should handle null values in UpdateUserProfile")
    fun `should handle null values in UpdateUserProfile`() {
        val updateProfile =
                UpdateUserProfile(
                        name = null,
                        email = null,
                        identificationNumber = null,
                        phoneNumber = null
                )

        assertNull(updateProfile.name)
        assertNull(updateProfile.email)
        assertNull(updateProfile.identificationNumber)
        assertNull(updateProfile.phoneNumber)
    }

    @Test
    @DisplayName("Should handle partial updates in UpdateUserProfile")
    fun `should handle partial updates in UpdateUserProfile`() {
        val updateProfile =
                UpdateUserProfile(
                        name = "Only Name Updated",
                        email = null,
                        identificationNumber = null,
                        phoneNumber = "+65 1111 2222"
                )

        assertEquals("Only Name Updated", updateProfile.name)
        assertNull(updateProfile.email)
        assertNull(updateProfile.identificationNumber)
        assertEquals("+65 1111 2222", updateProfile.phoneNumber)
    }
}
