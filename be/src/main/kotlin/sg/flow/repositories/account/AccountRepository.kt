package sg.flow.repositories.account

import sg.flow.entities.Account
import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.BriefAccount


import sg.flow.repositories.Repository

interface AccountRepository : Repository<Account, Long> {
    suspend fun findAccountsOfUser(userId: Int): List<BriefAccount>
    suspend fun findAccountWithTransactionHistorysOfUser(userId: Int): List<AccountWithTransactionHistory>
    suspend fun findAccountByFinverseAccountId(finverseAccountId: String): Account?
} 