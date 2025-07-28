package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonProperty

class FinverseProductRetrieval @JsonCreator constructor(
    @JsonProperty("product")
    private val product: FinverseProduct,

    @JsonProperty("status")
    private var status: FinverseRetrievalStatus = FinverseRetrievalStatus.NOT_YET,

    @JsonProperty("complete")
    private var complete: Boolean = false
) {
    fun isComplete() = complete
    fun getStatus()  = status
    fun getProduct() = product

    fun setStatus(newStatus: FinverseRetrievalStatus) {
        this.status = newStatus
        if (this.status != FinverseRetrievalStatus.NOT_YET) {
            this.complete = true
        }
    }
}
