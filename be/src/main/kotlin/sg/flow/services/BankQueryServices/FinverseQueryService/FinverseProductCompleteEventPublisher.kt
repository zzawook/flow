package sg.flow.services.BankQueryServices.FinverseQueryService

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.kafka.core.KafkaTemplate
import org.springframework.stereotype.Service
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import java.util.concurrent.CompletableFuture

@Service
class FinverseProductCompleteEventPublisher(
    private val kafkaTemplate: KafkaTemplate<String, Any>,
    @Value("\${flow.kafka.topics.finverse-product-complete}") private val productCompleteTopic: String
) {
    
    private val logger = LoggerFactory.getLogger(FinverseProductCompleteEventPublisher::class.java)

    /** Called when data retrieval is complete */
    suspend fun publish(event: FinverseOverallRetrievalStatus) {
        try {
            val future: CompletableFuture<*> = kafkaTemplate.send(
                productCompleteTopic,
                event.loginIdentityId, // Use loginIdentityId as partition key
                event
            )

            future.whenComplete { result, exception ->
                if (exception == null) {
                    logger.info(
                        "Published product complete event to topic: {} with key: {} success: {}",
                        productCompleteTopic,
                        event.loginIdentityId,
                        event.success
                    )
                } else {
                    logger.error(
                        "Failed to publish product complete event to topic: {} with key: {}",
                        productCompleteTopic,
                        event.loginIdentityId,
                        exception
                    )
                }
            }
        } catch (e: Exception) {
            logger.error("Error publishing product complete event for loginIdentityId: ${event.loginIdentityId}", e)
            throw e
        }
    }
}