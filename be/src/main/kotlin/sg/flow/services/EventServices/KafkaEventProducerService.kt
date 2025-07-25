package sg.flow.services.EventServices

import java.time.Instant
import java.util.concurrent.CompletableFuture
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.kafka.support.SendResult
import org.springframework.stereotype.Service
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.events.FinverseTimeoutEvent
import sg.flow.events.FinverseWebhookEvent
import sg.flow.events.TimeoutType

@Service
class KafkaEventProducerService(
        private val kafkaTemplate: KafkaTemplate<String, Any>,
        @Value("\${flow.kafka.topics.finverse-webhook}") private val webhookTopic: String,
        @Value("\${flow.kafka.topics.finverse-auth-callback}")
        private val authCallbackTopic: String,
        @Value("\${flow.kafka.topics.finverse-timeout}") private val timeoutTopic: String
) {

    private val logger = LoggerFactory.getLogger(KafkaEventProducerService::class.java)
    private val scope = CoroutineScope(Dispatchers.Default)

    suspend fun publishWebhookEvent(event: FinverseWebhookEvent) {
        try {
            val future: CompletableFuture<SendResult<String, Any>> =
                    kafkaTemplate.send(
                            webhookTopic,
                            event.loginIdentityId, // Use loginIdentityId as partition key
                            event
                    )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                            "Published webhook event to topic: {} with key: {} at offset: {}",
                            webhookTopic,
                            event.loginIdentityId,
                            result?.recordMetadata?.offset()
                    )
                } else {
                    logger.error(
                            "Failed to publish webhook event to topic: {} with key: {}",
                            webhookTopic,
                            event.loginIdentityId,
                            exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing webhook event", e)
            throw e
        }
    }

    suspend fun publishAuthCallbackEvent(event: FinverseAuthCallbackEvent) {
        try {
            val future: CompletableFuture<SendResult<String, Any>> =
                    kafkaTemplate.send(
                            authCallbackTopic,
                            event.userId.toString(), // Use loginIdentityId as partition key
                            event
                    )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                            "Published auth callback event to topic: {} with key: {} at offset: {}",
                            authCallbackTopic,
                            event.userId.toString(),
                            result?.recordMetadata?.offset()
                    )
                } else {
                    logger.error(
                            "Failed to publish auth callback event to topic: {} with key: {}",
                            authCallbackTopic,
                            event.userId.toString(),
                            exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing auth callback event", e)
            throw e
        }
    }

    suspend fun scheduleTimeouts(
            userId: Int,
            loginIdentityId: String,
            institutionId: String,
            requestStartTime: Instant = Instant.now()
    ) {
        // Schedule 3-minute timeout
        scope.launch {
            delay(3 * 60 * 1000L) // 3 minutes
            publishTimeoutEvent(
                    FinverseTimeoutEvent(
                            userId = userId,
                            loginIdentityId = loginIdentityId,
                            institutionId = institutionId,
                            timeoutType = TimeoutType.THREE_MINUTE_WARNING,
                            requestStartTime = requestStartTime
                    )
            )
        }

        // Schedule 5-minute timeout
        scope.launch {
            delay(5 * 60 * 1000L) // 5 minutes
            publishTimeoutEvent(
                    FinverseTimeoutEvent(
                            userId = userId,
                            loginIdentityId = loginIdentityId,
                            institutionId = institutionId,
                            timeoutType = TimeoutType.FIVE_MINUTE_EXPIRY,
                            requestStartTime = requestStartTime
                    )
            )
        }

        logger.info("Scheduled timeout events for user $userId, institution $institutionId")
    }

    private suspend fun publishTimeoutEvent(event: FinverseTimeoutEvent) {
        try {
            val future: CompletableFuture<SendResult<String, Any>> =
                    kafkaTemplate.send(
                            timeoutTopic,
                            "${event.userId}:${event.institutionId}", // Use user-institution as
                            // partition key
                            event
                    )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                            "Published timeout event: {} for user {} at {}",
                            event.timeoutType,
                            event.userId,
                            event.timestamp
                    )
                } else {
                    logger.error(
                            "Failed to publish timeout event for user {}",
                            event.userId,
                            exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing timeout event for user ${event.userId}", e)
        }
    }
}
