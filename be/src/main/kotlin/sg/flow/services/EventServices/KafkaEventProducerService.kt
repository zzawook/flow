package sg.flow.services.EventServices

import java.util.concurrent.CompletableFuture
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.kafka.support.SendResult
import org.springframework.stereotype.Service
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.events.FinverseWebhookEvent
import sg.flow.events.TransactionAnalysisTriggerEvent

@Service
class KafkaEventProducerService(
        private val kafkaTemplate: KafkaTemplate<String, Any>,
        @Value("\${flow.kafka.topics.finverse-webhook}") private val webhookTopic: String,
        @Value("\${flow.kafka.topics.finverse-auth-callback}")
        private val authCallbackTopic: String,
        @Value("\${flow.kafka.topics.finverse-timeout}") private val timeoutTopic: String,
        @Value("\${flow.kafka.topics.transaction-analysis-trigger}")
        private val transactionAnalysisTriggerTopic: String
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
                            event.state.toString(), // Use loginIdentityId as partition key
                            event
                    )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                            "Published auth callback event to topic: {} with key: {} at offset: {}",
                            authCallbackTopic,
                            event.state.toString(),
                            result?.recordMetadata?.offset()
                    )
                } else {
                    logger.error(
                            "Failed to publish auth callback event to topic: {} with key: {}",
                            authCallbackTopic,
                            event.state.toString(),
                            exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing auth callback event", e)
            throw e
        }
    }

    suspend fun publishTransactionAnalysisTriggerEvent(event: TransactionAnalysisTriggerEvent) {
        try {
            val future: CompletableFuture<SendResult<String, Any>> =
                    kafkaTemplate.send(
                            transactionAnalysisTriggerTopic,
                            event.loginIdentityId, // Use loginIdentityId as partition key for
                            // message ordering
                            event
                    )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                            "Published transaction analysis trigger event to topic: {} with key: {} at offset: {} for userId: {} and institutionId: {}",
                            transactionAnalysisTriggerTopic,
                            event.loginIdentityId,
                            result?.recordMetadata?.offset(),
                            event.userId,
                            event.institutionId
                    )
                } else {
                    logger.error(
                            "Failed to publish transaction analysis trigger event to topic: {} with key: {} for userId: {} and institutionId: {}",
                            transactionAnalysisTriggerTopic,
                            event.loginIdentityId,
                            event.userId,
                            event.institutionId,
                            exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error(
                    "Error publishing transaction analysis trigger event for userId: {} and institutionId: {}",
                    event.userId,
                    event.institutionId,
                    e
            )
            throw e
        }
    }
}
