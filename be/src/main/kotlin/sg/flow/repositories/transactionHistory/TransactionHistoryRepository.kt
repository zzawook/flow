package sg.flow.repositories.transactionHistory

import java.time.LocalDate
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.Repository

interface TransactionHistoryRepository : Repository<TransactionHistory, Long> {
    suspend fun findRecentTransactionHistoryDetailOfAccount(
            accountId: Long
    ): List<TransactionHistoryDetail>
    suspend fun findTransactionBetweenDates(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): TransactionHistoryList
    suspend fun findTransactionBetweenDates(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate,
            limit: Int
    ): TransactionHistoryList
    suspend fun findTransactionDetailById(id: Long): TransactionHistoryDetail?
}
