package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseProductRetrieval
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
            loginIdentityId: String,
    ) {
        val userIdAndInstitutionId = cacheService.getUserIdAndInstitutionIdByLoginIdentityId(loginIdentityId).get()

        val userId = userIdAndInstitutionId.userId
        val institutionId = userIdAndInstitutionId.institutionId

        val requestedProduct: List<FinverseProductRetrieval> = FinverseProduct.supported.map { it -> FinverseProductRetrieval(it) }
        val finverseDataRetrievalRequest = FinverseDataRetrievalRequest(
            loginIdentityId,
            userId,
            institutionId,
            requestedProduct,
        )

        // Store the request in Redis cache
        cacheService.startRefreshSession(userId, institutionId, finverseDataRetrievalRequest)
    }

    suspend fun isUserComplete(userId: Int, institutionId: String): Boolean {
        val userDataRetrievalEvent = cacheService.getDataRetrievalRequest(userId, institutionId) ?: return false
        return userDataRetrievalEvent.isComplete()
    }

    suspend fun getOverallRetrievalStatus(
            userId: Int,
            institutionId: String,
            loginIdentityId: String
    ): FinverseOverallRetrievalStatus {
        val userDataRetrievalEvent = cacheService.getDataRetrievalRequest(userId, institutionId)
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
        val userIdAndInstitutionId = finverseAuthCache.getUserIdAndInstitutionId(loginIdentityId)
        val userId = userIdAndInstitutionId.userId
        val institutionId = userIdAndInstitutionId.institutionId
        val loginIdentityToken = finverseAuthCache.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)

        if (userId < 0) {
            // If user ID is missing, it means loginIdentityId is no longer valid, stop processing and discard the webhook
            return
        }
        
        val finverseDataRetrievalRequest = cacheService.getDataRetrievalRequest(userId, institutionId)
        if (finverseDataRetrievalRequest == null) {
            // If Data Retrieval Request does not exist, it means Data Retrieval Session has expired. Stop processing and discard webhook
            println("Discarding webhook as Finverse Data Retrieval Request is not found. Possibly due to Refresh session has expired")
            return
        }

        finverseDataRetrievalRequest.putOrUpdate(product, status)
        
        // Update the request in cache
        cacheService.updateDataRetrievalRequest(userId, institutionId, finverseDataRetrievalRequest)


        if (finverseShouldFetchDecider.shouldFetch(finverseDataRetrievalRequest, product, status)) {
            product.fetch(
                loginIdentityId,
                loginIdentityToken,
                finverseResponseProcessor,
                finverseWebClient
            )
        }

        if (isUserComplete(userId, institutionId)) {
            finverseAuthCache.finishRefreshSession(userId, finverseDataRetrievalRequest.getInstitutionId())

            val overallRetrievalStatus = getOverallRetrievalStatus(userId, institutionId, loginIdentityId)
            finverseProductCompleteEventPublisher.publish(overallRetrievalStatus)
            
            // Remove completed request from cache
            cacheService.clearRefreshSessionCache(userId, institutionId)
        }
    }
}
