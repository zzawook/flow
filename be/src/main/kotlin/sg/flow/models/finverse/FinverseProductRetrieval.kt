package sg.flow.models.finverse

class FinverseProductRetrieval(private val finverseProduct: FinverseProduct) {
    private var isComplete = false
    private var status: FinverseRetrievalStatus = FinverseRetrievalStatus.PARTIALLY_RETRIEVED

    fun isComplete(): Boolean {
        return isComplete
    }

    fun setStatus(status: FinverseRetrievalStatus) {
        this.status = status
    }

    fun getStatus(): FinverseRetrievalStatus {
        return status
    }

    fun getProduct(): FinverseProduct {
        return finverseProduct
    }
}