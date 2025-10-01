package sg.flow.repositories.transactionHistory

import sg.flow.entities.RecurringSpendingMonthly
import java.time.LocalDate
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.Repository

interface TransactionHistoryRepository : Repository<TransactionHistory, Long> {
        suspend fun saveAllWithId(entities: List<TransactionHistory>): List<TransactionHistory>
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

        // Transaction analysis methods
        suspend fun findUnprocessedTransactions(): List<TransactionHistory>
        suspend fun findUnprocessedTransactionsByUserId(userId: Int): List<TransactionHistory>
        suspend fun updateTransactionAnalysis(
                id: Long,
                category: String?,
                friendlyDescription: String?,
                extractedCardNumber: String?,
                brandName: String?,
                brandDomain: String?,
                revisedTransactionDate: LocalDate?,
                isProcessed: Boolean
        ): Boolean
        suspend fun batchUpdateTransactionAnalysis(updates: List<TransactionAnalysisUpdate>): Int
        suspend fun findProcessedTransactionsFromTransactionIds(userId: Int, transactionIds: List<String>): TransactionHistoryList
        // For recurring analysis
        suspend fun findTransactionsForUserSinceDate(
                userId: Int,
                sinceDate: LocalDate
        ): List<TransactionHistory>

        suspend fun setTransactionCategory(userId: Int, transactionId: String, category: String): Boolean
        suspend fun setTransactionInclusion(userId: Int, transactionId: String, includeInSpendingOrIncome: Boolean): Boolean
        suspend fun findTransactionForAccountOlderThan(
                userId: Int,
                bankId: String,
                accountNumber: String,
                oldestTransactionId: String,
                limit: Int
        ): TransactionHistoryList

}

data class TransactionAnalysisUpdate(
        val transactionId: Long,
        val category: String?,
        val friendlyDescription: String?,
        val extractedCardNumber: String?,
        val brandName: String?,
        val brandDomain: String?,
        val revisedTransactionDate: LocalDate?,
        val isProcessed: Boolean = true
)
