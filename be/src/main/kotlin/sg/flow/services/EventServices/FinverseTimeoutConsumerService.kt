package sg.flow.services.EventServices

import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.events.FinverseTimeoutEvent
import sg.flow.events.TimeoutType
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseAuthCache
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseResponseProcessor
import sg.flow.services.UtilServices.CacheService

@Service
class FinverseTimeoutConsumerService(
        private val cacheService: CacheService,
        private val finverseAuthCache: FinverseAuthCache,
        private val finverseResponseProcessor: FinverseResponseProcessor,
        private val finverseWebClient: WebClient
) {

    private val logger = LoggerFactory.getLogger(FinverseTimeoutConsumerService::class.java)

    @KafkaListener(
            topics = ["\${flow.kafka.topics.finverse-timeout}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "timeoutKafkaListenerContainerFactory"
    )
    suspend fun handleTimeoutEvent(event: FinverseTimeoutEvent, acknowledgment: Acknowledgment) {
        try {
            logger.info("Processing timeout event: {} for user {}", event.timeoutType, event.userId)

            when (event.timeoutType) {
                TimeoutType.THREE_MINUTE_WARNING -> handleThreeMinuteTimeout(event)
                TimeoutType.FIVE_MINUTE_EXPIRY -> handleFiveMinuteTimeout(event)
            }

            acknowledgment.acknowledge()
            logger.info(
                    "Successfully processed timeout event: {} for user {}",
                    event.timeoutType,
                    event.userId
            )
        } catch (e: Exception) {
            logger.error(
                    "Error processing timeout event for user {}: {}",
                    event.userId,
                    e.message,
                    e
            )
            throw e
        }
    }

    private suspend fun handleThreeMinuteTimeout(event: FinverseTimeoutEvent) {
        logger.info("Handling 3-minute timeout for user {}", event.userId)

        // Get the current data retrieval request
        val dataRetrievalRequest = cacheService.getDataRetrievalRequest(event.userId)
        if (dataRetrievalRequest == null) {
            logger.info(
                    "No data retrieval request found for user {} - may have already completed",
                    event.userId
            )
            return
        }

        // Check if already complete
        if (dataRetrievalRequest.isComplete()) {
            logger.info("Data retrieval request already complete for user {}", event.userId)
            return
        }

        // Get login identity token for fetching
        val loginIdentityToken =
                try {
                    finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(
                            event.loginIdentityId
                    )
                } catch (e: Exception) {
                    logger.error(
                            "Could not get login identity token for user {}: {}",
                            event.userId,
                            e.message
                    )
                    return
                }

        // Auto-fetch all incomplete products
        logger.info("Auto-fetching incomplete products for user {}", event.userId)
        for (productRetrieval in dataRetrievalRequest.getRequestedProducts()) {
            if (!productRetrieval.isComplete()) {
                try {
                    val product = productRetrieval.getProduct()
                    logger.info("Auto-fetching {} for user {}", product.productName, event.userId)

                    product.fetch(
                            event.loginIdentityId,
                            loginIdentityToken,
                            finverseResponseProcessor,
                            finverseWebClient
                    )
                } catch (e: Exception) {
                    logger.error(
                            "Error auto-fetching {} for user {}: {}",
                            productRetrieval.getProduct().productName,
                            event.userId,
                            e.message
                    )
                }
            }
        }

        // Clear refresh session cache
        try {
            cacheService.clearRefreshSessionCache(event.userId, event.institutionId)
            logger.info(
                    "Cleared refresh session cache for user {} institution {}",
                    event.userId,
                    event.institutionId
            )
        } catch (e: Exception) {
            logger.error(
                    "Error clearing refresh session cache for user {}: {}",
                    event.userId,
                    e.message
            )
        }
    }

    private suspend fun handleFiveMinuteTimeout(event: FinverseTimeoutEvent) {
        logger.info("Handling 5-minute timeout for user {}", event.userId)

        // Remove from memory completely (Redis cache with TTL should handle this automatically,
        // but we'll be explicit for safety)
        try {
            cacheService.removeDataRetrievalRequest(event.userId)
            logger.info("Removed data retrieval request from cache for user {}", event.userId)
        } catch (e: Exception) {
            logger.error(
                    "Error removing data retrieval request for user {}: {}",
                    event.userId,
                    e.message
            )
        }

        // Also ensure refresh session is cleared
        try {
            cacheService.clearRefreshSessionCache(event.userId, event.institutionId)
            logger.info(
                    "Ensured refresh session cache cleared for user {} institution {}",
                    event.userId,
                    event.institutionId
            )
        } catch (e: Exception) {
            logger.error(
                    "Error ensuring refresh session cache cleared for user {}: {}",
                    event.userId,
                    e.message
            )
        }
    }
}
