package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test

@DisplayName("FinverseAuthCache Tests")
class FinverseAuthCacheTest {

    private lateinit var finverseAuthCache: FinverseAuthCache

    @BeforeEach
    fun setUp() {
        finverseAuthCache = FinverseAuthCache()
    }

    @Nested
    @DisplayName("Save and Retrieve Login Identity Token Tests")
    inner class SaveAndRetrieveTokenTests {

        @Test
        @DisplayName("Should save and retrieve login identity token successfully")
        fun shouldSaveAndRetrieveTokenSuccessfully() = runTest {
            val userId = 123
            val institutionId = "dbs-bank"
            val loginIdentityId = "login-id-123"
            val loginIdentityToken = "token-abc-123"

            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    institutionId,
                    loginIdentityId,
                    loginIdentityToken
            )

            val credential = finverseAuthCache.getLoginIdentityCredential(userId, institutionId)

            assertNotNull(credential)
            assertEquals(loginIdentityId, credential!!.loginIdentityId)
            assertEquals(loginIdentityToken, credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should return null for non-existent user")
        fun shouldReturnNullForNonExistentUser() = runTest {
            val credential = finverseAuthCache.getLoginIdentityCredential(999, "non-existent-bank")
            assertNull(credential)
        }

        @Test
        @DisplayName("Should return null for non-existent institution")
        fun shouldReturnNullForNonExistentInstitution() = runTest {
            finverseAuthCache.saveLoginIdentityToken(123, "dbs-bank", "login-id", "token")

            val credential = finverseAuthCache.getLoginIdentityCredential(123, "non-existent-bank")
            assertNull(credential)
        }

        @Test
        @DisplayName("Should handle multiple institutions for same user")
        fun shouldHandleMultipleInstitutionsForSameUser() = runTest {
            val userId = 123

            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    "dbs-bank",
                    "dbs-login-id",
                    "dbs-token"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    "ocbc-bank",
                    "ocbc-login-id",
                    "ocbc-token"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    "uob-bank",
                    "uob-login-id",
                    "uob-token"
            )

            val dbsCredential = finverseAuthCache.getLoginIdentityCredential(userId, "dbs-bank")
            val ocbcCredential = finverseAuthCache.getLoginIdentityCredential(userId, "ocbc-bank")
            val uobCredential = finverseAuthCache.getLoginIdentityCredential(userId, "uob-bank")

            assertNotNull(dbsCredential)
            assertEquals("dbs-login-id", dbsCredential!!.loginIdentityId)
            assertEquals("dbs-token", dbsCredential.loginIdentityToken)

            assertNotNull(ocbcCredential)
            assertEquals("ocbc-login-id", ocbcCredential!!.loginIdentityId)
            assertEquals("ocbc-token", ocbcCredential.loginIdentityToken)

            assertNotNull(uobCredential)
            assertEquals("uob-login-id", uobCredential!!.loginIdentityId)
            assertEquals("uob-token", uobCredential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should handle multiple users for same institution")
        fun shouldHandleMultipleUsersForSameInstitution() = runTest {
            val institutionId = "dbs-bank"

            finverseAuthCache.saveLoginIdentityToken(
                    123,
                    institutionId,
                    "login-id-123",
                    "token-123"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    456,
                    institutionId,
                    "login-id-456",
                    "token-456"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    789,
                    institutionId,
                    "login-id-789",
                    "token-789"
            )

            val credential123 = finverseAuthCache.getLoginIdentityCredential(123, institutionId)
            val credential456 = finverseAuthCache.getLoginIdentityCredential(456, institutionId)
            val credential789 = finverseAuthCache.getLoginIdentityCredential(789, institutionId)

            assertNotNull(credential123)
            assertEquals("login-id-123", credential123!!.loginIdentityId)
            assertEquals("token-123", credential123!!.loginIdentityToken)

            assertNotNull(credential456)
            assertEquals("login-id-456", credential456!!.loginIdentityId)
            assertEquals("token-456", credential456!!.loginIdentityToken)

            assertNotNull(credential789)
            assertEquals("login-id-789", credential789!!.loginIdentityId)
            assertEquals("token-789", credential789.loginIdentityToken)
        }

        @Test
        @DisplayName("Should overwrite existing credentials for same user and institution")
        fun shouldOverwriteExistingCredentials() = runTest {
            val userId = 123
            val institutionId = "dbs-bank"

            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    institutionId,
                    "old-login-id",
                    "old-token"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    userId,
                    institutionId,
                    "new-login-id",
                    "new-token"
            )

            val credential = finverseAuthCache.getLoginIdentityCredential(userId, institutionId)

            assertNotNull(credential)
            assertEquals("new-login-id", credential!!.loginIdentityId)
            assertEquals("new-token", credential.loginIdentityToken)
        }
    }

    @Nested
    @DisplayName("Get User ID Tests")
    inner class GetUserIdTests {

        @Test
        @DisplayName("Should return correct user ID for existing login identity ID")
        fun shouldReturnCorrectUserIdForExistingLoginId() = runTest {
            val userId = 123
            val loginIdentityId = "login-id-123"

            finverseAuthCache.saveLoginIdentityToken(userId, "dbs-bank", loginIdentityId, "token")

            val foundUserId = finverseAuthCache.getUserId(loginIdentityId)
            assertEquals(userId, foundUserId)
        }

        @Test
        @DisplayName("Should return -1 for non-existent login identity ID")
        fun shouldReturnMinusOneForNonExistentLoginId() = runTest {
            val foundUserId = finverseAuthCache.getUserId("non-existent-login-id")
            assertEquals(-1, foundUserId)
        }

        @Test
        @DisplayName("Should find user ID across multiple institutions")
        fun shouldFindUserIdAcrossMultipleInstitutions() = runTest {
            val userId1 = 123
            val userId2 = 456
            val loginIdentityId1 = "login-id-123"
            val loginIdentityId2 = "login-id-456"

            finverseAuthCache.saveLoginIdentityToken(
                    userId1,
                    "dbs-bank",
                    loginIdentityId1,
                    "token1"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    userId1,
                    "ocbc-bank",
                    "other-login-id",
                    "token2"
            )
            finverseAuthCache.saveLoginIdentityToken(
                    userId2,
                    "uob-bank",
                    loginIdentityId2,
                    "token3"
            )

            val foundUserId1 = finverseAuthCache.getUserId(loginIdentityId1)
            val foundUserId2 = finverseAuthCache.getUserId(loginIdentityId2)

            assertEquals(userId1, foundUserId1)
            assertEquals(userId2, foundUserId2)
        }

        @Test
        @DisplayName("Should handle duplicate login identity IDs across different users")
        fun shouldHandleDuplicateLoginIdentityIds() = runTest {
            val duplicateLoginId = "duplicate-login-id"

            finverseAuthCache.saveLoginIdentityToken(123, "dbs-bank", duplicateLoginId, "token1")
            finverseAuthCache.saveLoginIdentityToken(456, "ocbc-bank", duplicateLoginId, "token2")

            val foundUserId = finverseAuthCache.getUserId(duplicateLoginId)

            // Should return the first one found (order may vary due to HashMap iteration)
            assert(foundUserId == 123 || foundUserId == 456)
        }
    }

    @Nested
    @DisplayName("Get Login Identity Token with Login Identity ID Tests")
    inner class GetLoginIdentityTokenWithLoginIdTests {

        @Test
        @DisplayName("Should return correct token for existing login identity ID")
        fun shouldReturnCorrectTokenForExistingLoginId() = runTest {
            val loginIdentityId = "login-id-123"
            val loginIdentityToken = "token-abc-123"

            finverseAuthCache.saveLoginIdentityToken(
                    123,
                    "dbs-bank",
                    loginIdentityId,
                    loginIdentityToken
            )

            val foundToken =
                    finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)
            assertEquals(loginIdentityToken, foundToken)
        }

        @Test
        @DisplayName("Should return empty string for non-existent login identity ID")
        fun shouldReturnEmptyStringForNonExistentLoginId() = runTest {
            val foundToken =
                    finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(
                            "non-existent-login-id"
                    )
            assertEquals("", foundToken)
        }

        @Test
        @DisplayName("Should find token across multiple users and institutions")
        fun shouldFindTokenAcrossMultipleUsersAndInstitutions() = runTest {
            finverseAuthCache.saveLoginIdentityToken(123, "dbs-bank", "login-id-1", "token-1")
            finverseAuthCache.saveLoginIdentityToken(123, "ocbc-bank", "login-id-2", "token-2")
            finverseAuthCache.saveLoginIdentityToken(456, "uob-bank", "login-id-3", "token-3")

            val token1 = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID("login-id-1")
            val token2 = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID("login-id-2")
            val token3 = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID("login-id-3")

            assertEquals("token-1", token1)
            assertEquals("token-2", token2)
            assertEquals("token-3", token3)
        }

        @Test
        @DisplayName("Should handle updated tokens correctly")
        fun shouldHandleUpdatedTokensCorrectly() = runTest {
            val loginIdentityId = "login-id-123"

            finverseAuthCache.saveLoginIdentityToken(123, "dbs-bank", loginIdentityId, "old-token")
            finverseAuthCache.saveLoginIdentityToken(123, "dbs-bank", loginIdentityId, "new-token")

            val foundToken =
                    finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)
            assertEquals("new-token", foundToken)
        }
    }

    @Nested
    @DisplayName("Edge Cases and Special Scenarios Tests")
    inner class EdgeCasesAndSpecialScenariosTests {

        @Test
        @DisplayName("Should handle empty strings")
        fun shouldHandleEmptyStrings() = runTest {
            finverseAuthCache.saveLoginIdentityToken(123, "", "", "")

            val credential = finverseAuthCache.getLoginIdentityCredential(123, "")
            assertNotNull(credential)
            assertEquals("", credential!!.loginIdentityId)
            assertEquals("", credential.loginIdentityToken)

            val userId = finverseAuthCache.getUserId("")
            assertEquals(123, userId)

            val token = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID("")
            assertEquals("", token)
        }

        @Test
        @DisplayName("Should handle very large user IDs")
        fun shouldHandleVeryLargeUserIds() = runTest {
            val largeUserId = Int.MAX_VALUE

            finverseAuthCache.saveLoginIdentityToken(largeUserId, "test-bank", "login-id", "token")

            val credential = finverseAuthCache.getLoginIdentityCredential(largeUserId, "test-bank")
            assertNotNull(credential)
            assertEquals("login-id", credential!!.loginIdentityId)
        }

        @Test
        @DisplayName("Should handle special characters in IDs and tokens")
        fun shouldHandleSpecialCharactersInIdsAndTokens() = runTest {
            val specialInstitutionId = "test-bank-éñ@#$%^&*()"
            val specialLoginId = "login-id-éñ@#$%^&*()"
            val specialToken = "token-éñ@#$%^&*()"

            finverseAuthCache.saveLoginIdentityToken(
                    123,
                    specialInstitutionId,
                    specialLoginId,
                    specialToken
            )

            val credential = finverseAuthCache.getLoginIdentityCredential(123, specialInstitutionId)
            assertNotNull(credential)
            assertEquals(specialLoginId, credential!!.loginIdentityId)
            assertEquals(specialToken, credential.loginIdentityToken)

            val userId = finverseAuthCache.getUserId(specialLoginId)
            assertEquals(123, userId)

            val token = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(specialLoginId)
            assertEquals(specialToken, token)
        }

        @Test
        @DisplayName("Should handle zero and negative user IDs")
        fun shouldHandleZeroAndNegativeUserIds() = runTest {
            finverseAuthCache.saveLoginIdentityToken(0, "zero-bank", "zero-login", "zero-token")
            finverseAuthCache.saveLoginIdentityToken(
                    -1,
                    "negative-bank",
                    "negative-login",
                    "negative-token"
            )

            val zeroCredential = finverseAuthCache.getLoginIdentityCredential(0, "zero-bank")
            val negativeCredential =
                    finverseAuthCache.getLoginIdentityCredential(-1, "negative-bank")

            assertNotNull(zeroCredential)
            assertEquals("zero-login", zeroCredential!!.loginIdentityId)

            assertNotNull(negativeCredential)
            assertEquals("negative-login", negativeCredential!!.loginIdentityId)
        }
    }

    @Nested
    @DisplayName("Concurrency Tests")
    inner class ConcurrencyTests {

        @Test
        @DisplayName("Should handle concurrent saves safely")
        fun shouldHandleConcurrentSavesSafely() = runTest {
            val jobs =
                    (1..100).map { i ->
                        async {
                            finverseAuthCache.saveLoginIdentityToken(
                                    i,
                                    "bank-$i",
                                    "login-$i",
                                    "token-$i"
                            )
                        }
                    }

            jobs.awaitAll()

            // Verify all credentials were saved correctly
            repeat(100) { i ->
                val credential =
                        finverseAuthCache.getLoginIdentityCredential(i + 1, "bank-${i + 1}")
                assertNotNull(credential)
                assertEquals("login-${i + 1}", credential!!.loginIdentityId)
                assertEquals("token-${i + 1}", credential!!.loginIdentityToken)
            }
        }

        @Test
        @DisplayName("Should handle concurrent reads safely")
        fun shouldHandleConcurrentReadsSafely() = runTest {
            // Setup data
            repeat(10) { i ->
                finverseAuthCache.saveLoginIdentityToken(i, "bank-$i", "login-$i", "token-$i")
            }

            // Concurrent reads
            val jobs =
                    (0 until 10).map { i ->
                        async {
                            val credential =
                                    finverseAuthCache.getLoginIdentityCredential(i, "bank-$i")
                            val userId = finverseAuthCache.getUserId("login-$i")
                            val token =
                                    finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(
                                            "login-$i"
                                    )

                            Triple(credential, userId, token)
                        }
                    }

            val results = jobs.awaitAll()

            results.forEachIndexed { index, (credential, userId, token) ->
                assertNotNull(credential)
                assertEquals("login-$index", credential!!.loginIdentityId)
                assertEquals("token-$index", credential.loginIdentityToken)
                assertEquals(index, userId)
                assertEquals("token-$index", token)
            }
        }

        @Test
        @DisplayName("Should handle concurrent updates to same user correctly")
        fun shouldHandleConcurrentUpdatesToSameUserCorrectly() = runTest {
            val userId = 123
            val institutionId = "test-bank"

            val jobs =
                    (1..50).map { i ->
                        async {
                            finverseAuthCache.saveLoginIdentityToken(
                                    userId,
                                    institutionId,
                                    "login-$i",
                                    "token-$i"
                            )
                        }
                    }

            jobs.awaitAll()

            // The final credential should be one of the saved ones
            val credential = finverseAuthCache.getLoginIdentityCredential(userId, institutionId)
            assertNotNull(credential)

            // Verify the credential is consistent
            val loginIdNumber = credential!!.loginIdentityId.substringAfter("login-").toInt()
            assertEquals("token-$loginIdNumber", credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should handle mixed concurrent operations safely")
        fun shouldHandleMixedConcurrentOperationsSafely() = runTest {
            // Setup initial data
            repeat(20) { i ->
                finverseAuthCache.saveLoginIdentityToken(i, "bank-$i", "login-$i", "token-$i")
            }

            val jobs =
                    (1..30).map { i ->
                        async {
                            if (i % 3 == 0) {
                                finverseAuthCache.saveLoginIdentityToken(
                                        i + 100,
                                        "new-bank-$i",
                                        "new-login-$i",
                                        "new-token-$i"
                                )
                            } else if (i % 3 == 1) {
                                finverseAuthCache.getLoginIdentityCredential(
                                        i % 20,
                                        "bank-${i % 20}"
                                )
                            } else {
                                finverseAuthCache.getUserId("login-${i % 20}")
                            }
                        }
                    }

            jobs.awaitAll()

            // Verify original data is still intact
            repeat(10) { i ->
                val credential = finverseAuthCache.getLoginIdentityCredential(i, "bank-$i")
                assertNotNull(credential)
                assertEquals("login-$i", credential!!.loginIdentityId)
            }
        }
    }
}
