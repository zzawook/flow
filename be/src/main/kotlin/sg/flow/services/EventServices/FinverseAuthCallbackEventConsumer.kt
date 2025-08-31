package sg.flow.services.EventServices

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.ObjectProvider
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataRetrievalRequestsManager
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityService
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.CacheService.RedisCacheServiceImpl
import sg.flow.services.UtilServices.CacheService.RedisCompareAndStoreOperation
import sg.flow.services.UtilServices.UserIdAndInstitutionId

@Service
class FinverseAuthCallbackEventConsumer(
    private val finverseService: FinverseQueryService,
    private val finverseLoginIdentityService: FinverseLoginIdentityService,
    private val finverseDataRetrievalRequestsManager: FinverseDataRetrievalRequestsManager,
    private val casProvider: ObjectProvider<RedisCompareAndStoreOperation>,
    private val cacheService: RedisCacheServiceImpl
) {

    private val logger = LoggerFactory.getLogger(FinverseAuthCallbackEventConsumer::class.java)

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    @KafkaListener(
            topics = ["\${flow.kafka.topics.finverse-auth-callback}"],
            groupId = "\${spring.kafka.consumer.group-id}",
            containerFactory = "authCallbackKafkaListenerContainerFactory"
    )
        suspend fun handleAuthCallbackEvent(event: FinverseAuthCallbackEvent, acknowledgment: Acknowledgment) {
        try {
            logger.info("Processing auth callback event: {}", event.eventId)

            val userIdAndInstitutionId = finverseLoginIdentityService.getUserIdAndInstitutionIdFromState(event.state)

            finverseLoginIdentityService.clearPreAuthSession(event.state)

            val loginIdentityId = finverseService.fetchLoginIdentityToken(
                userId = userIdAndInstitutionId.userId,
                code = event.code,
                institutionId = event.institutionId
            )

            finverseLoginIdentityService.storePostAuthResult(userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId, FinverseAuthenticationStatus.AUTHENTICATED)

            updateFinverseDataRetrievalRequestForCallback(loginIdentityId, userIdAndInstitutionId)
            
            // Acknowledge the message after successful processing
            acknowledgment.acknowledge()
            logger.info("Successfully processed auth callback event: {}", event.eventId)
        } catch (e: Exception) {
            logger.error("Error processing auth callback event: {}", event.eventId, e)
            // Don't acknowledge on error - this will trigger retry mechanism
            throw e
        }
    }

    private suspend fun updateFinverseDataRetrievalRequestForCallback(loginIdentityId: String, userIdAndInstitutionId: UserIdAndInstitutionId) {
        casProvider.getObject()
            .configure(key=cacheService.getRefreshSessionPrefix(loginIdentityId), createTtlMs = 120 * 1000L, maxRetries = 5)
            .storeWithRetryOnCasReturning(FinverseDataRetrievalRequest::class) { jsonStr ->
                var finverseDataRetrievalRequest: FinverseDataRetrievalRequest
                if (jsonStr == null) {
                    finverseDataRetrievalRequest = finverseDataRetrievalRequestsManager.createFinverseDataRetrievalEventWithUserIdAndLoginIdentity(loginIdentityId, userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)
                    logger.info("ADDING CALLBACK RESULTS")
                    finverseDataRetrievalRequest
                } else {
                    try {
                        finverseDataRetrievalRequest = jsonStr
                        finverseDataRetrievalRequestsManager.setFinverseDataRetrievalEventStatusToActive(finverseDataRetrievalRequest, loginIdentityId, userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)
                        logger.info("ADDING CALLBACK RESULTS")
                        finverseDataRetrievalRequest
                    } catch (e: Exception) {
                        e.printStackTrace()
                        logger.info("ADDING CALLBACK RESULTS")
                        finverseDataRetrievalRequestsManager.createFinverseDataRetrievalEventWithUserIdAndLoginIdentity(loginIdentityId, userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)
                    }
                }

            }

        // We can assure the session has been created and set to ACTIVE in redis at this point
        var hasMoreBuffered = true
        while (hasMoreBuffered) {
            casProvider.getObject()
                .configure(key=cacheService.getRefreshSessionPrefix(loginIdentityId), createTtlMs = 120 * 1000L, maxRetries = 5)
                .storeWithRetryOnCasReturning(FinverseDataRetrievalRequest::class) { request ->
                    val finverseDataRetrievalRequest = request

                    if (finverseDataRetrievalRequest != null) {
                        if (finverseDataRetrievalRequest.getStatus() == "PENDING_CALLBACK") {
                            finverseDataRetrievalRequest
                        }
                        if (! finverseDataRetrievalRequest.getBuffered().isEmpty()) {
                            val firstBuffered = finverseDataRetrievalRequest.getBuffered().first()
                            finverseDataRetrievalRequest.putOrUpdate(firstBuffered.product, firstBuffered.status)
                            finverseDataRetrievalRequest.removeFromBuffer(firstBuffered)
                        }

                        if (finverseDataRetrievalRequest.getBuffered().isEmpty()) {
                            hasMoreBuffered = false
                        }
                        finverseDataRetrievalRequest
                    } else {
                        logger.error("FinverseDataRetrievalRequest in CAS Operation was null")
                        finverseDataRetrievalRequestsManager.createFinverseDataRetrievalEventWithUserIdAndLoginIdentity(loginIdentityId, userIdAndInstitutionId.userId, userIdAndInstitutionId.institutionId)
                    }
                }
        }

    }
}
