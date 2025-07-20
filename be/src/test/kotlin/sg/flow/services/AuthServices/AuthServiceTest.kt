package sg.flow.services.AuthServices

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Test
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest

@DisplayName("AuthService Tests - Basic")
class AuthServiceTest {

    @Test
    @DisplayName("Should compile basic test")
    fun `should compile basic test`() {
        val authRequest = AuthRequest("test", "password")
        assertEquals("test", authRequest.username)
        assertEquals("password", authRequest.password)
    }

    @Test
    @DisplayName("Should test token refresh request")
    fun `should test token refresh request`() {
        val refreshRequest = AccessTokenRefreshRequest("refresh-token")
        assertEquals("refresh-token", refreshRequest.refreshToken)
    }
}
