package sg.flow.models.account

import sg.flow.entities.Bank
import sg.flow.entities.utils.AccountType
import sg.flow.models.transaction.TransactionHistoryDetail

data class AccountWithTransactionHistory(
        val id: Long,
        val accountNumber: String,
        val balance: Double,
        val accountName: String,
        val accountType: AccountType,
        val interestRatePerAnnum: Double? = null,
        val bank: Bank,
        var recentTransactionHistoryDetails: List<TransactionHistoryDetail> = emptyList()
)
