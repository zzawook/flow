package sg.flow.services.BankQueryServices.FinverseQueryService

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.ObjectProvider
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.events.TransactionAnalysisTriggerEvent
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseProductRetrieval
import sg.flow.models.finverse.FinverseRetrievalStatus
import sg.flow.services.UtilServices.CacheService.CacheService
import sg.flow.services.UtilServices.CacheService.RedisCacheServiceImpl
import sg.flow.services.UtilServices.CacheService.RedisCompareAndStoreOperation

@Component
class FinverseDataRetrievalRequestsManager(
    private val finverseLoginIdentityService: FinverseLoginIdentityService,
    private val finverseProductCompleteEventPublisher: FinverseProductCompleteEventPublisher,
    private val finverseShouldFetchDecider: FinverseShouldFetchDecider,
    private val finverseResponseProcessor: FinverseResponseProcessor,
    private val finverseWebclientService: FinverseWebclientService,
    private val kafkaEventProducerService:
                sg.flow.services.EventServices.KafkaEventProducerService,
    private val casProvider: ObjectProvider<RedisCompareAndStoreOperation>,
    private val cacheService: RedisCacheServiceImpl
) {
    final val STATUS_PENDING_CALLBACK: String = "PENDING_CALLBACK"
    final val STATUS_ACTIVE: String = "ACTIVE"
    final val STATUS_COMPLETE: String = "COMPLETE"
    final val STATUS_ERRORED: String = "ERRORED"

    private val logger = LoggerFactory.getLogger(FinverseDataRetrievalRequestsManager::class.java)

    @Autowired
    private lateinit var objectMapper: ObjectMapper

    suspend fun createFinverseDataRetrievalEventWithUserIdAndLoginIdentity(
            loginIdentityId: String,
            userId: Int,
            institutionId: String
    ): FinverseDataRetrievalRequest {
        val requestedProduct: List<FinverseProductRetrieval> =
            FinverseProduct.supported.map { it -> FinverseProductRetrieval(it) }
        val finverseDataRetrievalRequest =
            FinverseDataRetrievalRequest(
                loginIdentityId,
                userId,
                institutionId, // UNKNOWN FOR NOW
                requestedProduct,
                STATUS_ACTIVE,
                mutableListOf()
            )

        return finverseDataRetrievalRequest
    }

    suspend fun setFinverseDataRetrievalEventStatusToActive(request: FinverseDataRetrievalRequest, loginIdentityId: String, userId: Int, institutionId: String) {
        val refreshSession = request

        refreshSession.setStatus(STATUS_ACTIVE)
        refreshSession.setUserIdAndInstitutionId(userId, institutionId)
    }

    suspend fun createBlankFinverseDataRetrievalEvent(loginIdentityId: String): FinverseDataRetrievalRequest {
        val requestedProduct: List<FinverseProductRetrieval> =
            FinverseProduct.supported.map { it -> FinverseProductRetrieval(it) }
        val finverseDataRetrievalRequest =
            FinverseDataRetrievalRequest(
                loginIdentityId,
                -1, // UNKNOWN FOR NOW
                "", // UNKNOWN FOR NOW
                requestedProduct,
                STATUS_PENDING_CALLBACK,
                mutableListOf()
            )

        return finverseDataRetrievalRequest
    }

    suspend fun getOverallRetrievalStatus(
            loginIdentityId: String
    ): FinverseOverallRetrievalStatus {
        val userDataRetrievalEvent =
                finverseLoginIdentityService.getRefreshSession(loginIdentityId)
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
        var fetched = false

        val casResult = casProvider.getObject()
            .configure(key=cacheService.getRefreshSessionPrefix(loginIdentityId), createTtlMs = 120 * 1000L, maxRetries = 5)
            .storeWithRetryOnCasReturning(FinverseDataRetrievalRequest::class) { request ->
                val finverseDataRetrievalRequest: FinverseDataRetrievalRequest = request ?: createBlankFinverseDataRetrievalEvent(loginIdentityId)
                finverseDataRetrievalRequest.putOrUpdate(product, status)
                if ((! fetched) && finverseShouldFetchDecider.shouldFetch(finverseDataRetrievalRequest, product, status)) {
                    val loginIdentityToken =
                        finverseLoginIdentityService.getLoginIdentityTokenWithLoginIdentityID(loginIdentityId)
                    product.fetch(
                        loginIdentityId,
                        loginIdentityToken,
                        finverseResponseProcessor,
                        finverseWebclientService
                    )
                    fetched = true
                }
                finverseDataRetrievalRequest
            }

        val finverseDataRetrievalRequest = casResult.value

        if (finverseDataRetrievalRequest == null) {
            logger.error("FinverseDataRetrieval request from CAS Operation was null")
            return
        }

        if (finverseDataRetrievalRequest.isComplete()) {
            finverseLoginIdentityService.finishRefreshSession(loginIdentityId)

            val overallRetrievalStatus = finverseDataRetrievalRequest.getOverallRetrievalStatus()
            finverseProductCompleteEventPublisher.publish(overallRetrievalStatus)
            val userIdAndInstitutionId = finverseLoginIdentityService.getUserIdAndInstitutionId(loginIdentityId)
            if (userIdAndInstitutionId == null) {
                logger.error("Finverse Data Retrieval Request marked complete without Login Identity Fetched. Cannot find user ID and institution ID for login identity")
                return
            }
            val userId = userIdAndInstitutionId.userId
            val institutionId = userIdAndInstitutionId.institutionId

            // Publish transaction analysis trigger event
            try {
                val transactionAnalysisTriggerEvent =
                        TransactionAnalysisTriggerEvent(
                                userId = userId,
                                institutionId = institutionId,
                                loginIdentityId = loginIdentityId
                        )
                kafkaEventProducerService.publishTransactionAnalysisTriggerEvent(
                        transactionAnalysisTriggerEvent
                )
                logger.info(
                        "Successfully published transaction analysis trigger event for userId: {} and institutionId: {}",
                        userId,
                        institutionId
                )
            } catch (e: Exception) {
                logger.error(
                        "Failed to publish transaction analysis trigger event for userId: {} and institutionId: {}, but continuing normal operation",
                        userId,
                        institutionId,
                        e
                )
                // Continue normal operation even if publishing fails
            }
        }
    }
}
