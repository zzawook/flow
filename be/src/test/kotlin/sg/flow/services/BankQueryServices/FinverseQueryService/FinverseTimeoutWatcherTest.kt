package sg.flow.services.BankQueryServices.FinverseQueryService

import io.mockk.*
import kotlin.time.Duration.Companion.milliseconds
import kotlin.time.Duration.Companion.seconds
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.asSharedFlow
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent

@DisplayName("FinverseTimeoutWatcher Tests")
class FinverseTimeoutWatcherTest {

        private lateinit var authPublisher: FinverseAuthEventPublisher
        private lateinit var productPublisher: FinverseProductCompleteEventPublisher
        private lateinit var finverseTimeoutWatcher: FinverseTimeoutWatcher

        private lateinit var authEventsFlow: MutableSharedFlow<FinverseWebhookEvent>
        private lateinit var productEventsFlow: MutableSharedFlow<FinverseOverallRetrievalStatus>

        @BeforeEach
        fun setUp() {
                // Note: FinverseTimeoutWatcher is now Kafka-based and doesn't need constructor dependencies
                finverseTimeoutWatcher = FinverseTimeoutWatcher()
        }

        @Nested
        @DisplayName("Watch Authentication Tests")
        inner class WatchAuthenticationTests {

                @Test
                @DisplayName("Should return AUTHENTICATED when correct event is received")
                fun shouldReturnAuthenticatedWhenCorrectEventReceived() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 1.seconds

                        val webhookEvent =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(100.milliseconds) // Small delay to ensure watcher is ready
                                authEventsFlow.emit(webhookEvent)
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(loginIdentityId, timeout)

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should return AUTHENTICATION_TIMEOUT when timeout occurs")
                fun shouldReturnTimeoutWhenTimeoutOccurs() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 100.milliseconds

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(loginIdentityId, timeout)

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT, result)
                }

                @Test
                @DisplayName("Should ignore events with different login identity ID")
                fun shouldIgnoreEventsWithDifferentLoginIdentityId() = runTest {
                        val targetLoginIdentityId = "target-login-id"
                        val otherLoginIdentityId = "other-login-id"
                        val timeout = 500.milliseconds

                        val wrongEvent =
                                FinverseWebhookEvent(
                                        loginIdentityId = otherLoginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val correctEvent =
                                FinverseWebhookEvent(
                                        loginIdentityId = targetLoginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(50.milliseconds)
                                authEventsFlow.emit(wrongEvent) // Should be ignored
                                delay(50.milliseconds)
                                authEventsFlow.emit(correctEvent) // Should be processed
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(
                                        targetLoginIdentityId,
                                        timeout
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should ignore events with different event types")
                fun shouldIgnoreEventsWithDifferentEventTypes() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 500.milliseconds

                        val wrongEventType =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATION_FAILED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val correctEventType =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(50.milliseconds)
                                authEventsFlow.emit(wrongEventType) // Should be ignored
                                delay(50.milliseconds)
                                authEventsFlow.emit(correctEventType) // Should be processed
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(loginIdentityId, timeout)

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle multiple concurrent watchers")
                fun shouldHandleMultipleConcurrentWatchers() = runTest {
                        val loginIdentityId1 = "login-id-1"
                        val loginIdentityId2 = "login-id-2"
                        val timeout = 1.seconds

                        val event1 =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId1,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val event2 =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId2,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start watching both in parallel
                        val watcher1 = launch {
                                finverseTimeoutWatcher.watchAuthentication(
                                        loginIdentityId1,
                                        timeout
                                )
                        }

                        val watcher2 = launch {
                                finverseTimeoutWatcher.watchAuthentication(
                                        loginIdentityId2,
                                        timeout
                                )
                        }

                        // Emit events
                        val emitJob = launch {
                                delay(100.milliseconds)
                                authEventsFlow.emit(event1)
                                delay(50.milliseconds)
                                authEventsFlow.emit(event2)
                        }

                        watcher1.join()
                        watcher2.join()
                        emitJob.join()
                }

                @Test
                @DisplayName("Should handle rapid event emissions")
                fun shouldHandleRapidEventEmissions() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 1.seconds

                        val targetEvent =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start watching
                        val watchJob = launch {
                                // Emit multiple events rapidly
                                repeat(5) { i ->
                                        val event =
                                                FinverseWebhookEvent(
                                                        loginIdentityId = "other-login-$i",
                                                        event_type = "AUTHENTICATED",
                                                        event_time = "2024-01-01T00:00:00Z"
                                                )
                                        authEventsFlow.emit(event)
                                }
                                authEventsFlow.emit(targetEvent) // The one we're waiting for
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(loginIdentityId, timeout)

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle authentication failure events correctly")
                fun shouldHandleAuthenticationFailureEventsCorrectly() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 1.seconds

                        // Even though we're filtering for "AUTHENTICATED", we test that other
                        // events are
                        // ignored
                        val failureEvent =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATION_FAILED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val watchJob = launch {
                                delay(100.milliseconds)
                                authEventsFlow.emit(failureEvent) // Should be ignored due to filter
                                delay(
                                        200.milliseconds
                                ) // Wait longer than timeout to ensure timeout occurs
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(loginIdentityId, timeout)

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT, result)
                        watchJob.join()
                }
        }

        @Nested
        @DisplayName("Watch Data Retrieval Completion Tests")
        inner class WatchDataRetrievalCompletionTests {

                @Test
                @DisplayName("Should return success status when completion event is received")
                fun shouldReturnSuccessStatusWhenCompletionEventReceived() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 1.seconds

                        val completionStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId,
                                        success = true,
                                        message = "Data retrieval completed successfully"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(100.milliseconds)
                                productEventsFlow.emit(completionStatus)
                        }

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId,
                                        timeout
                                )

                        assertEquals(completionStatus, result)
                        assertEquals(loginIdentityId, result.loginIdentityId)
                        assertEquals(true, result.success)
                        assertEquals("Data retrieval completed successfully", result.message)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should return timeout status when timeout occurs")
                fun shouldReturnTimeoutStatusWhenTimeoutOccurs() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 100.milliseconds

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId,
                                        timeout
                                )

                        assertEquals(false, result.success)
                        assertEquals("TIME OUT: $timeout", result.message)
                        assertEquals(loginIdentityId, result.loginIdentityId)
                }

                @Test
                @DisplayName("Should ignore events with different login identity ID")
                fun shouldIgnoreEventsWithDifferentLoginIdentityId() = runTest {
                        val targetLoginIdentityId = "target-login-id"
                        val otherLoginIdentityId = "other-login-id"
                        val timeout = 500.milliseconds

                        val wrongEvent =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = otherLoginIdentityId,
                                        success = true,
                                        message = "Wrong event"
                                )

                        val correctEvent =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = targetLoginIdentityId,
                                        success = true,
                                        message = "Correct event"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(50.milliseconds)
                                productEventsFlow.emit(wrongEvent) // Should be ignored
                                delay(50.milliseconds)
                                productEventsFlow.emit(correctEvent) // Should be processed
                        }

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        targetLoginIdentityId,
                                        timeout
                                )

                        assertEquals(correctEvent, result)
                        assertEquals("Correct event", result.message)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle success and failure completion statuses")
                fun shouldHandleSuccessAndFailureCompletionStatuses() = runTest {
                        val loginIdentityId1 = "login-id-success"
                        val loginIdentityId2 = "login-id-failure"
                        val timeout = 1.seconds

                        val successStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId1,
                                        success = true,
                                        message = "Success"
                                )

                        val failureStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId2,
                                        success = false,
                                        message = "Failure"
                                )

                        // Start watching both in parallel
                        val successWatcher = launch {
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId1,
                                        timeout
                                )
                        }

                        val failureWatcher = launch {
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId2,
                                        timeout
                                )
                        }

                        // Emit events
                        val emitJob = launch {
                                delay(100.milliseconds)
                                productEventsFlow.emit(successStatus)
                                delay(50.milliseconds)
                                productEventsFlow.emit(failureStatus)
                        }

                        successWatcher.join()
                        failureWatcher.join()
                        emitJob.join()
                }

                @Test
                @DisplayName("Should handle multiple completion events for same login ID")
                fun shouldHandleMultipleCompletionEventsForSameLoginId() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 1.seconds

                        val firstStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId,
                                        success = false,
                                        message = "First event"
                                )

                        val secondStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId,
                                        success = true,
                                        message = "Second event"
                                )

                        // Start watching
                        val watchJob = launch {
                                delay(100.milliseconds)
                                productEventsFlow.emit(
                                        firstStatus
                                ) // This should be the one returned (first match)
                                delay(50.milliseconds)
                                productEventsFlow.emit(secondStatus) // This should be ignored
                        }

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId,
                                        timeout
                                )

                        assertEquals(firstStatus, result)
                        assertEquals("First event", result.message)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle very short timeouts")
                fun shouldHandleVeryShortTimeouts() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 10.milliseconds // Very short timeout

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId,
                                        timeout
                                )

                        assertEquals(false, result.success)
                        assertEquals("TIME OUT: $timeout", result.message)
                        assertEquals(loginIdentityId, result.loginIdentityId)
                }

                @Test
                @DisplayName("Should handle long timeouts efficiently")
                fun shouldHandleLongTimeoutsEfficiently() = runTest {
                        val loginIdentityId = "test-login-id"
                        val timeout = 10.seconds // Long timeout, but we'll emit event quickly

                        val completionStatus =
                                FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId,
                                        success = true,
                                        message = "Quick completion"
                                )

                        // Start watching in background
                        val watchJob = launch {
                                delay(50.milliseconds) // Emit event quickly, well before timeout
                                productEventsFlow.emit(completionStatus)
                        }

                        val result =
                                finverseTimeoutWatcher.watchDataRetrievalCompletion(
                                        loginIdentityId,
                                        timeout
                                )

                        assertEquals(completionStatus, result)
                        assertEquals("Quick completion", result.message)
                        watchJob.join()
                }
        }

        @Nested
        @DisplayName("Edge Cases and Error Handling Tests")
        inner class EdgeCasesAndErrorHandlingTests {

                @Test
                @DisplayName("Should handle empty login identity ID")
                fun shouldHandleEmptyLoginIdentityId() = runTest {
                        val emptyLoginIdentityId = ""
                        val timeout = 100.milliseconds

                        val event =
                                FinverseWebhookEvent(
                                        loginIdentityId = emptyLoginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val watchJob = launch {
                                delay(50.milliseconds)
                                authEventsFlow.emit(event)
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(
                                        emptyLoginIdentityId,
                                        timeout
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle very long login identity IDs")
                fun shouldHandleVeryLongLoginIdentityIds() = runTest {
                        val longLoginIdentityId = "a".repeat(1000)
                        val timeout = 500.milliseconds

                        val event =
                                FinverseWebhookEvent(
                                        loginIdentityId = longLoginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val watchJob = launch {
                                delay(100.milliseconds)
                                authEventsFlow.emit(event)
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(
                                        longLoginIdentityId,
                                        timeout
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle special characters in login identity ID")
                fun shouldHandleSpecialCharactersInLoginIdentityId() = runTest {
                        val specialLoginIdentityId = "login-éñ@#$%^&*()_+-={}[]|\\:;\"'<>,.?/"
                        val timeout = 500.milliseconds

                        val event =
                                FinverseWebhookEvent(
                                        loginIdentityId = specialLoginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        val watchJob = launch {
                                delay(100.milliseconds)
                                authEventsFlow.emit(event)
                        }

                        val result =
                                finverseTimeoutWatcher.watchAuthentication(
                                        specialLoginIdentityId,
                                        timeout
                                )

                        assertEquals(FinverseAuthenticationStatus.AUTHENTICATED, result)
                        watchJob.join()
                }

                @Test
                @DisplayName("Should handle rapid sequential timeouts")
                fun shouldHandleRapidSequentialTimeouts() = runTest {
                        val loginIdentityId = "test-login-id"
                        val shortTimeout = 50.milliseconds

                        // Multiple rapid timeout calls
                        repeat(5) {
                                val result =
                                        finverseTimeoutWatcher.watchAuthentication(
                                                loginIdentityId,
                                                shortTimeout
                                        )
                                assertEquals(
                                        FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT,
                                        result
                                )
                        }
                }

                @Test
                @DisplayName("Should handle concurrent watchers with different timeouts")
                fun shouldHandleConcurrentWatchersWithDifferentTimeouts() = runTest {
                        val loginIdentityId = "test-login-id"
                        val shortTimeout = 100.milliseconds
                        val longTimeout = 1.seconds

                        val event =
                                FinverseWebhookEvent(
                                        loginIdentityId = loginIdentityId,
                                        event_type = "AUTHENTICATED",
                                        event_time = "2024-01-01T00:00:00Z"
                                )

                        // Start multiple watchers with different timeouts
                        val shortWatcher = launch {
                                finverseTimeoutWatcher.watchAuthentication(
                                        loginIdentityId,
                                        shortTimeout
                                )
                        }

                        val longWatcher = launch {
                                finverseTimeoutWatcher.watchAuthentication(
                                        loginIdentityId,
                                        longTimeout
                                )
                        }

                        // Emit event after short timeout but before long timeout
                        val emitJob = launch {
                                delay(150.milliseconds)
                                authEventsFlow.emit(event)
                        }

                        shortWatcher.join() // Should timeout
                        longWatcher.join() // Should receive the event
                        emitJob.join()
                }
        }
}
