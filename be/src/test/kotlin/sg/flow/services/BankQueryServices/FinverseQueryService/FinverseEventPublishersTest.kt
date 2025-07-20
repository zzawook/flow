package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.launch
import kotlinx.coroutines.test.runTest
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.api.Test
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.webhook_events.FinverseWebhookError
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent

@DisplayName("Finverse Event Publishers Tests")
class FinverseEventPublishersTest {

    @Nested
    @DisplayName("FinverseAuthEventPublisher Tests")
    inner class FinverseAuthEventPublisherTests {

        private lateinit var authEventPublisher: FinverseAuthEventPublisher

        @BeforeEach
        fun setUp() {
            authEventPublisher = FinverseAuthEventPublisher()
        }

        @Test
        @DisplayName("Should publish and receive authentication events")
        fun shouldPublishAndReceiveAuthenticationEvents() = runTest {
            val testEvent =
                    FinverseWebhookEvent(
                            loginIdentityId = "test-login-id",
                            event_type = "AUTHENTICATED",
                            event_time = "2024-01-01T00:00:00Z"
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedEvent = authEventPublisher.events.first()
                assertEquals(testEvent.loginIdentityId, receivedEvent.loginIdentityId)
                assertEquals(testEvent.event_type, receivedEvent.event_type)
                assertEquals(testEvent.event_time, receivedEvent.event_time)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            authEventPublisher.publish(testEvent)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle multiple authentication events")
        fun shouldHandleMultipleAuthenticationEvents() = runTest {
            val testEvents =
                    listOf(
                            FinverseWebhookEvent(
                                    loginIdentityId = "login-1",
                                    event_type = "AUTHENTICATED",
                                    event_time = "2024-01-01T00:00:00Z"
                            ),
                            FinverseWebhookEvent(
                                    loginIdentityId = "login-2",
                                    event_type = "AUTHENTICATION_FAILED",
                                    event_time = "2024-01-01T00:01:00Z"
                            ),
                            FinverseWebhookEvent(
                                    loginIdentityId = "login-3",
                                    event_type = "AUTHENTICATION_TOO_MANY_ATTEMPTS",
                                    event_time = "2024-01-01T00:02:00Z"
                            )
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedEvents = authEventPublisher.events.take(3).toList()
                assertEquals(3, receivedEvents.size)

                testEvents.forEachIndexed { index, expectedEvent ->
                    val receivedEvent = receivedEvents[index]
                    assertEquals(expectedEvent.loginIdentityId, receivedEvent.loginIdentityId)
                    assertEquals(expectedEvent.event_type, receivedEvent.event_type)
                    assertEquals(expectedEvent.event_time, receivedEvent.event_time)
                }
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events
            testEvents.forEach { event ->
                authEventPublisher.publish(event)
                delay(5) // Small delay between events
            }

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle authentication events with errors")
        fun shouldHandleAuthenticationEventsWithErrors() = runTest {
            val errorEvent =
                    FinverseWebhookEvent(
                            loginIdentityId = "error-login-id",
                            event_type = "AUTHENTICATION_FAILED",
                            event_time = "2024-01-01T00:00:00Z",
                            error = FinverseWebhookError()
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedEvent = authEventPublisher.events.first()
                assertEquals(errorEvent.loginIdentityId, receivedEvent.loginIdentityId)
                assertEquals(errorEvent.event_type, receivedEvent.event_type)
                assertNotNull(receivedEvent.error)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            authEventPublisher.publish(errorEvent)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle rapid event publishing")
        fun shouldHandleRapidEventPublishing() = runTest {
            val numberOfEvents = 50
            val events =
                    (1..numberOfEvents).map { i ->
                        FinverseWebhookEvent(
                                loginIdentityId = "rapid-login-$i",
                                event_type = "AUTHENTICATED",
                                event_time = "2024-01-01T00:00:${i.toString().padStart(2, '0')}Z"
                        )
                    }

            // Start collecting events
            val collectJob = launch {
                val receivedEvents = authEventPublisher.events.take(numberOfEvents).toList()
                assertEquals(numberOfEvents, receivedEvents.size)

                // Verify that all events were received (order might vary due to concurrency)
                val receivedLoginIds = receivedEvents.map { it.loginIdentityId }.toSet()
                val expectedLoginIds = events.map { it.loginIdentityId }.toSet()
                assertEquals(expectedLoginIds, receivedLoginIds)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events rapidly
            events.forEach { event -> authEventPublisher.publish(event) }

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should support multiple concurrent subscribers")
        fun shouldSupportMultipleConcurrentSubscribers() = runTest {
            val testEvent =
                    FinverseWebhookEvent(
                            loginIdentityId = "concurrent-login-id",
                            event_type = "AUTHENTICATED",
                            event_time = "2024-01-01T00:00:00Z"
                    )

            val numberOfSubscribers = 5
            val subscriberJobs =
                    (1..numberOfSubscribers).map { subscriberId ->
                        launch {
                            val receivedEvent = authEventPublisher.events.first()
                            assertEquals(testEvent.loginIdentityId, receivedEvent.loginIdentityId)
                            assertEquals(testEvent.event_type, receivedEvent.event_type)
                        }
                    }

            // Give some time for all subscribers to start
            delay(50)

            // Publish the event
            authEventPublisher.publish(testEvent)

            // Wait for all subscribers to complete
            subscriberJobs.forEach { it.join() }
        }

        @Test
        @DisplayName("Should handle events with special characters")
        fun shouldHandleEventsWithSpecialCharacters() = runTest {
            val specialEvent =
                    FinverseWebhookEvent(
                            loginIdentityId = "special-login-éñ@#$%^&*()",
                            event_type = "AUTHENTICATED",
                            event_time = "2024-01-01T00:00:00Z"
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedEvent = authEventPublisher.events.first()
                assertEquals(specialEvent.loginIdentityId, receivedEvent.loginIdentityId)
                assertEquals(specialEvent.event_type, receivedEvent.event_type)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            authEventPublisher.publish(specialEvent)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should maintain event order for sequential publishing")
        fun shouldMaintainEventOrderForSequentialPublishing() = runTest {
            val orderedEvents =
                    (1..10).map { i ->
                        FinverseWebhookEvent(
                                loginIdentityId = "ordered-login-$i",
                                event_type = "AUTHENTICATED",
                                event_time = "2024-01-01T00:00:${i.toString().padStart(2, '0')}Z"
                        )
                    }

            // Start collecting events
            val collectJob = launch {
                val receivedEvents = authEventPublisher.events.take(10).toList()
                assertEquals(10, receivedEvents.size)

                // Verify order is maintained
                orderedEvents.forEachIndexed { index, expectedEvent ->
                    assertEquals(
                            expectedEvent.loginIdentityId,
                            receivedEvents[index].loginIdentityId
                    )
                }
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events sequentially
            orderedEvents.forEach { event ->
                authEventPublisher.publish(event)
                delay(1) // Small delay to ensure order
            }

            // Wait for the collection to complete
            collectJob.join()
        }
    }

    @Nested
    @DisplayName("FinverseProductCompleteEventPublisher Tests")
    inner class FinverseProductCompleteEventPublisherTests {

        private lateinit var productCompleteEventPublisher: FinverseProductCompleteEventPublisher

        @BeforeEach
        fun setUp() {
            productCompleteEventPublisher = FinverseProductCompleteEventPublisher()
        }

        @Test
        @DisplayName("Should publish and receive product completion events")
        fun shouldPublishAndReceiveProductCompletionEvents() = runTest {
            val testStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "test-login-id",
                            success = true,
                            message = "All products retrieved successfully"
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedStatus = productCompleteEventPublisher.events.first()
                assertEquals(testStatus.loginIdentityId, receivedStatus.loginIdentityId)
                assertEquals(testStatus.success, receivedStatus.success)
                assertEquals(testStatus.message, receivedStatus.message)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            productCompleteEventPublisher.publish(testStatus)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle both success and failure completion events")
        fun shouldHandleBothSuccessAndFailureCompletionEvents() = runTest {
            val statusEvents =
                    listOf(
                            FinverseOverallRetrievalStatus(
                                    loginIdentityId = "success-login-1",
                                    success = true,
                                    message = "Successfully retrieved all data"
                            ),
                            FinverseOverallRetrievalStatus(
                                    loginIdentityId = "failure-login-1",
                                    success = false,
                                    message = "Failed to retrieve ACCOUNTS - RETRIEVAL_FAILED"
                            ),
                            FinverseOverallRetrievalStatus(
                                    loginIdentityId = "success-login-2",
                                    success = true,
                                    message = "Partial success but acceptable"
                            )
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedEvents = productCompleteEventPublisher.events.take(3).toList()
                assertEquals(3, receivedEvents.size)

                statusEvents.forEachIndexed { index, expectedStatus ->
                    val receivedStatus = receivedEvents[index]
                    assertEquals(expectedStatus.loginIdentityId, receivedStatus.loginIdentityId)
                    assertEquals(expectedStatus.success, receivedStatus.success)
                    assertEquals(expectedStatus.message, receivedStatus.message)
                }
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events
            statusEvents.forEach { status ->
                productCompleteEventPublisher.publish(status)
                delay(5) // Small delay between events
            }

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle completion events with long messages")
        fun shouldHandleCompletionEventsWithLongMessages() = runTest {
            val longMessage = "A".repeat(1000) // Very long message
            val longMessageStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "long-message-login",
                            success = false,
                            message = longMessage
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedStatus = productCompleteEventPublisher.events.first()
                assertEquals(longMessageStatus.loginIdentityId, receivedStatus.loginIdentityId)
                assertEquals(longMessageStatus.success, receivedStatus.success)
                assertEquals(longMessage, receivedStatus.message)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            productCompleteEventPublisher.publish(longMessageStatus)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should handle rapid completion event publishing")
        fun shouldHandleRapidCompletionEventPublishing() = runTest {
            val numberOfEvents = 30
            val statusEvents =
                    (1..numberOfEvents).map { i ->
                        FinverseOverallRetrievalStatus(
                                loginIdentityId = "rapid-completion-$i",
                                success = i % 2 == 0, // Alternate success/failure
                                message = "Event $i completed"
                        )
                    }

            // Start collecting events
            val collectJob = launch {
                val receivedEvents =
                        productCompleteEventPublisher.events.take(numberOfEvents).toList()
                assertEquals(numberOfEvents, receivedEvents.size)

                // Verify that all events were received
                val receivedLoginIds = receivedEvents.map { it.loginIdentityId }.toSet()
                val expectedLoginIds = statusEvents.map { it.loginIdentityId }.toSet()
                assertEquals(expectedLoginIds, receivedLoginIds)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events rapidly
            statusEvents.forEach { status -> productCompleteEventPublisher.publish(status) }

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should support multiple concurrent subscribers for completion events")
        fun shouldSupportMultipleConcurrentSubscribersForCompletionEvents() = runTest {
            val testStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "concurrent-completion-login",
                            success = true,
                            message = "Concurrent test completion"
                    )

            val numberOfSubscribers = 3
            val subscriberJobs =
                    (1..numberOfSubscribers).map { subscriberId ->
                        launch {
                            val receivedStatus = productCompleteEventPublisher.events.first()
                            assertEquals(testStatus.loginIdentityId, receivedStatus.loginIdentityId)
                            assertEquals(testStatus.success, receivedStatus.success)
                            assertEquals(testStatus.message, receivedStatus.message)
                        }
                    }

            // Give some time for all subscribers to start
            delay(50)

            // Publish the event
            productCompleteEventPublisher.publish(testStatus)

            // Wait for all subscribers to complete
            subscriberJobs.forEach { it.join() }
        }

        @Test
        @DisplayName("Should handle completion events with special characters in messages")
        fun shouldHandleCompletionEventsWithSpecialCharactersInMessages() = runTest {
            val specialStatus =
                    FinverseOverallRetrievalStatus(
                            loginIdentityId = "special-chars-login",
                            success = false,
                            message = "Failed: éñ@#$%^&*() - Special characters in error message"
                    )

            // Start collecting events
            val collectJob = launch {
                val receivedStatus = productCompleteEventPublisher.events.first()
                assertEquals(specialStatus.loginIdentityId, receivedStatus.loginIdentityId)
                assertEquals(specialStatus.success, receivedStatus.success)
                assertEquals(specialStatus.message, receivedStatus.message)
            }

            // Give some time for the collector to start
            delay(10)

            // Publish the event
            productCompleteEventPublisher.publish(specialStatus)

            // Wait for the collection to complete
            collectJob.join()
        }

        @Test
        @DisplayName("Should maintain event order for sequential completion publishing")
        fun shouldMaintainEventOrderForSequentialCompletionPublishing() = runTest {
            val orderedStatuses =
                    (1..8).map { i ->
                        FinverseOverallRetrievalStatus(
                                loginIdentityId = "ordered-completion-$i",
                                success = true,
                                message = "Completion event $i"
                        )
                    }

            // Start collecting events
            val collectJob = launch {
                val receivedEvents = productCompleteEventPublisher.events.take(8).toList()
                assertEquals(8, receivedEvents.size)

                // Verify order is maintained
                orderedStatuses.forEachIndexed { index, expectedStatus ->
                    assertEquals(
                            expectedStatus.loginIdentityId,
                            receivedEvents[index].loginIdentityId
                    )
                    assertEquals(expectedStatus.message, receivedEvents[index].message)
                }
            }

            // Give some time for the collector to start
            delay(10)

            // Publish events sequentially
            orderedStatuses.forEach { status ->
                productCompleteEventPublisher.publish(status)
                delay(2) // Small delay to ensure order
            }

            // Wait for the collection to complete
            collectJob.join()
        }
    }

    @Nested
    @DisplayName("Event Publisher Buffer and Replay Tests")
    inner class EventPublisherBufferAndReplayTests {

        @Test
        @DisplayName("Should replay recent auth events to new subscribers")
        fun shouldReplayRecentAuthEventsToNewSubscribers() = runTest {
            val authEventPublisher = FinverseAuthEventPublisher()

            // Publish some events before any subscribers
            val prePublishedEvents =
                    (1..5).map { i ->
                        FinverseWebhookEvent(
                                loginIdentityId = "pre-published-$i",
                                event_type = "AUTHENTICATED",
                                event_time = "2024-01-01T00:00:${i.toString().padStart(2, '0')}Z"
                        )
                    }

            prePublishedEvents.forEach { event -> authEventPublisher.publish(event) }

            // Now start a subscriber - should receive replayed events
            val collectJob = launch {
                val receivedEvents = authEventPublisher.events.take(5).toList()
                assertEquals(5, receivedEvents.size)

                val receivedLoginIds = receivedEvents.map { it.loginIdentityId }.toSet()
                val expectedLoginIds = prePublishedEvents.map { it.loginIdentityId }.toSet()
                assertEquals(expectedLoginIds, receivedLoginIds)
            }

            collectJob.join()
        }

        @Test
        @DisplayName("Should replay recent completion events to new subscribers")
        fun shouldReplayRecentCompletionEventsToNewSubscribers() = runTest {
            val productCompleteEventPublisher = FinverseProductCompleteEventPublisher()

            // Publish some events before any subscribers
            val prePublishedStatuses =
                    (1..3).map { i ->
                        FinverseOverallRetrievalStatus(
                                loginIdentityId = "pre-published-completion-$i",
                                success = i % 2 == 0,
                                message = "Pre-published completion $i"
                        )
                    }

            prePublishedStatuses.forEach { status -> productCompleteEventPublisher.publish(status) }

            // Now start a subscriber - should receive replayed events
            val collectJob = launch {
                val receivedEvents = productCompleteEventPublisher.events.take(3).toList()
                assertEquals(3, receivedEvents.size)

                val receivedLoginIds = receivedEvents.map { it.loginIdentityId }.toSet()
                val expectedLoginIds = prePublishedStatuses.map { it.loginIdentityId }.toSet()
                assertEquals(expectedLoginIds, receivedLoginIds)
            }

            collectJob.join()
        }

        @Test
        @DisplayName("Should handle buffer overflow correctly")
        fun shouldHandleBufferOverflowCorrectly() = runTest {
            val authEventPublisher = FinverseAuthEventPublisher()

            // Publish more events than the replay buffer can hold (replay = 100)
            val manyEvents =
                    (1..150).map { i ->
                        FinverseWebhookEvent(
                                loginIdentityId = "overflow-$i",
                                event_type = "AUTHENTICATED",
                                event_time = "2024-01-01T00:00:00Z"
                        )
                    }

            manyEvents.forEach { event -> authEventPublisher.publish(event) }

            // Start a subscriber - should receive the most recent events (up to buffer size)
            val collectJob = launch {
                val receivedEvents =
                        authEventPublisher.events.take(100).toList() // Buffer size is 100
                assertTrue(receivedEvents.size <= 100, "Should not receive more than buffer size")

                // Should receive the most recent events
                val receivedLoginIds = receivedEvents.map { it.loginIdentityId }.toSet()
                assertTrue(
                        receivedLoginIds.contains("overflow-150"),
                        "Should contain the most recent event"
                )
            }

            collectJob.join()
        }
    }
}
