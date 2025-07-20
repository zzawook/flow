package sg.flow.models.finverse.mappers

import sg.flow.entities.Account
import sg.flow.entities.TransactionHistory
import sg.flow.models.card.BriefCard
import sg.flow.models.finverse.responses.FinverseTransactionData
import java.time.LocalDate
import java.time.LocalDateTime

class FinverseTransactionToTransactionHistoryMapper(
        private val accountMapper: (String) -> Account?,
        private val cardMapper: (String?) -> BriefCard?
) : Mapper<FinverseTransactionData, TransactionHistory> {

    fun map(input: FinverseTransactionData): TransactionHistory {
        return TransactionHistory(
                id = null,
                transactionReference = input.reference ?: input.transactionId,
                account = accountMapper(input.accountId),
                card = null,
                transactionDate = input.transactionDate ?: input.postedDate ?: LocalDate.now(),
                transactionTime = input.transactionTime?.toLocalTime(),
                amount = input.amount.value,
                transactionType = "", // TO BE LATER POPULATED WITH AMAZON BEDROCK
                description = input.description,
                transactionStatus = mapTransactionStatus(input.isPending),
                friendlyDescription = "" // TO BE LATER POPULATED WITH AMAZON BEDROCK
        )
    }

    private fun mapTransactionStatus(isPending: Boolean): String {
        if (isPending)
            return "PENDING"
        return "COMPLETE"
    }


}
