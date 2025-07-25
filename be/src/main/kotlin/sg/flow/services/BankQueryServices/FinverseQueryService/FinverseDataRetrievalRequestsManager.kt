package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseRetrievalStatus
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException
import sg.flow.services.UtilServices.CacheService

@Component
class FinverseDataRetrievalRequestsManager(
        private val finverseAuthCache: FinverseAuthCache,
        private val finverseProductCompleteEventPublisher: FinverseProductCompleteEventPublisher,
        private val finverseShouldFetchDecider: FinverseShouldFetchDecider,
        private val finverseResponseProcessor: FinverseResponseProcessor,
        private val finverseWebClient: WebClient,
        private val cacheService: CacheService,
        private val kafkaEventProducerService: sg.flow.services.EventServices.KafkaEventProducerService
) {

    suspend fun registerFinverseDataRetrievalEvent(
            userId: Int,
            finverseDataRetrievalRequest: FinverseDataRetrievalRequest
    ) {
        // Store the request in Redis cache
        cacheService.storeDataRetrievalRequest(userId, finverseDataRetrievalRequest)
        
        // Schedule timeout events
        kafkaEventProducerService.scheduleTimeouts(
            userId = userId,
            loginIdentityId = finverseDataRetrievalRequest.getLoginIdentityId(),
            institutionId = finverseDataRetrievalRequest.getInstitutionId()
        )
    }

    suspend fun isUserComplete(userId: Int): Boolean {
        val userDataRetrievalEvent = cacheService.getDataRetrievalRequest(userId) ?: return false
        return userDataRetrievalEvent.isComplete()
    }

    suspend fun getOverallRetrievalStatus(
            userId: Int,
            loginIdentityId: String
    ): FinverseOverallRetrievalStatus {
        val userDataRetrievalEvent = cacheService.getDataRetrievalRequest(userId)
                ?: return FinverseOverallRetrievalStatus(
                        success = false,
                        message = "CANNOT FIND REGISTERED DATA RETRIEVAL EVENT",
                        loginIdentityId = loginIdentityId
                )

        return userDataRetrievalEvent.getOverallRetrievalStatus()
    }

    suspend fun updateAndFetchIfSuccess(
            loginIdentityId: String,
            product: FinverseProduct,
            status: FinverseRetrievalStatus
    ) {
        val userId = finverseAuthCache.getUserId(loginIdentityId)
        val loginIdentityToken = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)

        if (userId < 0) {
            // If user ID is missing, it means loginIdentityId is no longer valid, stop processing and discard the webhook
            return
        }
        
        val finverseDataRetrievalRequest = cacheService.getDataRetrievalRequest(userId)
        if (finverseDataRetrievalRequest == null) {
            throw FinverseException("Could not find update request")
        }

        finverseDataRetrievalRequest.putOrUpdate(product, status)
        
        // Update the request in cache
        cacheService.updateDataRetrievalRequest(userId, finverseDataRetrievalRequest)

        println(product.productName)
        println(finverseShouldFetchDecider.shouldFetch(finverseDataRetrievalRequest, product, status))

        if (finverseShouldFetchDecider.shouldFetch(finverseDataRetrievalRequest, product, status)) {
            product.fetch(
                loginIdentityId,
                loginIdentityToken,
                finverseResponseProcessor,
                finverseWebClient
            )
        }

        if (isUserComplete(userId)) {
            finverseAuthCache.finishRefreshSession(userId, finverseDataRetrievalRequest.getInstitutionId())

            val overallRetrievalStatus = getOverallRetrievalStatus(userId, loginIdentityId)
            finverseProductCompleteEventPublisher.publish(overallRetrievalStatus)
            
            // Remove completed request from cache
            cacheService.removeDataRetrievalRequest(userId)
        }
    }
}
