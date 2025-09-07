package sg.flow.services.TransactionHistoryServices

import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.models.transfer.TransferRecepient
import java.time.LocalDate

interface TransactionHistoryService {
    suspend fun getMonthlyTransaction(userId: Int, year: Int, month: Int): TransactionHistoryList
    suspend fun getDailyTransaction(userId: Int, date: LocalDate): TransactionHistoryList
    suspend fun getTransactionDetails(userId: Int, transactionId: String): TransactionHistoryDetail
    suspend fun getRelevantRecepient(keyword: String): TransferRecepient
    suspend fun getLast30DaysHistoryList(userId: Int): TransactionHistoryList
    suspend fun getTransactionWithinRange(userId: Int, startDate: LocalDate, endDate: LocalDate): TransactionHistoryList
    suspend fun getProcessedTransactionsForTransactionIds(userId: Int, transactionIds: List<String>): TransactionHistoryList
} 