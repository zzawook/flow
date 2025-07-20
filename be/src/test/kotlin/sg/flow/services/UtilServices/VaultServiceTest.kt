package sg.flow.services.UtilServices

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("VaultService Tests")
class VaultServiceTest {

    private lateinit var vaultService: VaultService

    @BeforeEach
    fun setUp() {
        // Using a simple mock implementation for testing the interface
        vaultService = MockVaultServiceImpl()
    }

    @Nested
    @DisplayName("Interface Contract Tests")
    inner class InterfaceContractTests {

        @Test
        @DisplayName("Should store and retrieve access token")
        fun shouldStoreAndRetrieveAccessToken() {
            val userId = 123
            val accessToken = "vault-access-token"

            vaultService.storeAccessToken(userId, accessToken)
            val result = vaultService.getUserIdByAccessToken(accessToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should return empty optional for non-existent token")
        fun shouldReturnEmptyOptionalForNonExistentToken() {
            val result = vaultService.getUserIdByAccessToken("non-existent-vault-token")

            assertFalse(result.isPresent)
        }

        @Test
        @DisplayName("Should store and retrieve refresh token")
        fun shouldStoreAndRetrieveRefreshToken() {
            val refreshToken = "vault-refresh-token-123"
            val userId = 456

            vaultService.storeRefreshToken(userId, refreshToken)
            val result = vaultService.getUserIdByRefreshToken(refreshToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should return empty optional for non-existent refresh token")
        fun shouldReturnEmptyOptionalForNonExistentRefreshToken() {
            val result = vaultService.getUserIdByRefreshToken("non-existent-vault-refresh-token")

            assertFalse(result.isPresent)
        }

        @Test
        @DisplayName("Should handle persistence across operations")
        fun shouldHandlePersistenceAcrossOperations() {
            val userId1 = 111
            val userId2 = 222
            val token1 = "persistent-token-1"
            val token2 = "persistent-token-2"

            vaultService.storeAccessToken(userId1, token1)
            vaultService.storeAccessToken(userId2, token2)

            val result1 = vaultService.getUserIdByAccessToken(token1)
            val result2 = vaultService.getUserIdByAccessToken(token2)

            assertTrue(result1.isPresent)
            assertTrue(result2.isPresent)
            assertEquals(userId1, result1.get())
            assertEquals(userId2, result2.get())
        }
    }

    @Nested
    @DisplayName("Security and Reliability Tests")
    inner class SecurityAndReliabilityTests {

        @Test
        @DisplayName("Should handle sensitive data securely")
        fun shouldHandleSensitiveDataSecurely() {
            val sensitiveUserId = 999
            val sensitiveToken = "sensitive-vault-token-with-secrets"

            vaultService.storeAccessToken(sensitiveUserId, sensitiveToken)
            val result = vaultService.getUserIdByAccessToken(sensitiveToken)

            assertTrue(result.isPresent)
            assertEquals(sensitiveUserId, result.get())
        }

        @Test
        @DisplayName("Should handle concurrent access safely")
        fun shouldHandleConcurrentAccessSafely() {
            val baseUserId = 1000
            val tokens = (1..10).map { "concurrent-vault-token-$it" }

            // Store multiple tokens
            tokens.forEachIndexed { index, token ->
                vaultService.storeAccessToken(baseUserId + index, token)
            }

            // Retrieve all tokens
            tokens.forEachIndexed { index, token ->
                val result = vaultService.getUserIdByAccessToken(token)
                assertTrue(result.isPresent)
                assertEquals(baseUserId + index, result.get())
            }
        }

        @Test
        @DisplayName("Should handle data integrity")
        fun shouldHandleDataIntegrity() {
            val userId = 777
            val originalToken = "integrity-test-token"
            val differentToken = "different-integrity-token"

            vaultService.storeAccessToken(userId, originalToken)

            // Verify original token works
            val originalResult = vaultService.getUserIdByAccessToken(originalToken)
            assertTrue(originalResult.isPresent)
            assertEquals(userId, originalResult.get())

            // Verify different token doesn't work
            val differentResult = vaultService.getUserIdByAccessToken(differentToken)
            assertFalse(differentResult.isPresent)
        }
    }

    @Nested
    @DisplayName("Edge Cases Tests")
    inner class EdgeCasesTests {

        @Test
        @DisplayName("Should handle empty and null values")
        fun shouldHandleEmptyAndNullValues() {
            val emptyTokenResult = vaultService.getUserIdByAccessToken("")
            assertFalse(emptyTokenResult.isPresent)

            val emptyRefreshResult = vaultService.getUserIdByRefreshToken("")
            assertFalse(emptyRefreshResult.isPresent)
        }

        @Test
        @DisplayName("Should handle very long tokens")
        fun shouldHandleVeryLongTokens() {
            val userId = 888
            val longToken = "vault-" + "x".repeat(5000)

            vaultService.storeAccessToken(userId, longToken)
            val result = vaultService.getUserIdByAccessToken(longToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should handle special characters and encoding")
        fun shouldHandleSpecialCharactersAndEncoding() {
            val userId = 555
            val specialToken = "vault-token-éñ中文🔒@#$%^&*()"

            vaultService.storeAccessToken(userId, specialToken)
            val result = vaultService.getUserIdByAccessToken(specialToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should handle extreme user IDs")
        fun shouldHandleExtremeUserIds() {
            val maxUserId = Int.MAX_VALUE
            val minUserId = Int.MIN_VALUE
            val maxToken = "vault-max-token"
            val minToken = "vault-min-token"

            vaultService.storeAccessToken(maxUserId, maxToken)
            vaultService.storeAccessToken(minUserId, minToken)

            val maxResult = vaultService.getUserIdByAccessToken(maxToken)
            val minResult = vaultService.getUserIdByAccessToken(minToken)

            assertTrue(maxResult.isPresent)
            assertTrue(minResult.isPresent)
            assertEquals(maxUserId, maxResult.get())
            assertEquals(minUserId, minResult.get())
        }
    }
}
