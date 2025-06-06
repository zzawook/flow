package sg.flow.services.BankQueryServices

import sg.flow.entities.Bank
import sg.flow.models.transaction.TransactionHistoryList
import java.time.LocalDate

interface IBankQueryService {
    suspend fun getTransactionHistoryBetween(
        userId: Int, 
        accountNumber: String, 
        startDate: LocalDate, 
        endDate: LocalDate
    ): TransactionHistoryList
    
    suspend fun hasAccountNumber(accountNumber: String): Boolean
    suspend fun getBank(): Bank
} 