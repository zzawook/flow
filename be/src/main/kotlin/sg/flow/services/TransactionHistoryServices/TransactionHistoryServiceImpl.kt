package sg.flow.services.TransactionHistoryServices

import java.time.LocalDate
import org.springframework.stereotype.Service
import sg.flow.entities.RecurringSpendingMonthly
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.repositories.recurring.RecurringSpendingRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@Service
class TransactionHistoryServiceImpl(
        private val transactionHistoryRepository: TransactionHistoryRepository,
        private val recurringSpendingRepository: RecurringSpendingRepository
) : TransactionHistoryService {

    override suspend fun getMonthlyTransaction(
            userId: Int,
            year: Int,
            month: Int
    ): TransactionHistoryList {
        val startDate = LocalDate.of(year, month, 1)
        val endDate = startDate.withDayOfMonth(startDate.lengthOfMonth())
        return transactionHistoryRepository.findTransactionBetweenDates(userId, startDate, endDate)
    }

    override suspend fun getDailyTransaction(userId: Int, date: LocalDate): TransactionHistoryList {
        return transactionHistoryRepository.findTransactionBetweenDates(userId, date, date)
    }

    override suspend fun getTransactionDetails(
            userId: Int,
            transactionId: String
    ): TransactionHistoryDetail {
        transactionHistoryRepository.findTransactionDetailById(id = transactionId.toLong())?.let {
                detail ->
            if (detail.account?.owner?.id != userId) {
                throw IllegalArgumentException("Transaction does not belong to user")
            }
            return detail
        }
        throw IllegalArgumentException("Transaction not found")
    }

    override suspend fun getRelevantRecepient(keyword: String): TransferRecepient {
        // TODO: Implement getRelevantRecepient
        throw NotImplementedError("getRelevantRecepient not implemented")
    }

    override suspend fun getLast30DaysHistoryList(userId: Int): TransactionHistoryList {
        val endDate = LocalDate.now()
        val startDate = endDate.minusDays(30)
        return transactionHistoryRepository.findTransactionBetweenDates(
                userId,
                startDate,
                endDate,
                30
        )
    }

    override suspend fun getTransactionWithinRange(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): TransactionHistoryList {
        return transactionHistoryRepository.findTransactionBetweenDates(userId, startDate, endDate)
    }

    override suspend fun getProcessedTransactionsForTransactionIds(userId: Int, transactionIds: List<String>): TransactionHistoryList {
        return transactionHistoryRepository.findProcessedTransactionsFromTransactionIds(userId, transactionIds)
    }

    override suspend fun getRecurringTransactionAnalysisResult(userId: Int): List<RecurringSpendingMonthly> {
        return recurringSpendingRepository.findRecurringTransactionsForUserId(userId)
    }

    override suspend fun setTransactionCategory(
        userId: Int,
        transactionId: String,
        category: String
    ): Boolean {
        val result = transactionHistoryRepository.setTransactionCategory(userId, transactionId, category);
        return result
    }

    override suspend fun setTransactionInclusion(
        userId: Int,
        transactionId: String,
        includeInSpendingOrIncome: Boolean
    ): Boolean {
        val result = transactionHistoryRepository.setTransactionInclusion(userId, transactionId, includeInSpendingOrIncome)
        return result
    }

    override suspend fun getTransactionsForAccount(
        userId: Int,
        accountNumber: String,
        bankId: String,
        oldestTransactionId: String,
        limit: Int
    ): TransactionHistoryList {
        return transactionHistoryRepository.findTransactionForAccountOlderThan(userId, bankId, accountNumber, oldestTransactionId, limit)
    }
}
