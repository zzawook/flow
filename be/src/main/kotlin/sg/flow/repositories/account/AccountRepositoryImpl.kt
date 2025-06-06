package sg.flow.repositories.account

import java.sql.SQLException
import java.sql.Timestamp
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Repository
import sg.flow.configs.DatabaseConnectionPool
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
        private val databaseConnectionPool: DatabaseConnectionPool,
        private val transactionHistoryRepository: TransactionHistoryRepository,
) : AccountRepository {

        override suspend fun save(entity: Account): Account =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: throw RuntimeException("Failed to get connection")
                        val hasId = entity.id != null
                        val queryString =
                                if (hasId) AccountQueryStore.SAVE_ACCOUNT_WITH_ID
                                else AccountQueryStore.SAVE_ACCOUNT
                        val parameterStart = if (hasId) 1 else 0

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(queryString).use { pstm ->
                                                if (hasId) {
                                                        pstm.setLong(parameterStart, entity.id!!)
                                                }
                                                pstm.setString(
                                                        parameterStart + 1,
                                                        entity.accountNumber
                                                )
                                                pstm.setInt(parameterStart + 2, entity.bank.id!!)
                                                pstm.setInt(parameterStart + 3, entity.owner?.id!!)
                                                pstm.setDouble(parameterStart + 4, entity.balance)
                                                pstm.setString(
                                                        parameterStart + 5,
                                                        entity.accountName
                                                )
                                                pstm.setString(
                                                        parameterStart + 6,
                                                        entity.accountType.toString()
                                                )
                                                pstm.setTimestamp(
                                                        parameterStart + 7,
                                                        Timestamp.valueOf(entity.lastUpdated)
                                                )

                                                pstm.executeUpdate()
                                                entity
                                        }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                throw RuntimeException("Failed to save account", e)
                        }
                }

        override suspend fun findById(id: Long): Account? =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection() ?: return@withContext null

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(AccountQueryStore.FIND_ACCOUNT_BY_ID)
                                                .use { pstm ->
                                                        pstm.setLong(1, id)
                                                        val resultSet = pstm.executeQuery()

                                                        if (resultSet.next()) {
                                                                Account(
                                                                        id =
                                                                                resultSet.getLong(
                                                                                        "id"
                                                                                ),
                                                                        accountNumber =
                                                                                resultSet.getString(
                                                                                        "account_number"
                                                                                ),
                                                                        balance =
                                                                                resultSet.getDouble(
                                                                                        "balance"
                                                                                ),
                                                                        accountName =
                                                                                resultSet.getString(
                                                                                        "account_name"
                                                                                ),
                                                                        accountType =
                                                                                AccountType.valueOf(
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "account_type"
                                                                                                )
                                                                                ),
                                                                        lastUpdated =
                                                                                resultSet
                                                                                        .getTimestamp(
                                                                                                "last_updated"
                                                                                        )
                                                                                        .toLocalDateTime(),
                                                                        interestRatePerAnnum =
                                                                                resultSet.getDouble(
                                                                                        "interest_rate_per_annum"
                                                                                ),
                                                                        bank =
                                                                                Bank(
                                                                                        id =
                                                                                                resultSet
                                                                                                        .getInt(
                                                                                                                "bank_id"
                                                                                                        ),
                                                                                        name =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "bank_name"
                                                                                                        ),
                                                                                        bankCode =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "bank_code"
                                                                                                        )
                                                                                ),
                                                                        owner =
                                                                                User(
                                                                                        id =
                                                                                                resultSet
                                                                                                        .getInt(
                                                                                                                "user_id"
                                                                                                        ),
                                                                                        name =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "name"
                                                                                                        ),
                                                                                        email =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "email"
                                                                                                        ),
                                                                                        identificationNumber =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "identification_number"
                                                                                                        ),
                                                                                        phoneNumber =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "phone_number"
                                                                                                        ),
                                                                                        dateOfBirth =
                                                                                                resultSet
                                                                                                        .getDate(
                                                                                                                "date_of_birth"
                                                                                                        )
                                                                                                        .toLocalDate(),
                                                                                        address =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "address"
                                                                                                        )
                                                                                                        ?: "",
                                                                                        settingJson =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "setting_json"
                                                                                                        )
                                                                                                        ?: "{}"
                                                                                )
                                                                )
                                                        } else null
                                                }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                null
                        }
                }

        override suspend fun deleteAll(): Boolean =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection() ?: return@withContext false

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(AccountQueryStore.DELETE_ALL_ACCOUNTS)
                                                .use { pstm ->
                                                        pstm.executeUpdate()
                                                        true
                                                }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                false
                        }
                }

        override suspend fun findBriefAccountsOfUser(userId: Int): List<BriefAccount> =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: return@withContext emptyList()

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(
                                                        AccountQueryStore.FIND_BRIEF_ACCOUNT_OF_USER
                                                )
                                                .use { pstm ->
                                                        pstm.setInt(1, userId)
                                                        val resultSet = pstm.executeQuery()
                                                        val accounts = mutableListOf<BriefAccount>()

                                                        while (resultSet.next()) {
                                                                accounts.add(
                                                                        BriefAccount(
                                                                                id =
                                                                                        resultSet
                                                                                                .getLong(
                                                                                                        "id"
                                                                                                ),
                                                                                balance =
                                                                                        resultSet
                                                                                                .getDouble(
                                                                                                        "balance"
                                                                                                ),
                                                                                accountName =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "account_name"
                                                                                                ),
                                                                                bank =
                                                                                        Bank(
                                                                                                id =
                                                                                                        resultSet
                                                                                                                .getInt(
                                                                                                                        "bank_id"
                                                                                                                ),
                                                                                                name =
                                                                                                        resultSet
                                                                                                                .getString(
                                                                                                                        "bank_name"
                                                                                                                ),
                                                                                                bankCode =
                                                                                                        resultSet
                                                                                                                .getString(
                                                                                                                        "bank_code"
                                                                                                                )
                                                                                        )
                                                                        )
                                                                )
                                                        }
                                                        accounts
                                                }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                emptyList()
                        }
                }

        override suspend fun findAccountWithTransactionHistorysOfUser(
                userId: Int
        ): List<AccountWithTransactionHistory> =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: return@withContext emptyList()

                        try {
                                val accounts =
                                        connection.use { conn ->
                                                conn.prepareStatement(
                                                                AccountQueryStore
                                                                        .FIND_ACCOUNT_WITH_TRANSACTION_HISTORY_OF_USER
                                                        )
                                                        .use { pstm ->
                                                                pstm.setInt(1, userId)
                                                                val resultSet = pstm.executeQuery()
                                                                val accounts =
                                                                        mutableListOf<
                                                                                AccountWithTransactionHistory>()

                                                                while (resultSet.next()) {
                                                                        accounts.add(
                                                                                AccountWithTransactionHistory(
                                                                                        id =
                                                                                                resultSet
                                                                                                        .getLong(
                                                                                                                "id"
                                                                                                        ),
                                                                                        accountNumber =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "account_number"
                                                                                                        ),
                                                                                        balance =
                                                                                                resultSet
                                                                                                        .getDouble(
                                                                                                                "balance"
                                                                                                        ),
                                                                                        accountName =
                                                                                                resultSet
                                                                                                        .getString(
                                                                                                                "account_name"
                                                                                                        ),
                                                                                        accountType =
                                                                                                AccountType
                                                                                                        .valueOf(
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "account_type"
                                                                                                                        )
                                                                                                        ),
                                                                                        interestRatePerAnnum =
                                                                                                resultSet
                                                                                                        .getDouble(
                                                                                                                "interest_rate_per_annum"
                                                                                                        ),
                                                                                        bank =
                                                                                                Bank(
                                                                                                        id =
                                                                                                                resultSet
                                                                                                                        .getInt(
                                                                                                                                "bank_id"
                                                                                                                        ),
                                                                                                        name =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "bank_name"
                                                                                                                        ),
                                                                                                        bankCode =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "bank_code"
                                                                                                                        )
                                                                                                )
                                                                                )
                                                                        )
                                                                }
                                                                accounts
                                                        }
                                        }

                                // Populate transaction history for each account
                                accounts.forEach { account ->
                                        account.recentTransactionHistoryDetails =
                                                transactionHistoryRepository
                                                        .findRecentTransactionHistoryDetailOfAccount(
                                                                account.id
                                                        )
                                }

                                accounts
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                emptyList()
                        }
                }
}
