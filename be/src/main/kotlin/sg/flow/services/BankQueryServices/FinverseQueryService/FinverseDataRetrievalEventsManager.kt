package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseDataRetrievalEvent
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseRetrievalStatus

@Component
class FinverseDataRetrievalEventsManager(
    private val finverseAuthCache: FinverseAuthCache,
    private val finverseProductCompleteEventPublisher: FinverseProductCompleteEventPublisher
) {
    private val userIdToFinverseDataRetrievalEventMap: HashMap<Int, FinverseDataRetrievalEvent> = hashMapOf()

    fun registerFinverseDataRetrievalEvent(userId: Int, finverseDataRetrievalEvent: FinverseDataRetrievalEvent) {
        userIdToFinverseDataRetrievalEventMap[userId] = finverseDataRetrievalEvent
    }

    fun isUserComplete(userId: Int): Boolean {
        val userDataRetrievalEvent = userIdToFinverseDataRetrievalEventMap[userId] ?: return false

        return userDataRetrievalEvent.isComplete()
    }

    suspend fun getOverallRetrievalStatus(userId: Int, loginIdentityId: String) : FinverseOverallRetrievalStatus {
        val userDataRetrievalEvent = userIdToFinverseDataRetrievalEventMap[userId] ?: return FinverseOverallRetrievalStatus(
            success = false,
            message = "CANNOT FIND REGISTERED DATA RETRIEVAL EVENT",
            loginIdentityId = loginIdentityId
        )

        return userDataRetrievalEvent.getOverallRetrievalStatus()
    }

    suspend fun update(loginIdentityId: String, product: FinverseProduct, status: FinverseRetrievalStatus) {
        val userId = finverseAuthCache.getUserId(loginIdentityId)

        if (userId < 0) {
            return
        }
        val finverseDataRetrievalEvent = userIdToFinverseDataRetrievalEventMap[userId]

        finverseDataRetrievalEvent?.putOrUpdate(product, status)

        if (isUserComplete(userId)) {
            val overallRetrievalStatus = getOverallRetrievalStatus(userId, loginIdentityId)
            finverseProductCompleteEventPublisher.publish(overallRetrievalStatus)
        }
    }
}