package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseRetrievalStatus
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

@Component
class FinverseDataRetrievalRequestsManager(
    private val finverseAuthCache: FinverseAuthCache,
    private val finverseProductCompleteEventPublisher: FinverseProductCompleteEventPublisher,
    private val finverseShouldFetchDecider: FinverseShouldFetchDecider,
    private val finverseProductFetchManager: FinverseProductFetchManager
) {
    private val userIdToFinverseDataRetrievalRequestMap: HashMap<Int, FinverseDataRetrievalRequest> = hashMapOf()

    fun registerFinverseDataRetrievalEvent(userId: Int, finverseDataRetrievalRequest: FinverseDataRetrievalRequest) {
        userIdToFinverseDataRetrievalRequestMap[userId] = finverseDataRetrievalRequest
    }

    fun isUserComplete(userId: Int): Boolean {
        val userDataRetrievalEvent = userIdToFinverseDataRetrievalRequestMap[userId] ?: return false

        return userDataRetrievalEvent.isComplete()
    }

    suspend fun getOverallRetrievalStatus(userId: Int, loginIdentityId: String) : FinverseOverallRetrievalStatus {
        val userDataRetrievalEvent = userIdToFinverseDataRetrievalRequestMap[userId] ?: return FinverseOverallRetrievalStatus(
            success = false,
            message = "CANNOT FIND REGISTERED DATA RETRIEVAL EVENT",
            loginIdentityId = loginIdentityId
        )

        return userDataRetrievalEvent.getOverallRetrievalStatus()
    }

    suspend fun updateAndFetchIfSuccess(loginIdentityId: String, product: FinverseProduct, status: FinverseRetrievalStatus) {
        val userId = finverseAuthCache.getUserId(loginIdentityId)

        if (userId < 0) {
            return
        }
        val finverseDataRetrievalRequest = userIdToFinverseDataRetrievalRequestMap[userId]

        if (finverseDataRetrievalRequest == null) {
            throw FinverseException("Could not find update request")
        }

        finverseDataRetrievalRequest.putOrUpdate(product, status)

        if (finverseShouldFetchDecider.shouldFetch(finverseDataRetrievalRequest, product, status)) {
            finverseProductFetchManager.fetch(finverseDataRetrievalRequest, product)
        }

        if (isUserComplete(userId)) {
            val overallRetrievalStatus = getOverallRetrievalStatus(userId, loginIdentityId)
            finverseProductCompleteEventPublisher.publish(overallRetrievalStatus)
        }
    }
}