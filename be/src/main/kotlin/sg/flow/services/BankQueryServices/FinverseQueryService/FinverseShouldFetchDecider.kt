package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Service
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseRetrievalStatus

@Service
class FinverseShouldFetchDecider() {
    fun shouldFetch(
            finverseDataRetrievalRequest: FinverseDataRetrievalRequest,
            product: FinverseProduct,
            status: FinverseRetrievalStatus
    ): Boolean {
        if (status != FinverseRetrievalStatus.RETRIEVED) return false
        return when (product) {
            FinverseProduct.ACCOUNTS ->
                shouldFetchAccount(finverseDataRetrievalRequest)
            FinverseProduct.ACCOUNT_NUMBERS ->
                shouldFetchAccount(finverseDataRetrievalRequest)
            else -> return true
        }
    }

    private fun shouldFetchAccount(finverseDataRetrievalRequest: FinverseDataRetrievalRequest): Boolean {
        return finverseDataRetrievalRequest.isAccountNumberComplete() && finverseDataRetrievalRequest.isAccountComplete()
    }
}
