package sg.flow.services.EventServices

import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseAuthCache
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@Service
class FinverseAuthCallbackEventConsumer(
    private val finverseService: FinverseQueryService,
    private val finverseAuthCache: FinverseAuthCache
) {

    private val logger = LoggerFactory.getLogger(FinverseAuthCallbackEventConsumer::class.java)

    @KafkaListener(
            topics = ["\${flow.kafka.topics.finverse-auth-callback}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "authCallbackKafkaListenerContainerFactory"
    )
        suspend fun handleAuthCallbackEvent(event: FinverseAuthCallbackEvent, acknowledgment: Acknowledgment) {
        try {
            logger.info("Processing auth callback event: {}", event.eventId)

            val userIdAndInstitutionId = finverseAuthCache.getUserIdAndInstitutionIdFromState(event.state)

            finverseAuthCache.clearPreAuthSession(event.state)
            
            // Call the original service method
            finverseService.fetchLoginIdentityToken(
                userId = userIdAndInstitutionId.userId,
                code = event.code,
                institutionId = event.institutionId
            )
            
            // Acknowledge the message after successful processing
            acknowledgment.acknowledge()
            logger.info("Successfully processed auth callback event: {}", event.eventId)
        } catch (e: Exception) {
            logger.error("Error processing auth callback event: {}", event.eventId, e)
            // Don't acknowledge on error - this will trigger retry mechanism
            throw e
        }
    }
}
