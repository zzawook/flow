package sg.flow.models.transaction

import java.time.LocalDate

data class TransactionHistoryList(
    val startDate: LocalDate,
    val endDate: LocalDate,
    val transactions: MutableList<TransactionHistoryDetail> = mutableListOf()
) {
    fun add(transaction: TransactionHistoryDetail) {
        transactions.add(transaction)
    }
}
