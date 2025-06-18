package sg.flow.models.finverse

class FinverseDataRetrievalEvent(
    private val loginIdentityId: String,
    private val userId: Int,
    private val institutionId: String,
    private val requestedProducts: List<FinverseProductRetrieval>
) {
    fun isComplete(): Boolean {
        for (finverseProductRetrieval in requestedProducts) {
            if (! finverseProductRetrieval.isComplete()) {
                return false
            }
        }

        return true
    }

    fun getOverallRetrievalStatus() : FinverseOverallRetrievalStatus {
        val allowedList: List<FinverseRetrievalStatus> = listOf(
            FinverseRetrievalStatus.RETRIEVED,
            FinverseRetrievalStatus.PARTIALLY_RETRIEVED
        )

        for (finverseProductRetrieval in requestedProducts) {
            val thisStatus = finverseProductRetrieval.getStatus()
            if (! allowedList.contains(thisStatus)) {
                return FinverseOverallRetrievalStatus(
                    success = false,
                    message = "${finverseProductRetrieval.getProduct().productName} - $thisStatus",
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

    fun putOrUpdate(product: FinverseProduct, status: FinverseRetrievalStatus) {
        when (product) {
            FinverseProduct.ACCOUNTS -> updateAccountStatus(status)
            FinverseProduct.TRANSACTIONS -> updateTransactionStatus(status)
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
            }
        }
    }

    private fun updateTransactionStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "TRANSACTIONS") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }

    private fun updateAccountNumberStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "ACCOUNT_NUMBERS") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }

    private fun updateStatementStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "STATEMENTS") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }

    private fun updateIdentityStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "IDENTITY") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }

    private fun updateBalanceHistoryStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "BALANCE_HISTORY") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }

    private fun updateIncomeEstimationStatus(status: FinverseRetrievalStatus) {
        for (finverseProductRetrieval in requestedProducts) {
            if (finverseProductRetrieval.getProduct().productName == "INCOME_ESTIMATION") {
                finverseProductRetrieval.setStatus(status)
            }
        }
    }
}