package sg.flow.models.finverse

import sg.flow.models.finverse.FinverseProduct.ACCOUNTS
import sg.flow.models.finverse.FinverseProduct.ACCOUNT_NUMBERS
import sg.flow.models.finverse.FinverseProduct.BALANCE_HISTORY
import sg.flow.models.finverse.FinverseProduct.IDENTITY
import sg.flow.models.finverse.FinverseProduct.INCOME_ESTIMATION
import sg.flow.models.finverse.FinverseProduct.STATEMENTS
import sg.flow.models.finverse.FinverseProduct.HISTORICAL_TRANSACTIONS
import sg.flow.models.finverse.FinverseProduct.ONLINE_TRANSACTIONS

object FinverseEventTypeParser {
    fun parse(raw: String): FinverseProductStatus? {
        val product  = getProductThatBelongs(raw)
        val statusString = raw.substringAfter(product.productName + "_")
        val status   = FinverseRetrievalStatus.valueOf(statusString)

        return FinverseProductStatus(product, status)
    }


    fun getProductThatBelongs(eventTypeString: String): FinverseProduct {
        if (eventTypeString.startsWith(ACCOUNT_NUMBERS.productName)) {
            return ACCOUNT_NUMBERS
        }
        if (eventTypeString.startsWith(ACCOUNTS.productName)) {
            return ACCOUNTS
        }
        if (eventTypeString.startsWith(ONLINE_TRANSACTIONS.productName)) {
            return ONLINE_TRANSACTIONS
        }
        if (eventTypeString.startsWith(HISTORICAL_TRANSACTIONS.productName)) {
            return HISTORICAL_TRANSACTIONS
        }
        if (eventTypeString.startsWith(IDENTITY.productName)) {
            return IDENTITY
        }
        if (eventTypeString.startsWith(BALANCE_HISTORY.productName)) {
            return BALANCE_HISTORY
        }
        if (eventTypeString.startsWith(INCOME_ESTIMATION.productName)) {
            return INCOME_ESTIMATION
        }
        return STATEMENTS
    }
}