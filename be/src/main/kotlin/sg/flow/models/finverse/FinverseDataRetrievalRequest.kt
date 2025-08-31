package sg.flow.models.finverse

import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonProperty
import org.slf4j.LoggerFactory

class FinverseDataRetrievalRequest(
        @JsonProperty("loginIdentityId")
        private val loginIdentityId: String,
        @JsonProperty("userId")
        private var userId: Int,
        @JsonProperty("institutionId")
        private var institutionId: String,
        @JsonProperty("requestedProducts")
        private val requestedProducts: List<FinverseProductRetrieval>,
        @JsonProperty("status")
        private var status: String,
        @JsonProperty("buffer")
        private val buffer: MutableList<FinverseDataRetrievalBufferItem>
) {
    @JsonIgnore
    val logger = LoggerFactory.getLogger(FinverseDataRetrievalRequest::class.java)

    fun isComplete(): Boolean {
        if (status == "PENDING_CALLBACK") {
            return false
        }
        for (finverseProductRetrieval in requestedProducts) {
            if (!finverseProductRetrieval.isComplete()) {
                return false
            }
        }

        return true
    }

    @JsonIgnore
    fun getBuffered(): List<FinverseDataRetrievalBufferItem> {
        return this.buffer
    }

    fun setUserIdAndInstitutionId(userId: Int, institutionId: String) {
        this.userId = userId
        this.institutionId = institutionId
    }

    fun removeFromBuffer(item: FinverseDataRetrievalBufferItem) {
        this.buffer.remove(item)
    }

    fun getStatus(): String {
        return status
    }

    fun setStatus(status: String) {
        this.status = status
    }

    fun getLoginIdentityId(): String {
        return loginIdentityId
    }

    fun getInstitutionId(): String {
        return institutionId
    }

    fun getOverallRetrievalStatus(): FinverseOverallRetrievalStatus {
        val allowedList: List<FinverseRetrievalStatus> =
                listOf(
                        FinverseRetrievalStatus.RETRIEVED,
                        FinverseRetrievalStatus.PARTIALLY_RETRIEVED
                )

        for (finverseProductRetrieval in requestedProducts) {
            val thisStatus = finverseProductRetrieval.getStatus()
            if (!allowedList.contains(thisStatus)) {
                return FinverseOverallRetrievalStatus(
                        success = false,
                        message =
                                "${finverseProductRetrieval.getProduct().productName} - $thisStatus",
                        loginIdentityId = loginIdentityId
                )
            }
        }

        return FinverseOverallRetrievalStatus(
                success = true,
                message = "$userId - $institutionId - ${requestedProducts.size}",
                loginIdentityId = loginIdentityId
        )
    }

    fun isBothTransactionComplete(): Boolean {
        var isOnlineTransactionComplete = false
        var isHistoryTransactionComplete = false

        for (finverseProductRetrieval in requestedProducts) {
            when (finverseProductRetrieval.getProduct()) {
                FinverseProduct.ONLINE_TRANSACTIONS -> {
                    isOnlineTransactionComplete = finverseProductRetrieval.isComplete()
                }
                FinverseProduct.HISTORICAL_TRANSACTIONS -> {
                    isHistoryTransactionComplete = finverseProductRetrieval.isComplete()
                }
                else -> {}
            }
        }

        return isOnlineTransactionComplete && isHistoryTransactionComplete
    }

    fun isAccountComplete(): Boolean {
        for (finverseProductRetrieval in requestedProducts) {
            when (finverseProductRetrieval.getProduct()) {
                FinverseProduct.ACCOUNTS -> {
                    return finverseProductRetrieval.isComplete()
                }
                else -> {}
            }
        }

        return false
    }

    fun isAccountNumberComplete(): Boolean {
        for (finverseProductRetrieval in requestedProducts) {
            when (finverseProductRetrieval.getProduct()) {
                FinverseProduct.ACCOUNT_NUMBERS -> {
                    return finverseProductRetrieval.isComplete()
                }
                else -> {}
            }
        }

        return false
    }

    fun putOrUpdate(product: FinverseProduct, status: FinverseRetrievalStatus) {
        if (this.status == "PENDING_CALLBACK") {
            logger.info("status was PENDING_CALLBACK, adding to buffer: ${product.productName}")
            buffer.add(FinverseDataRetrievalBufferItem(product, status))
            return
        }
        when (product) {
            FinverseProduct.ACCOUNTS -> updateAccountStatus(status)
            FinverseProduct.ONLINE_TRANSACTIONS -> updateOnlineTransactionStatus(status)
            FinverseProduct.HISTORICAL_TRANSACTIONS -> updateHistoricalTransactionStatus(status)
            FinverseProduct.ACCOUNT_NUMBERS -> updateAccountNumberStatus(status)
            FinverseProduct.STATEMENTS -> updateStatementStatus(status)
            FinverseProduct.IDENTITY -> updateIdentityStatus(status)
            FinverseProduct.BALANCE_HISTORY -> updateBalanceHistoryStatus(status)
            FinverseProduct.INCOME_ESTIMATION -> updateIncomeEstimationStatus(status)
        }
    }

    private fun updateAccountStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "ACCOUNTS") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateOnlineTransactionStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "ONLINE_TRANSACTIONS") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateHistoricalTransactionStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "HISTORICAL_TRANSACTIONS") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateAccountNumberStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "ACCOUNT_NUMBERS") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateStatementStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "STATEMENTS") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateIdentityStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "IDENTITY") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateBalanceHistoryStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "BALANCE_HISTORY") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }

    private fun updateIncomeEstimationStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "INCOME_ESTIMATION") {
                finverseProductRetrieval.setStatus(status)
                return
            }
        }
    }
}
