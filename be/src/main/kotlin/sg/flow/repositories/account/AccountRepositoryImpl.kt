package sg.flow.repositories.account

import java.time.LocalDateTime
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import kotlinx.coroutines.reactive.awaitFirstOrNull
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.BriefAccount
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.repositories.utils.AccountQueryStore

@Repository
class AccountRepositoryImpl(
        private val databaseClient: DatabaseClient,
        private val transactionHistoryRepository: TransactionHistoryRepository,
) : AccountRepository {

        override suspend fun save(entity: Account): Account {
                val hasId = entity.id != null
                val queryString =
                        if (hasId) AccountQueryStore.SAVE_ACCOUNT_WITH_ID
                        else AccountQueryStore.SAVE_ACCOUNT

                if (hasId) {
                        databaseClient
                                .sql(queryString)
                                .bind(0, entity.id!!)
                                .bind(1, entity.accountNumber)
                                .bind(2, entity.bank.id!!)
                                .bind(3, entity.owner?.id!!)
                                .bind(4, entity.balance)
                                .bind(5, entity.accountName)
                                .bind(6, entity.accountType.toString())
                                .bind(7, entity.lastUpdated)
                                .fetch()
                                .awaitRowsUpdated()
                } else {
                        databaseClient
                                .sql(queryString)
                                .bind(0, entity.accountNumber)
                                .bind(1, entity.bank.id!!)
                                .bind(2, entity.owner?.id!!)
                                .bind(3, entity.balance)
                                .bind(4, entity.accountName)
                                .bind(5, entity.accountType.toString())
                                .bind(6, entity.lastUpdated)
                                .fetch()
                                .awaitRowsUpdated()
                }

                return entity
        }

        override suspend fun findById(id: Long): Account? {
                return databaseClient
                        .sql(AccountQueryStore.FIND_ACCOUNT_BY_ID)
                        .bind(0, id)
                        .map { row ->
                                Account(
                                        id = row.get("id", Long::class.java)!!,
                                        accountNumber =
                                                row.get("account_number", String::class.java)!!,
                                        balance = row.get("balance", Double::class.java)!!,
                                        accountName = row.get("account_name", String::class.java)!!,
                                        accountType =
                                                AccountType.valueOf(
                                                        row.get(
                                                                "account_type",
                                                                String::class.java
                                                        )!!
                                                ),
                                        lastUpdated =
                                                row.get(
                                                        "last_updated",
                                                        LocalDateTime::class.java
                                                )!!,
                                        interestRatePerAnnum =
                                                row.get(
                                                        "interest_rate_per_annum",
                                                        Double::class.java
                                                )!!,
                                        bank =
                                                Bank(
                                                        id = row.get("bank_id", Int::class.java)!!,
                                                        name =
                                                                row.get(
                                                                        "bank_name",
                                                                        String::class.java
                                                                )!!,
                                                        bankCode =
                                                                row.get(
                                                                        "bank_code",
                                                                        String::class.java
                                                                )!!
                                                ),
                                        finverseId = row.get(
                                                "finverse_id",
                                                String::class.java
                                        ),
                                        owner =
                                                User(
                                                        id = row.get("user_id", Int::class.java)!!,
                                                        name =
                                                                row.get(
                                                                        "name",
                                                                        String::class.java
                                                                )!!,
                                                        email =
                                                                row.get(
                                                                        "email",
                                                                        String::class.java
                                                                )!!,
                                                        identificationNumber =
                                                                row.get(
                                                                        "identification_number",
                                                                        String::class.java
                                                                )!!,
                                                        phoneNumber =
                                                                row.get(
                                                                        "phone_number",
                                                                        String::class.java
                                                                )!!,
                                                        dateOfBirth =
                                                                row.get(
                                                                        "date_of_birth",
                                                                        java.time.LocalDate::class
                                                                                .java
                                                                )!!,
                                                        address =
                                                                row.get(
                                                                        "address",
                                                                        String::class.java
                                                                )
                                                                        ?: "",
                                                        settingJson =
                                                                row.get(
                                                                        "setting_json",
                                                                        String::class.java
                                                                )
                                                                        ?: "{}"
                                                )
                                )
                        }
                        .one()
                        .awaitFirstOrNull()
        }

        override suspend fun deleteAll(): Boolean {
                return try {
                        databaseClient
                                .sql(AccountQueryStore.DELETE_ALL_ACCOUNTS)
                                .fetch()
                                .awaitRowsUpdated()
                        true
                } catch (e: Exception) {
                        e.printStackTrace()
                        false
                }
        }

        override suspend fun findBriefAccountsOfUser(userId: Int): List<BriefAccount> {
                var temp =
                        runCatching {
                                databaseClient
                                        .sql(AccountQueryStore.FIND_BRIEF_ACCOUNT_OF_USER)
                                        .bind(0, userId)
                                        .map { row ->
                                                BriefAccount(
                                                        id = row.get("id", Long::class.java)!!,
                                                        balance =
                                                                row.get(
                                                                        "balance",
                                                                        Double::class.java
                                                                )!!,
                                                        accountName =
                                                                row.get(
                                                                        "account_name",
                                                                        String::class.java
                                                                )!!,
                                                        bank =
                                                                Bank(
                                                                        id =
                                                                                row.get(
                                                                                        "bank_id",
                                                                                        Int::class
                                                                                                .java
                                                                                )!!,
                                                                        name =
                                                                                row.get(
                                                                                        "bank_name",
                                                                                        String::class
                                                                                                .java
                                                                                )!!,
                                                                        bankCode =
                                                                                row.get(
                                                                                        "bank_code",
                                                                                        String::class
                                                                                                .java
                                                                                )!!
                                                                )
                                                )
                                        }
                                        .all()
                                        .asFlow()
                                        .toList()
                        }
                                .onFailure { e ->
                                        e.printStackTrace()
                                        println("Error fetching brief accounts for userId: $userId")
                                }
                                .getOrElse { emptyList<BriefAccount>() }
                return temp
        }

        override suspend fun findAccountWithTransactionHistorysOfUser(
                userId: Int
        ): List<AccountWithTransactionHistory> {
                val accounts =
                        databaseClient
                                .sql(
                                        AccountQueryStore
                                                .FIND_ACCOUNT_WITH_TRANSACTION_HISTORY_OF_USER
                                )
                                .bind(0, userId)
                                .map { row ->
                                        AccountWithTransactionHistory(
                                                id = row.get("id", Long::class.java)!!,
                                                accountNumber =
                                                        row.get(
                                                                "account_number",
                                                                String::class.java
                                                        )!!,
                                                balance = row.get("balance", Double::class.java)!!,
                                                accountName =
                                                        row.get(
                                                                "account_name",
                                                                String::class.java
                                                        )!!,
                                                accountType =
                                                        AccountType.valueOf(
                                                                row.get(
                                                                        "account_type",
                                                                        String::class.java
                                                                )!!
                                                        ),
                                                interestRatePerAnnum =
                                                        row.get(
                                                                "interest_rate_per_annum",
                                                                Double::class.java
                                                        )!!,
                                                bank =
                                                        Bank(
                                                                id =
                                                                        row.get(
                                                                                "bank_id",
                                                                                Int::class.java
                                                                        )!!,
                                                                name =
                                                                        row.get(
                                                                                "bank_name",
                                                                                String::class.java
                                                                        )!!,
                                                                bankCode =
                                                                        row.get(
                                                                                "bank_code",
                                                                                String::class.java
                                                                        )!!
                                                        )
                                        )
                                }
                                .all()
                                .asFlow()
                                .toList()

                // Populate transaction history for each account
                accounts.forEach { account ->
                        account.recentTransactionHistoryDetails =
                                transactionHistoryRepository
                                        .findRecentTransactionHistoryDetailOfAccount(account.id)
                }

                return accounts
        }
}
