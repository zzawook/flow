package sg.flow.models.finverse

import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.FinverseProductStatus
import sg.flow.models.finverse.FinverseRetrievalStatus

object FinverseEventTypeParser {
    // build an alternation of all the enum names, e.g. "RETRIEVED|COMPLETED|…"
    private val STATUS_PATTERN = FinverseRetrievalStatus
        .values()
        .joinToString("|") { it.name }

    // group1 = PRODUCT (may contain underscores), group2 = one of the statuses
    private val REGEX = Regex("^(.+?)_($STATUS_PATTERN)$")

    // map from productName → FinverseProduct instance
    private val productMap = listOf(
        FinverseProduct.ACCOUNT_NUMBERS,
        FinverseProduct.ACCOUNTS,
        FinverseProduct.ONLINE_TRANSACTIONS,
        FinverseProduct.HISTORICAL_TRANSACTIONS,
        FinverseProduct.IDENTITY,
        FinverseProduct.BALANCE_HISTORY,
        FinverseProduct.INCOME_ESTIMATION,
        FinverseProduct.STATEMENTS
    ).associateBy { it.productName }

    /**
     * Parses strings like
     *   "ACCOUNTS_RETRIEVED"
     *   "INCOME_ESTIMATION_PARTIALLY_RETRIEVED"
     *   "IDENTITY_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION"
     *
     * into a FinverseProductStatus(product, status).
     *
     * @throws IllegalArgumentException if the raw value doesn’t match expected pattern
     */
    fun parse(raw: String): FinverseProductStatus {
        val match = REGEX.matchEntire(raw)
            ?: throw IllegalArgumentException("Unrecognized event type: $raw")

        val productName = match.groupValues[1]
        val statusName  = match.groupValues[2]

        val product = productMap[productName]
            ?: FinverseProduct.STATEMENTS      // fallback for anything else

        val status = FinverseRetrievalStatus.valueOf(statusName)

        return FinverseProductStatus(product, status)
    }
}
