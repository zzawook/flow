package sg.flow.services.AccountServices

import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.BriefAccount


interface AccountService {
suspend fun getAccounts(userId: Int): List<BriefAccount>

    suspend fun getAccountWithTransactionHistory(userId: Int): List<AccountWithTransactionHistory>
suspend fun getAccount(userId: Int, accountId: Long): BriefAccount

    suspend fun getAccountWithTransactionHistory(
            userId: Int,
            accountId: Long
    ): AccountWithTransactionHistory
}
