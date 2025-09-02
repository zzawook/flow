package sg.flow.services.AccountServices

import org.springframework.stereotype.Service
import sg.flow.entities.utils.AccountType
import sg.flow.grpc.exception.AccountDoesNotExistException
import sg.flow.grpc.exception.RequestedAccountNotBelongException
import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.BriefAccount as Account
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@Service
class AccountServiceImpl(
        private val accountRepository: AccountRepository,
        private val transactionHistoryRepository: TransactionHistoryRepository,
) : AccountService {

        override suspend fun getAccounts(userId: Int): List<Account> {
                val accounts = accountRepository.findAccountsOfUser(userId)

                fun isNotCard(accountTypeStr: String): Boolean {
                        val accountType = AccountType.fromValue(accountTypeStr)
                        return accountType != AccountType.DEBIT_CARD && accountType != AccountType.CREDIT_CARD
                }

                val accountsWithOutCards = accounts.filter { account -> isNotCard(account.accountType) }
                return accountsWithOutCards
        }


        override suspend fun getAccountWithTransactionHistory(
                userId: Int
        ): List<AccountWithTransactionHistory> =
                accountRepository.findAccountWithTransactionHistorysOfUser(userId)

        override suspend fun getAccount(userId: Int, accountId: Long): Account {
                val account =
                        accountRepository.findById(accountId)
                                ?: throw AccountDoesNotExistException(accountId)

                if (account.owner.id != userId) {
                        throw RequestedAccountNotBelongException(userId, accountId)
                }

                return Account(
                        id = account.id ?: -1,
                        bank = account.bank,
                        balance = account.balance,
                        accountName = account.accountName,
                        accountType = account.accountType.toString(),
                        accountNumber = account.accountNumber

                )
        }

        override suspend fun getAccountWithTransactionHistory(
                userId: Int,
                accountId: Long
        ): AccountWithTransactionHistory {
                val account =
                        accountRepository.findById(accountId)
                                ?: throw AccountDoesNotExistException(accountId)

                if (account.owner.id != userId) {
                        throw RequestedAccountNotBelongException(userId, accountId)
                }

                val recentTransactionDetails =
                        transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(
                                accountId
                        )

                return AccountWithTransactionHistory(
                        id = account.id ?: -1,
                        accountNumber = account.accountNumber,
                        bank = account.bank,
                        balance = account.balance,
                        accountName = account.accountName,
                        accountType = account.accountType,
                        interestRatePerAnnum = account.interestRatePerAnnum,
                        recentTransactionHistoryDetails = recentTransactionDetails
                )
        }
}
