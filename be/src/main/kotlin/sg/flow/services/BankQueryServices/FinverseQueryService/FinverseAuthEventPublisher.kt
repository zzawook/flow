package sg.flow.services.BankQueryServices.FinverseQueryService

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Service
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import java.util.concurrent.CompletableFuture

@Service
class FinverseAuthEventPublisher(
    private val kafkaTemplate: KafkaTemplate<String, Any>,
    @Value("\${flow.kafka.topics.finverse-auth-complete}") private val authCompleteTopic: String
) {
    
    private val logger = LoggerFactory.getLogger(FinverseAuthEventPublisher::class.java)

    /** Called by your controller whenever an auth webhook arrives */
    suspend fun publish(event: FinverseWebhookEvent) {
        try {
            val future: CompletableFuture<*> = kafkaTemplate.send(
                authCompleteTopic,
                event.login_identity_id, // Use loginIdentityId as partition key
                event
            )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                        "Published auth event to topic: {} with key: {} for event: {}",
                        authCompleteTopic,
                        event.login_identity_id,
                        event.event_type
                    )
                } else {
                    logger.error(
                        "Failed to publish auth event to topic: {} with key: {}",
                        authCompleteTopic,
                        event.login_identity_id,
                        exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing auth event for loginIdentityId: ${event.login_identity_id}", e)
            throw e
        }
    }
}