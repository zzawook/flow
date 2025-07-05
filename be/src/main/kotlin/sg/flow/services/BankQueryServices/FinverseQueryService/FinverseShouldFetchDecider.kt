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
            FinverseProduct.ONLINE_TRANSACTIONS ->
                shouldFetchTransaction(finverseDataRetrievalRequest)
            FinverseProduct.ACCOUNTS ->
                shouldFetchAccountNumber(finverseDataRetrievalRequest)
            else -> return true
        }
    }

    private fun shouldFetchTransaction(
            finverseDataRetrievalRequest: FinverseDataRetrievalRequest
    ): Boolean {
        return finverseDataRetrievalRequest.isBothTransactionComplete()
    }

    private fun shouldFetchAccountNumber(finverseDataRetrievalRequest: FinverseDataRetrievalRequest): Boolean {
        return finverseDataRetrievalRequest.isAccountComplete()
    }

    private fun shouldFetchAccount(finverseDataRetrievalRequest: FinverseDataRetrievalRequest): Boolean {
        return finverseDataRetrievalRequest.isAccountNumberComplete()
    }
}
