package sg.flow.models.finverse.mappers

import sg.flow.entities.Account
import sg.flow.entities.TransactionHistory
import sg.flow.models.card.BriefCard
import sg.flow.models.finverse.responses.FinverseTransactionData

class FinverseTransactionToTransactionHistoryMapper(
        private val accountMapper: (String) -> Account?,
        private val cardMapper: (String?) -> BriefCard?
) : Mapper<FinverseTransactionData, TransactionHistory> {

    override fun map(input: FinverseTransactionData): TransactionHistory {
        return TransactionHistory(
                id = 0, // Will be set by database
                transactionReference = input.reference ?: input.transactionId,
                account = accountMapper(input.accountId),
                card = cardMapper(input.cardNumber),
                transactionDate = input.date,
                transactionTime = input.time,
                amount = input.amount,
                transactionType = mapTransactionType(input.transactionType),
                description = input.description,
                transactionStatus = mapTransactionStatus(input.status),
                friendlyDescription = generateFriendlyDescription(input)
        )
    }

    private fun mapTransactionType(finverseType: String): String {
        return when (finverseType.uppercase()) {
            "CREDIT", "DEPOSIT", "INCOMING" -> "CREDIT"
            "DEBIT", "WITHDRAWAL", "OUTGOING" -> "DEBIT"
            "TRANSFER_IN", "TRANSFER_OUT" -> "TRANSFER"
            "PAYMENT" -> "PAYMENT"
            "FEE", "CHARGE" -> "FEE"
            else -> finverseType.uppercase()
        }
    }

    private fun mapTransactionStatus(finverseStatus: String): String {
        return when (finverseStatus.uppercase()) {
            "COMPLETED", "SETTLED", "POSTED" -> "COMPLETED"
            "PENDING", "PROCESSING" -> "PENDING"
            "FAILED", "DECLINED" -> "FAILED"
            "CANCELLED", "CANCELED" -> "CANCELLED"
            else -> finverseStatus.uppercase()
        }
    }

    private fun generateFriendlyDescription(input: FinverseTransactionData): String {
        val merchantName = input.merchantName
        val category = input.transactionCategory
        val description = input.description

        return when {
            !merchantName.isNullOrBlank() -> merchantName
            !category.isNullOrBlank() -> "$category - $description"
            else -> description
        }
    }
}
