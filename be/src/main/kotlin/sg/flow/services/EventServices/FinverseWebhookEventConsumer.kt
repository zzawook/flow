package sg.flow.services.EventServices

import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.events.FinverseWebhookEvent
import sg.flow.models.finverse.FinverseAuthenticationEventTypeParser
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseEventTypeParser
import sg.flow.models.finverse.FinverseProduct
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseAuthCache
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataRetrievalRequestsManager

@Service
class FinverseWebhookEventConsumer(
        private val finverseDataRetrievalRequestsManager: FinverseDataRetrievalRequestsManager,
        private val finverseAuthCache: FinverseAuthCache
) {

    private val logger = LoggerFactory.getLogger(FinverseWebhookEventConsumer::class.java)

    @KafkaListener(
            topics = ["\${flow.kafka.topics.finverse-webhook}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "webhookKafkaListenerContainerFactory"
    )
        suspend fun handleWebhookEvent(event: FinverseWebhookEvent, acknowledgment: Acknowledgment) {
        try {
            logger.info("Processing webhook event: {}", event.eventId)
            
            if (isAuthenticationEvent(event.eventType)) {
                FinverseAuthenticationEventTypeParser.parse(event.eventType)?.let { authStatus ->
                    val userIdAndInstitutionId = finverseAuthCache.getUserIdAndInstitutionId(event.loginIdentityId)
                    finverseAuthCache.storePostAuthResult(userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId, authStatus)

                    if (authStatus == FinverseAuthenticationStatus.AUTHENTICATED) {
//                        finverseDataRetrievalRequestsManager.registerFinverseDataRetrievalEvent(event.loginIdentityId)
                    }
                }
            } else {
                FinverseEventTypeParser.parse(event.eventType).let { ps ->
                    if (ps.product in FinverseProduct.supported) {
                        finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(
                            event.loginIdentityId, 
                            ps.product, 
                            ps.status
                        )
                    }
                }
            }
            
            // Acknowledge the message after successful processing
            acknowledgment.acknowledge()
            logger.info("Successfully processed webhook event: {}", event.eventId)
        } catch (e: Exception) {
            logger.error("Error processing webhook event: {}", event.eventId, e)
            // Don't acknowledge on error - this will trigger retry mechanism
            throw e
        }
    }

    private fun isAuthenticationEvent(eventType: String): Boolean {
        val authenticationEventTypes =
                listOf(
                        "AUTHENTICATED",
                        "AUTHENTICATION_FAILED",
                        "AUTHENTICATION_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION",
                        "AUTHENTICATION_TOO_MANY_ATTEMPTS"
                )
        return authenticationEventTypes.contains(eventType)
    }
}
