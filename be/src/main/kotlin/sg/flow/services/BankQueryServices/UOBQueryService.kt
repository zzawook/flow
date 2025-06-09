package sg.flow.services.BankQueryServices

import java.time.LocalDate
import org.springframework.stereotype.Component
import sg.flow.entities.Bank
import sg.flow.models.transaction.TransactionHistoryList

@Component
class UOBQueryService : IBankQueryService {

    override suspend fun getTransactionHistoryBetween(
            userId: Int,
            accountNumber: String,
            startDate: LocalDate,
            endDate: LocalDate
    ): TransactionHistoryList {
        // TODO: Implement actual logic
        throw UnsupportedOperationException("Unimplemented method 'getTransactionHistory'")
    }

    override suspend fun hasAccountNumber(accountNumber: String): Boolean {
        // TODO: Implement actual logic
        throw UnsupportedOperationException("Unimplemented method 'hasAccountNumber'")
    }

    override suspend fun getBank(): Bank {
        return Bank(id = 1, name = "UOB", bankCode = "UOB003")
    }
}
