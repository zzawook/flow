package sg.flow.models.finverse

class FinverseProductRetrieval(private val FinverseProduct: FinverseProduct) {
    private var isComplete = false
    private var status: FinverseRetrievalStatus = FinverseRetrievalStatus.NOT_YET

    fun isComplete(): Boolean {
        return isComplete
    }

    fun setStatus(status: FinverseRetrievalStatus) {
        this.status = status
        if (this.status != FinverseRetrievalStatus.NOT_YET) {
            this.isComplete = true
        }
    }

    fun getStatus(): FinverseRetrievalStatus {
        return status
    }

    fun getProduct(): FinverseProduct {
        return FinverseProduct
    }
}
