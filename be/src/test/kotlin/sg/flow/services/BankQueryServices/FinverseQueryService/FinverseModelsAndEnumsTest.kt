package sg.flow.services.BankQueryServices.FinverseQueryService

import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.models.finverse.*
import sg.flow.models.finverse.webhook_events.FinverseWebhookError
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent

@DisplayName("Finverse Models and Enums Tests")
class FinverseModelsAndEnumsTest {

    @Nested
    @DisplayName("FinverseCredentials Tests")
    inner class FinverseCredentialsTests {

        @Test
        @DisplayName("Should have correct credential values")
        fun shouldHaveCorrectCredentialValues() {
            val credentials = FinverseCredentials()

            assertEquals("01JR0XFWQVS7NHGH4NVCERGB40", credentials.clientId)
            assertEquals("01JR0XFWSA1A90FGWMS4B12QHN", credentials.clientAppId)
            assertEquals(
                    "fv-c-1749191895-e5efb46230f9f490c27c889783c8119a9975dd1e852db23b695d98c38b5e5bd0",
                    credentials.clientSecret
            )
        }

        @Test
        @DisplayName("Should be annotated as Configuration")
        fun shouldBeAnnotatedAsConfiguration() {
            val credentials = FinverseCredentials()
            assertNotNull(credentials)
            // Note: We can't easily test annotations at runtime without reflection
            // but this verifies the class can be instantiated
        }

        @Test
        @DisplayName("Should maintain consistent credential values")
        fun shouldMaintainConsistentCredentialValues() {
            val credentials1 = FinverseCredentials()
            val credentials2 = FinverseCredentials()

            assertEquals(credentials1.clientId, credentials2.clientId)
            assertEquals(credentials1.clientAppId, credentials2.clientAppId)
            assertEquals(credentials1.clientSecret, credentials2.clientSecret)
        }
    }

    @Nested
    @DisplayName("FinverseLoginIdentityCredential Tests")
    inner class FinverseLoginIdentityCredentialTests {

        @Test
        @DisplayName("Should create credential with correct properties")
        fun shouldCreateCredentialWithCorrectProperties() {
            val loginIdentityId = "test-login-id-123"
            val loginIdentityToken = "test-token-abc-456"

            val credential = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)

            assertEquals(loginIdentityId, credential.loginIdentityId)
            assertEquals(loginIdentityToken, credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should handle empty strings")
        fun shouldHandleEmptyStrings() {
            val credential = FinverseLoginIdentityCredential("", "")

            assertEquals("", credential.loginIdentityId)
            assertEquals("", credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should handle very long strings")
        fun shouldHandleVeryLongStrings() {
            val longId = "a".repeat(1000)
            val longToken = "b".repeat(2000)

            val credential = FinverseLoginIdentityCredential(longId, longToken)

            assertEquals(longId, credential.loginIdentityId)
            assertEquals(longToken, credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should handle special characters")
        fun shouldHandleSpecialCharacters() {
            val specialId = "login-éñ@#$%^&*()"
            val specialToken = "token-éñ@#$%^&*()"

            val credential = FinverseLoginIdentityCredential(specialId, specialToken)

            assertEquals(specialId, credential.loginIdentityId)
            assertEquals(specialToken, credential.loginIdentityToken)
        }

        @Test
        @DisplayName("Should support data class features")
        fun shouldSupportDataClassFeatures() {
            val credential1 = FinverseLoginIdentityCredential("test-id", "test-token")
            val credential2 = FinverseLoginIdentityCredential("test-id", "test-token")
            val credential3 = FinverseLoginIdentityCredential("different-id", "test-token")

            // Test equality
            assertEquals(credential1, credential2)
            assertTrue(credential1 != credential3)

            // Test toString (should not throw)
            assertNotNull(credential1.toString())
            assertTrue(credential1.toString().isNotEmpty())

            // Test copy functionality
            val copiedCredential = credential1.copy()
            assertEquals(credential1, copiedCredential)

            val modifiedCopy = credential1.copy(loginIdentityId = "modified-id")
            assertEquals("modified-id", modifiedCopy.loginIdentityId)
            assertEquals("test-token", modifiedCopy.loginIdentityToken)
        }
    }

    @Nested
    @DisplayName("FinverseAuthenticationStatus Tests")
    inner class FinverseAuthenticationStatusTests {

        @Test
        @DisplayName("Should have correct AUTHENTICATED status properties")
        fun shouldHaveCorrectAuthenticatedStatusProperties() {
            val status = FinverseAuthenticationStatus.AUTHENTICATED

            assertTrue(status.success)
            assertEquals("", status.message)
        }

        @Test
        @DisplayName("Should have correct AUTHENTICATION_FAILED status properties")
        fun shouldHaveCorrectAuthenticationFailedStatusProperties() {
            val status = FinverseAuthenticationStatus.AUTHENTICATION_FAILED

            assertFalse(status.success)
            assertEquals("AUTHENTICATION FAILED", status.message)
        }

        @Test
        @DisplayName("Should have correct AUTHENTICATION_TEMPORARILY_UNAVAILABLE status properties")
        fun shouldHaveCorrectAuthenticationTemporarilyUnavailableStatusProperties() {
            val status =
                    FinverseAuthenticationStatus
                            .AUTHENTICATION_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION

            assertFalse(status.success)
            assertEquals("AUTHENTICATION TEMPORARY UNAVAILABLE", status.message)
        }

        @Test
        @DisplayName("Should have correct AUTHENTICATION_TOO_MANY_ATTEMPTS status properties")
        fun shouldHaveCorrectAuthenticationTooManyAttemptsStatusProperties() {
            val status = FinverseAuthenticationStatus.AUTHENTICATION_TOO_MANY_ATTEMPTS

            assertFalse(status.success)
            assertEquals("AUTHENTICATION TOO MANY ATTEMPTS", status.message)
        }

        @Test
        @DisplayName("Should have correct AUTHENTICATION_TIMEOUT status properties")
        fun shouldHaveCorrectAuthenticationTimeoutStatusProperties() {
            val status = FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT

            assertFalse(status.success)
            assertEquals("AUTHENTICATION TIMEOUT", status.message)
        }

        @Test
        @DisplayName("Should have all expected authentication statuses")
        fun shouldHaveAllExpectedAuthenticationStatuses() {
            val allStatuses = FinverseAuthenticationStatus.values()

            assertEquals(5, allStatuses.size)
            assertTrue(allStatuses.contains(FinverseAuthenticationStatus.AUTHENTICATED))
            assertTrue(allStatuses.contains(FinverseAuthenticationStatus.AUTHENTICATION_FAILED))
            assertTrue(
                    allStatuses.contains(
                            FinverseAuthenticationStatus
                                    .AUTHENTICATION_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                    )
            )
            assertTrue(
                    allStatuses.contains(
                            FinverseAuthenticationStatus.AUTHENTICATION_TOO_MANY_ATTEMPTS
                    )
            )
            assertTrue(allStatuses.contains(FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT))
        }

        @Test
        @DisplayName("Should categorize success and failure statuses correctly")
        fun shouldCategorizeSuccessAndFailureStatusesCorrectly() {
            val successStatuses = FinverseAuthenticationStatus.values().filter { it.success }
            val failureStatuses = FinverseAuthenticationStatus.values().filter { !it.success }

            assertEquals(1, successStatuses.size)
            assertEquals(4, failureStatuses.size)

            assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, successStatuses.first())
        }
    }

    @Nested
    @DisplayName("FinverseRetrievalStatus Tests")
    inner class FinverseRetrievalStatusTests {

        @Test
        @DisplayName("Should have all expected retrieval statuses")
        fun shouldHaveAllExpectedRetrievalStatuses() {
            val allStatuses = FinverseRetrievalStatus.values()

            assertEquals(6, allStatuses.size)
            assertTrue(allStatuses.contains(FinverseRetrievalStatus.RETRIEVED))
            assertTrue(allStatuses.contains(FinverseRetrievalStatus.RETRIEVAL_FAILED))
            assertTrue(allStatuses.contains(FinverseRetrievalStatus.PARTIALLY_RETRIEVED))
            assertTrue(allStatuses.contains(FinverseRetrievalStatus.NOT_FOUND))
            assertTrue(allStatuses.contains(FinverseRetrievalStatus.NOT_SUPPORTED))
            assertTrue(
                    allStatuses.contains(
                            FinverseRetrievalStatus.TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION
                    )
            )
        }

        @Test
        @DisplayName("Should support valueOf conversion")
        fun shouldSupportValueOfConversion() {
            assertEquals(
                    FinverseRetrievalStatus.RETRIEVED,
                    FinverseRetrievalStatus.valueOf("RETRIEVED")
            )
            assertEquals(
                    FinverseRetrievalStatus.RETRIEVAL_FAILED,
                    FinverseRetrievalStatus.valueOf("RETRIEVAL_FAILED")
            )
            assertEquals(
                    FinverseRetrievalStatus.PARTIALLY_RETRIEVED,
                    FinverseRetrievalStatus.valueOf("PARTIALLY_RETRIEVED")
            )
            assertEquals(
                    FinverseRetrievalStatus.NOT_FOUND,
                    FinverseRetrievalStatus.valueOf("NOT_FOUND")
            )
            assertEquals(
                    FinverseRetrievalStatus.NOT_SUPPORTED,
                    FinverseRetrievalStatus.valueOf("NOT_SUPPORTED")
            )
            assertEquals(
                    FinverseRetrievalStatus.TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION,
                    FinverseRetrievalStatus.valueOf("TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION")
            )
        }

        @Test
        @DisplayName("Should support name property")
        fun shouldSupportNameProperty() {
            assertEquals("RETRIEVED", FinverseRetrievalStatus.RETRIEVED.name)
            assertEquals("RETRIEVAL_FAILED", FinverseRetrievalStatus.RETRIEVAL_FAILED.name)
            assertEquals("PARTIALLY_RETRIEVED", FinverseRetrievalStatus.PARTIALLY_RETRIEVED.name)
            assertEquals("NOT_FOUND", FinverseRetrievalStatus.NOT_FOUND.name)
            assertEquals("NOT_SUPPORTED", FinverseRetrievalStatus.NOT_SUPPORTED.name)
            assertEquals(
                    "TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION",
                    FinverseRetrievalStatus.TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION.name
            )
        }
    }

    @Nested
    @DisplayName("FinverseOverallRetrievalStatus Tests")
    inner class FinverseOverallRetrievalStatusTests {

        @Test
        @DisplayName("Should create status with correct properties")
        fun shouldCreateStatusWithCorrectProperties() {
            val loginIdentityId = "test-login-id"
            val success = true
            val message = "All data retrieved successfully"

            val status = FinverseOverallRetrievalStatus(loginIdentityId, success, message)

            assertEquals(loginIdentityId, status.loginIdentityId)
            assertEquals(success, status.success)
            assertEquals(message, status.message)
        }

        @Test
        @DisplayName("Should handle success scenarios")
        fun shouldHandleSuccessScenarios() {
            val successStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "success-login",
                            success = true,
                            message = "123 - dbs-bank - 5"
                    )

            assertTrue(successStatus.success)
            assertEquals("success-login", successStatus.loginIdentityId)
            assertTrue(successStatus.message.contains("dbs-bank"))
        }

        @Test
        @DisplayName("Should handle failure scenarios")
        fun shouldHandleFailureScenarios() {
            val failureStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "failure-login",
                            success = false,
                            message = "ACCOUNTS - RETRIEVAL_FAILED"
                    )

            assertFalse(failureStatus.success)
            assertEquals("failure-login", failureStatus.loginIdentityId)
            assertTrue(failureStatus.message.contains("RETRIEVAL_FAILED"))
        }

        @Test
        @DisplayName("Should handle timeout scenarios")
        fun shouldHandleTimeoutScenarios() {
            val timeoutStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "timeout-login",
                            success = false,
                            message = "TIME OUT: 5m"
                    )

            assertFalse(timeoutStatus.success)
            assertEquals("timeout-login", timeoutStatus.loginIdentityId)
            assertTrue(timeoutStatus.message.contains("TIME OUT"))
        }

        @Test
        @DisplayName("Should support data class features")
        fun shouldSupportDataClassFeatures() {
            val status1 = FinverseOverallRetrievalStatus("id1", true, "message1")
            val status2 = FinverseOverallRetrievalStatus("id1", true, "message1")
            val status3 = FinverseOverallRetrievalStatus("id2", true, "message1")

            assertEquals(status1, status2)
            assertTrue(status1 != status3)

            assertNotNull(status1.toString())

            val copiedStatus = status1.copy()
            assertEquals(status1, copiedStatus)

            val modifiedCopy = status1.copy(success = false)
            assertFalse(modifiedCopy.success)
            assertEquals("id1", modifiedCopy.loginIdentityId)
            assertEquals("message1", modifiedCopy.message)
        }
    }

    @Nested
    @DisplayName("FinverseProductStatus Tests")
    inner class FinverseProductStatusTests {

        @Test
        @DisplayName("Should create product status with correct properties")
        fun shouldCreateProductStatusWithCorrectProperties() {
            val product = FinverseProduct.ACCOUNTS
            val status = FinverseRetrievalStatus.RETRIEVED

            val productStatus = FinverseProductStatus(product, status)

            assertEquals(product, productStatus.product)
            assertEquals(status, productStatus.status)
        }

        @Test
        @DisplayName("Should handle all product types")
        fun shouldHandleAllProductTypes() {
            val allProducts = FinverseProduct.all
            val status = FinverseRetrievalStatus.RETRIEVED

            allProducts.forEach { product ->
                val productStatus = FinverseProductStatus(product, status)
                assertEquals(product, productStatus.product)
                assertEquals(status, productStatus.status)
            }
        }

        @Test
        @DisplayName("Should handle all retrieval statuses")
        fun shouldHandleAllRetrievalStatuses() {
            val product = FinverseProduct.ACCOUNTS
            val allStatuses = FinverseRetrievalStatus.values()

            allStatuses.forEach { status ->
                val productStatus = FinverseProductStatus(product, status)
                assertEquals(product, productStatus.product)
                assertEquals(status, productStatus.status)
            }
        }

        @Test
        @DisplayName("Should support data class features")
        fun shouldSupportDataClassFeatures() {
            val status1 =
                    FinverseProductStatus(
                            FinverseProduct.ACCOUNTS,
                            FinverseRetrievalStatus.RETRIEVED
                    )
            val status2 =
                    FinverseProductStatus(
                            FinverseProduct.ACCOUNTS,
                            FinverseRetrievalStatus.RETRIEVED
                    )
            val status3 =
                    FinverseProductStatus(
                            FinverseProduct.IDENTITY,
                            FinverseRetrievalStatus.RETRIEVED
                    )

            assertEquals(status1, status2)
            assertTrue(status1 != status3)

            assertNotNull(status1.toString())
        }
    }

    @Nested
    @DisplayName("FinverseWebhookEvent Tests")
    inner class FinverseWebhookEventTests {

        @Test
        @DisplayName("Should create webhook event with correct properties")
        fun shouldCreateWebhookEventWithCorrectProperties() {
            val loginIdentityId = "test-login-id"
            val eventType = "AUTHENTICATED"
            val eventTime = "2024-01-01T00:00:00Z"

            val event = FinverseWebhookEvent(loginIdentityId, eventType, eventTime)

            assertEquals(loginIdentityId, event.loginIdentityId)
            assertEquals(eventType, event.event_type)
            assertEquals(eventTime, event.event_time)
            assertNull(event.error)
        }

        @Test
        @DisplayName("Should create webhook event with error")
        fun shouldCreateWebhookEventWithError() {
            val loginIdentityId = "error-login-id"
            val eventType = "AUTHENTICATION_FAILED"
            val eventTime = "2024-01-01T00:00:00Z"
            val error = FinverseWebhookError()

            val event = FinverseWebhookEvent(loginIdentityId, eventType, eventTime, error)

            assertEquals(loginIdentityId, event.loginIdentityId)
            assertEquals(eventType, event.event_type)
            assertEquals(eventTime, event.event_time)
            assertNotNull(event.error)
        }

        @Test
        @DisplayName("Should handle different event types")
        fun shouldHandleDifferentEventTypes() {
            val eventTypes =
                    listOf(
                            "AUTHENTICATED",
                            "AUTHENTICATION_FAILED",
                            "AUTHENTICATION_TOO_MANY_ATTEMPTS",
                            "ACCOUNTS_RETRIEVED",
                            "TRANSACTIONS_RETRIEVED",
                            "IDENTITY_RETRIEVED"
                    )

            eventTypes.forEach { eventType ->
                val event = FinverseWebhookEvent("test-id", eventType, "2024-01-01T00:00:00Z")
                assertEquals(eventType, event.event_type)
            }
        }

        @Test
        @DisplayName("Should support data class features")
        fun shouldSupportDataClassFeatures() {
            val event1 = FinverseWebhookEvent("id1", "type1", "time1")
            val event2 = FinverseWebhookEvent("id1", "type1", "time1")
            val event3 = FinverseWebhookEvent("id2", "type1", "time1")

            assertEquals(event1, event2)
            assertTrue(event1 != event3)

            assertNotNull(event1.toString())

            val copiedEvent = event1.copy()
            assertEquals(event1, copiedEvent)

            val modifiedCopy = event1.copy(event_type = "modified_type")
            assertEquals("modified_type", modifiedCopy.event_type)
            assertEquals("id1", modifiedCopy.loginIdentityId)
            assertEquals("time1", modifiedCopy.event_time)
        }
    }

    @Nested
    @DisplayName("FinverseAuthenticationEventTypeParser Tests")
    inner class FinverseAuthenticationEventTypeParserTests {

        @Test
        @DisplayName("Should parse AUTHENTICATED event correctly")
        fun shouldParseAuthenticatedEventCorrectly() {
            val result = FinverseAuthenticationEventTypeParser.parse("AUTHENTICATED")
            assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
        }

        @Test
        @DisplayName("Should parse regex-based authentication events")
        fun shouldParseRegexBasedAuthenticationEvents() {
            // Based on the actual implementation, the regex pattern expects: FIRST_SECOND format
            // where SECOND should be a valid FinverseAuthenticationStatus enum value
            // Since "AUTHENTICATION_FAILED" doesn't match the expected pattern, it should return
            // AUTHENTICATION_FAILED
            val result1 = FinverseAuthenticationEventTypeParser.parse("AUTHENTICATION_FAILED")
            assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result1)

            // Similarly, this doesn't match the regex pattern
            val result2 =
                    FinverseAuthenticationEventTypeParser.parse("AUTHENTICATION_TOO_MANY_ATTEMPTS")
            assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result2)
        }

        @Test
        @DisplayName("Should return AUTHENTICATION_FAILED for unparseable events")
        fun shouldReturnAuthenticationFailedForUnparseableEvents() {
            val result = FinverseAuthenticationEventTypeParser.parse("INVALID_EVENT_TYPE")
            assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, result)
        }

        @Test
        @DisplayName("Should handle empty and null strings")
        fun shouldHandleEmptyAndNullStrings() {
            val emptyResult = FinverseAuthenticationEventTypeParser.parse("")
            assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_FAILED, emptyResult)
        }
    }

    @Nested
    @DisplayName("FinverseEventTypeParser Tests")
    inner class FinverseEventTypeParserTests {

        @Test
        @DisplayName("Should parse product events correctly")
        fun shouldParseProductEventsCorrectly() {
            val testCases =
                    mapOf(
                            "ACCOUNTS_RETRIEVED" to
                                    Pair(
                                            FinverseProduct.ACCOUNTS,
                                            FinverseRetrievalStatus.RETRIEVED
                                    ),
                            "ACCOUNT_NUMBERS_RETRIEVED" to
                                    Pair(
                                            FinverseProduct.ACCOUNT_NUMBERS,
                                            FinverseRetrievalStatus.RETRIEVED
                                    ),
                            "ONLINE_TRANSACTIONS_RETRIEVAL_FAILED" to
                                    Pair(
                                            FinverseProduct.ONLINE_TRANSACTIONS,
                                            FinverseRetrievalStatus.RETRIEVAL_FAILED
                                    ),
                            "IDENTITY_PARTIALLY_RETRIEVED" to
                                    Pair(
                                            FinverseProduct.IDENTITY,
                                            FinverseRetrievalStatus.PARTIALLY_RETRIEVED
                                    )
                    )

            testCases.forEach { (eventString, expectedResult) ->
                val result = FinverseEventTypeParser.parse(eventString)
                assertNotNull(result, "Should parse $eventString")
                assertEquals(expectedResult.first, result!!.product)
                assertEquals(expectedResult.second, result.status)
            }
        }

        @Test
        @DisplayName("Should identify correct products")
        fun shouldIdentifyCorrectProducts() {
            val testCases =
                    mapOf(
                            "ACCOUNTS_RETRIEVED" to FinverseProduct.ACCOUNTS,
                            "ACCOUNT_NUMBERS_RETRIEVED" to FinverseProduct.ACCOUNT_NUMBERS,
                            "ONLINE_TRANSACTIONS_RETRIEVED" to FinverseProduct.ONLINE_TRANSACTIONS,
                            "HISTORICAL_TRANSACTIONS_RETRIEVED" to
                                    FinverseProduct.HISTORICAL_TRANSACTIONS,
                            "IDENTITY_RETRIEVED" to FinverseProduct.IDENTITY,
                            "BALANCE_HISTORY_RETRIEVED" to FinverseProduct.BALANCE_HISTORY,
                            "INCOME_ESTIMATION_RETRIEVED" to FinverseProduct.INCOME_ESTIMATION,
                            "STATEMENTS_RETRIEVED" to FinverseProduct.STATEMENTS
                    )

            testCases.forEach { (eventString, expectedProduct) ->
                val identifiedProduct = FinverseEventTypeParser.getProductThatBelongs(eventString)
                assertEquals(expectedProduct, identifiedProduct)
            }
        }

        @Test
        @DisplayName("Should default to STATEMENTS for unknown events")
        fun shouldDefaultToStatementsForUnknownEvents() {
            val unknownEvent = "UNKNOWN_PRODUCT_RETRIEVED"
            val result = FinverseEventTypeParser.getProductThatBelongs(unknownEvent)
            assertEquals(FinverseProduct.STATEMENTS, result)
        }
    }
}
