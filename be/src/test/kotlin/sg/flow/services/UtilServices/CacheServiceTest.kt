package sg.flow.services.UtilServices

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("CacheService Tests")
class CacheServiceTest {

    private lateinit var cacheService: CacheService

    @BeforeEach
    fun setUp() {
        // Using a simple mock implementation for testing the interface
        cacheService = MockCacheServiceImpl()
    }

    @Nested
    @DisplayName("Interface Contract Tests")
    inner class InterfaceContractTests {

        @Test
        @DisplayName("Should store and retrieve access token")
        fun shouldStoreAndRetrieveAccessToken() {
            val userId = 123
            val accessToken = "test-access-token"

            cacheService.storeAccessToken(userId, accessToken)
            val result = cacheService.getUserIdByAccessToken(accessToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should return empty optional for non-existent token")
        fun shouldReturnEmptyOptionalForNonExistentToken() {
            val result = cacheService.getUserIdByAccessToken("non-existent-token")

            assertFalse(result.isPresent)
        }

        @Test
        @DisplayName("Should store and retrieve login identity ID")
        fun shouldStoreAndRetrieveLoginIdentityId() {
            val loginIdentityId = "login-id-123"
            val userId = 456

            cacheService.storeUserIdByLoginIdentityId(loginIdentityId, userId)
            val result = cacheService.getUserIdByLoginIdentityId(loginIdentityId)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should return empty optional for non-existent login identity ID")
        fun shouldReturnEmptyOptionalForNonExistentLoginIdentityId() {
            val result = cacheService.getUserIdByLoginIdentityId("non-existent-login-id")

            assertFalse(result.isPresent)
        }

        @Test
        @DisplayName("Should handle null and empty values gracefully")
        fun shouldHandleNullAndEmptyValuesGracefully() {
            val emptyResult = cacheService.getUserIdByAccessToken("")
            assertFalse(emptyResult.isPresent)

            val emptyLoginResult = cacheService.getUserIdByLoginIdentityId("")
            assertFalse(emptyLoginResult.isPresent)
        }

        @Test
        @DisplayName("Should overwrite existing entries")
        fun shouldOverwriteExistingEntries() {
            val accessToken = "test-token"
            val userId1 = 123
            val userId2 = 456

            cacheService.storeAccessToken(userId1, accessToken)
            val result1 = cacheService.getUserIdByAccessToken(accessToken)
            assertEquals(userId1, result1.get())

            cacheService.storeAccessToken(userId2, accessToken)
            val result2 = cacheService.getUserIdByAccessToken(accessToken)
            assertEquals(userId2, result2.get())
        }
    }

    @Nested
    @DisplayName("Edge Cases Tests")
    inner class EdgeCasesTests {

        @Test
        @DisplayName("Should handle negative user IDs")
        fun shouldHandleNegativeUserIds() {
            val negativeUserId = -1
            val accessToken = "negative-test-token"

            cacheService.storeAccessToken(negativeUserId, accessToken)
            val result = cacheService.getUserIdByAccessToken(accessToken)

            assertTrue(result.isPresent)
            assertEquals(negativeUserId, result.get())
        }

        @Test
        @DisplayName("Should handle zero user ID")
        fun shouldHandleZeroUserId() {
            val zeroUserId = 0
            val accessToken = "zero-test-token"

            cacheService.storeAccessToken(zeroUserId, accessToken)
            val result = cacheService.getUserIdByAccessToken(accessToken)

            assertTrue(result.isPresent)
            assertEquals(zeroUserId, result.get())
        }

        @Test
        @DisplayName("Should handle special characters in tokens")
        fun shouldHandleSpecialCharactersInTokens() {
            val userId = 789
            val specialToken = "token-with-éñ@#$%^&*()"

            cacheService.storeAccessToken(userId, specialToken)
            val result = cacheService.getUserIdByAccessToken(specialToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }

        @Test
        @DisplayName("Should handle very long tokens")
        fun shouldHandleVeryLongTokens() {
            val userId = 999
            val longToken = "a".repeat(10000)

            cacheService.storeAccessToken(userId, longToken)
            val result = cacheService.getUserIdByAccessToken(longToken)

            assertTrue(result.isPresent)
            assertEquals(userId, result.get())
        }
    }
}
