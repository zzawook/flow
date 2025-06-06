package sg.flow.repositories.transactionHistory

import java.sql.Date
import java.sql.ResultSetMetaData
import java.sql.SQLException
import java.sql.Time
import java.time.LocalDate
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Repository
import sg.flow.configs.DatabaseConnectionPool
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory
import sg.flow.entities.utils.AccountType
import sg.flow.entities.utils.CardType
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.utils.TransactionHistoryQueryStore

@Repository
class TransactionHistoryRepositoryImpl(private val databaseConnectionPool: DatabaseConnectionPool) :
        TransactionHistoryRepository {

        override suspend fun save(entity: TransactionHistory): TransactionHistory =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: throw RuntimeException("Failed to get connection")
                        val hasId = entity.id != null
                        val queryString =
                                if (hasId)
                                        TransactionHistoryQueryStore
                                                .SAVE_TRANSACTION_HISTORY_WITH_ID
                                else TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY
                        val parameterStart = if (hasId) 1 else 0

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(queryString).use { pstm ->
                                                if (hasId) {
                                                        pstm.setLong(parameterStart, entity.id!!)
                                                }
                                                pstm.setString(
                                                        parameterStart + 1,
                                                        entity.transactionReference
                                                )

                                                if (entity.account != null) {
                                                        pstm.setLong(
                                                                parameterStart + 2,
                                                                entity.account.id!!
                                                        )
                                                } else {
                                                        pstm.setNull(
                                                                parameterStart + 2,
                                                                java.sql.Types.BIGINT
                                                        )
                                                }

                                                if (entity.card != null) {
                                                        pstm.setLong(
                                                                parameterStart + 3,
                                                                entity.card.id!!
                                                        )
                                                } else {
                                                        pstm.setNull(
                                                                parameterStart + 3,
                                                                java.sql.Types.BIGINT
                                                        )
                                                }

                                                pstm.setDate(
                                                        parameterStart + 4,
                                                        Date.valueOf(entity.transactionDate)
                                                )
                                                pstm.setTime(
                                                        parameterStart + 5,
                                                        entity.transactionTime?.let {
                                                                Time.valueOf(it)
                                                        }
                                                )
                                                pstm.setDouble(parameterStart + 6, entity.amount)
                                                pstm.setString(
                                                        parameterStart + 7,
                                                        entity.transactionType
                                                )
                                                pstm.setString(
                                                        parameterStart + 8,
                                                        entity.description
                                                )
                                                pstm.setString(
                                                        parameterStart + 9,
                                                        entity.transactionStatus
                                                )
                                                pstm.setString(
                                                        parameterStart + 10,
                                                        entity.friendlyDescription
                                                )

                                                pstm.executeUpdate()
                                                entity
                                        }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                throw RuntimeException("Failed to save transaction history", e)
                        }
                }

        override suspend fun findById(id: Long): TransactionHistory? =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection() ?: return@withContext null

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(
                                                        TransactionHistoryQueryStore
                                                                .FIND_TRANSACTION_HISTORY_BY_ID
                                                )
                                                .use { pstm ->
                                                        pstm.setLong(1, id)
                                                        val resultSet = pstm.executeQuery()

                                                        if (resultSet.next()) {
                                                                TransactionHistory(
                                                                        id =
                                                                                resultSet.getLong(
                                                                                        "id"
                                                                                ),
                                                                        transactionReference =
                                                                                resultSet.getString(
                                                                                        "transaction_reference"
                                                                                ),
                                                                        account =
                                                                                if (resultSet
                                                                                                .getObject(
                                                                                                        "account_id"
                                                                                                ) !=
                                                                                                null
                                                                                ) {
                                                                                        Account(
                                                                                                id =
                                                                                                        resultSet
                                                                                                                .getLong(
                                                                                                                        "account_id"
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
                                                                                                lastUpdated =
                                                                                                        resultSet
                                                                                                                .getTimestamp(
                                                                                                                        "last_updated"
                                                                                                                )
                                                                                                                .toLocalDateTime(),
                                                                                                interestRatePerAnnum =
                                                                                                        0.0,
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
                                                                                                        null // This will be loaded separately if needed
                                                                                        )
                                                                                } else null,
                                                                        card =
                                                                                if (resultSet
                                                                                                .getObject(
                                                                                                        "card_id"
                                                                                                ) !=
                                                                                                null
                                                                                ) {
                                                                                        Card(
                                                                                                id =
                                                                                                        resultSet
                                                                                                                .getLong(
                                                                                                                        "card_id"
                                                                                                                ),
                                                                                                cardNumber =
                                                                                                        resultSet
                                                                                                                .getString(
                                                                                                                        "card_number"
                                                                                                                ),
                                                                                                cardType =
                                                                                                        CardType.valueOf(
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "card_type"
                                                                                                                        )
                                                                                                        ),
                                                                                                owner =
                                                                                                        null,
                                                                                                issuingBank =
                                                                                                        null,
                                                                                                linkedAccount =
                                                                                                        null,
                                                                                                cvv =
                                                                                                        "",
                                                                                                expiryDate =
                                                                                                        LocalDate
                                                                                                                .now(),
                                                                                                cardHolderName =
                                                                                                        "",
                                                                                                pin =
                                                                                                        "",
                                                                                                cardStatus =
                                                                                                        "",
                                                                                                addressLine1 =
                                                                                                        "",
                                                                                                addressLine2 =
                                                                                                        "",
                                                                                                city =
                                                                                                        "",
                                                                                                state =
                                                                                                        "",
                                                                                                country =
                                                                                                        "",
                                                                                                zipCode =
                                                                                                        "",
                                                                                                phone =
                                                                                                        "",
                                                                                                dailyLimit =
                                                                                                        0.0,
                                                                                                monthlyLimit =
                                                                                                        0.0
                                                                                        )
                                                                                } else null,
                                                                        transactionDate =
                                                                                resultSet
                                                                                        .getDate(
                                                                                                "transaction_date"
                                                                                        )
                                                                                        .toLocalDate(),
                                                                        transactionTime =
                                                                                resultSet
                                                                                        .getTime(
                                                                                                "transaction_time"
                                                                                        )
                                                                                        ?.toLocalTime(),
                                                                        amount =
                                                                                resultSet.getDouble(
                                                                                        "amount"
                                                                                ),
                                                                        transactionType =
                                                                                resultSet.getString(
                                                                                        "transaction_type"
                                                                                ),
                                                                        description =
                                                                                resultSet.getString(
                                                                                        "description"
                                                                                ),
                                                                        transactionStatus =
                                                                                resultSet.getString(
                                                                                        "transaction_status"
                                                                                ),
                                                                        friendlyDescription =
                                                                                resultSet.getString(
                                                                                        "friendly_description"
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
                                        conn.prepareStatement(
                                                        TransactionHistoryQueryStore
                                                                .DELETE_ALL_TRANSACTION_HISTORIES
                                                )
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

        override suspend fun findRecentTransactionHistoryDetailOfAccount(
                accountId: Long
        ): List<TransactionHistoryDetail> =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: return@withContext emptyList()

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(
                                                        TransactionHistoryQueryStore
                                                                .FIND_RECENT_TRANSACTION_HISTORY_BY_ACCOUNT_ID
                                                )
                                                .use { pstm ->
                                                        pstm.setLong(1, accountId)
                                                        val resultSet = pstm.executeQuery()
                                                        val transactions =
                                                                mutableListOf<
                                                                        TransactionHistoryDetail>()

                                                        while (resultSet.next()) {
                                                                transactions.add(
                                                                        TransactionHistoryDetail(
                                                                                id =
                                                                                        resultSet
                                                                                                .getLong(
                                                                                                        "id"
                                                                                                ),
                                                                                transactionReference =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_reference"
                                                                                                ),
                                                                                account =
                                                                                        if (resultSet
                                                                                                        .getObject(
                                                                                                                "account_id"
                                                                                                        ) !=
                                                                                                        null
                                                                                        ) {
                                                                                                Account(
                                                                                                        id =
                                                                                                                resultSet
                                                                                                                        .getLong(
                                                                                                                                "account_id"
                                                                                                                        ),
                                                                                                        accountNumber =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "account_number"
                                                                                                                        ),
                                                                                                        balance =
                                                                                                                resultSet
                                                                                                                        .getDouble(
                                                                                                                                "account_balance"
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
                                                                                                        lastUpdated =
                                                                                                                resultSet
                                                                                                                        .getTimestamp(
                                                                                                                                "account_last_updated"
                                                                                                                        )
                                                                                                                        .toLocalDateTime(),
                                                                                                        interestRatePerAnnum =
                                                                                                                0.0,
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
                                                                                                                null
                                                                                                )
                                                                                        } else null,
                                                                                card =
                                                                                        if (resultSet
                                                                                                        .getObject(
                                                                                                                "card_id"
                                                                                                        ) !=
                                                                                                        null
                                                                                        ) {
                                                                                                Card(
                                                                                                        id =
                                                                                                                resultSet
                                                                                                                        .getLong(
                                                                                                                                "card_id"
                                                                                                                        ),
                                                                                                        cardNumber =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "card_number"
                                                                                                                        ),
                                                                                                        cardType =
                                                                                                                CardType.valueOf(
                                                                                                                        resultSet
                                                                                                                                .getString(
                                                                                                                                        "card_type"
                                                                                                                                )
                                                                                                                ),
                                                                                                        owner =
                                                                                                                null,
                                                                                                        issuingBank =
                                                                                                                null,
                                                                                                        linkedAccount =
                                                                                                                null,
                                                                                                        cvv =
                                                                                                                "",
                                                                                                        expiryDate =
                                                                                                                LocalDate
                                                                                                                        .now(),
                                                                                                        cardHolderName =
                                                                                                                "",
                                                                                                        pin =
                                                                                                                "",
                                                                                                        cardStatus =
                                                                                                                "",
                                                                                                        addressLine1 =
                                                                                                                "",
                                                                                                        addressLine2 =
                                                                                                                "",
                                                                                                        city =
                                                                                                                "",
                                                                                                        state =
                                                                                                                "",
                                                                                                        country =
                                                                                                                "",
                                                                                                        zipCode =
                                                                                                                "",
                                                                                                        phone =
                                                                                                                "",
                                                                                                        dailyLimit =
                                                                                                                0.0,
                                                                                                        monthlyLimit =
                                                                                                                0.0
                                                                                                )
                                                                                        } else null,
                                                                                transactionDate =
                                                                                        resultSet
                                                                                                .getDate(
                                                                                                        "transaction_date"
                                                                                                )
                                                                                                .toLocalDate(),
                                                                                transactionTime =
                                                                                        resultSet
                                                                                                .getTime(
                                                                                                        "transaction_time"
                                                                                                )
                                                                                                ?.toLocalTime(),
                                                                                amount =
                                                                                        resultSet
                                                                                                .getDouble(
                                                                                                        "amount"
                                                                                                ),
                                                                                transactionType =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_type"
                                                                                                ),
                                                                                description =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "description"
                                                                                                ),
                                                                                transactionStatus =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_status"
                                                                                                ),
                                                                                friendlyDescription =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "friendly_description"
                                                                                                )
                                                                        )
                                                                )
                                                        }
                                                        transactions
                                                }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                emptyList()
                        }
                }

        override suspend fun findTransactionBetweenDates(
                userId: Int,
                startDate: LocalDate,
                endDate: LocalDate
        ): TransactionHistoryList = findTransactionBetweenDates(userId, startDate, endDate, 30)

        override suspend fun findTransactionBetweenDates(
                userId: Int,
                startDate: LocalDate,
                endDate: LocalDate,
                limit: Int
        ): TransactionHistoryList =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection()
                                        ?: return@withContext TransactionHistoryList(
                                                startDate,
                                                endDate
                                        )

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(
                                                        TransactionHistoryQueryStore
                                                                .FIND_TRANSACTION_BETWEEN_DATES
                                                )
                                                .use { pstm ->
                                                        pstm.setDate(1, Date.valueOf(startDate))
                                                        pstm.setDate(2, Date.valueOf(endDate))
                                                        pstm.setInt(3, userId)
                                                        pstm.setInt(4, limit)

                                                        val transactionHistoryList =
                                                                TransactionHistoryList(
                                                                        startDate,
                                                                        endDate
                                                                )
                                                        val resultSet = pstm.executeQuery()

                                                        while (resultSet.next()) {
                                                                val transactionHistoryDetail =
                                                                        TransactionHistoryDetail(
                                                                                id =
                                                                                        resultSet
                                                                                                .getLong(
                                                                                                        "id"
                                                                                                ),
                                                                                transactionReference =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_reference"
                                                                                                ),
                                                                                account =
                                                                                        if (resultSet
                                                                                                        .getObject(
                                                                                                                "account_id"
                                                                                                        ) !=
                                                                                                        null
                                                                                        ) {
                                                                                                Account(
                                                                                                        id =
                                                                                                                resultSet
                                                                                                                        .getLong(
                                                                                                                                "account_id"
                                                                                                                        ),
                                                                                                        accountNumber =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "account_number"
                                                                                                                        ),
                                                                                                        balance =
                                                                                                                resultSet
                                                                                                                        .getDouble(
                                                                                                                                "account_balance"
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
                                                                                                        lastUpdated =
                                                                                                                resultSet
                                                                                                                        .getTimestamp(
                                                                                                                                "account_last_updated"
                                                                                                                        )
                                                                                                                        .toLocalDateTime(),
                                                                                                        interestRatePerAnnum =
                                                                                                                0.0,
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
                                                                                                                null
                                                                                                )
                                                                                        } else null,
                                                                                card =
                                                                                        if (resultSet
                                                                                                        .getObject(
                                                                                                                "card_id"
                                                                                                        ) !=
                                                                                                        null
                                                                                        ) {
                                                                                                Card(
                                                                                                        id =
                                                                                                                resultSet
                                                                                                                        .getLong(
                                                                                                                                "card_id"
                                                                                                                        ),
                                                                                                        cardNumber =
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "card_number"
                                                                                                                        ),
                                                                                                        cardType =
                                                                                                                CardType.valueOf(
                                                                                                                        resultSet
                                                                                                                                .getString(
                                                                                                                                        "card_type"
                                                                                                                                )
                                                                                                                ),
                                                                                                        owner =
                                                                                                                null,
                                                                                                        issuingBank =
                                                                                                                null,
                                                                                                        linkedAccount =
                                                                                                                null,
                                                                                                        cvv =
                                                                                                                "",
                                                                                                        expiryDate =
                                                                                                                LocalDate
                                                                                                                        .now(),
                                                                                                        cardHolderName =
                                                                                                                "",
                                                                                                        pin =
                                                                                                                "",
                                                                                                        cardStatus =
                                                                                                                "",
                                                                                                        addressLine1 =
                                                                                                                "",
                                                                                                        addressLine2 =
                                                                                                                "",
                                                                                                        city =
                                                                                                                "",
                                                                                                        state =
                                                                                                                "",
                                                                                                        country =
                                                                                                                "",
                                                                                                        zipCode =
                                                                                                                "",
                                                                                                        phone =
                                                                                                                "",
                                                                                                        dailyLimit =
                                                                                                                0.0,
                                                                                                        monthlyLimit =
                                                                                                                0.0
                                                                                                )
                                                                                        } else null,
                                                                                transactionDate =
                                                                                        resultSet
                                                                                                .getDate(
                                                                                                        "transaction_date"
                                                                                                )
                                                                                                .toLocalDate(),
                                                                                transactionTime =
                                                                                        resultSet
                                                                                                .getTime(
                                                                                                        "transaction_time"
                                                                                                )
                                                                                                ?.toLocalTime(),
                                                                                amount =
                                                                                        resultSet
                                                                                                .getDouble(
                                                                                                        "amount"
                                                                                                ),
                                                                                transactionType =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_type"
                                                                                                ),
                                                                                description =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "description"
                                                                                                ),
                                                                                transactionStatus =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "transaction_status"
                                                                                                ),
                                                                                friendlyDescription =
                                                                                        resultSet
                                                                                                .getString(
                                                                                                        "friendly_description"
                                                                                                )
                                                                        )
                                                                transactionHistoryList.add(
                                                                        transactionHistoryDetail
                                                                )
                                                        }
                                                        transactionHistoryList
                                                }
                                }
                        } catch (e: SQLException) {
                                e.printStackTrace()
                                TransactionHistoryList(startDate, endDate)
                        }
                }

        override suspend fun findTransactionDetailById(id: Long): TransactionHistoryDetail? =
                withContext(Dispatchers.IO) {
                        val connection =
                                databaseConnectionPool.getConnection() ?: return@withContext null

                        try {
                                connection.use { conn ->
                                        conn.prepareStatement(
                                                        TransactionHistoryQueryStore
                                                                .FIND_TRANSACTION_DETAIL_BY_ID
                                                )
                                                .use { pstm ->
                                                        pstm.setLong(1, id)
                                                        val resultSet = pstm.executeQuery()

                                                        if (resultSet.next()) {
                                                                TransactionHistoryDetail(
                                                                        id =
                                                                                resultSet.getLong(
                                                                                        "id"
                                                                                ),
                                                                        transactionReference =
                                                                                resultSet.getString(
                                                                                        "transaction_reference"
                                                                                ),
                                                                        account =
                                                                                if (resultSet
                                                                                                .getObject(
                                                                                                        "account_id"
                                                                                                ) !=
                                                                                                null
                                                                                ) {
                                                                                        Account(
                                                                                                id =
                                                                                                        resultSet
                                                                                                                .getLong(
                                                                                                                        "account_id"
                                                                                                                ),
                                                                                                accountNumber =
                                                                                                        resultSet
                                                                                                                .getString(
                                                                                                                        "account_number"
                                                                                                                ),
                                                                                                balance =
                                                                                                        resultSet
                                                                                                                .getDouble(
                                                                                                                        "account_balance"
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
                                                                                                lastUpdated =
                                                                                                        resultSet
                                                                                                                .getTimestamp(
                                                                                                                        "account_last_updated"
                                                                                                                )
                                                                                                                .toLocalDateTime(),
                                                                                                interestRatePerAnnum =
                                                                                                        0.0,
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
                                                                                                        null
                                                                                        )
                                                                                } else null,
                                                                        card =
                                                                                if (resultSet
                                                                                                .getObject(
                                                                                                        "card_id"
                                                                                                ) !=
                                                                                                null
                                                                                ) {
                                                                                        Card(
                                                                                                id =
                                                                                                        resultSet
                                                                                                                .getLong(
                                                                                                                        "card_id"
                                                                                                                ),
                                                                                                cardNumber =
                                                                                                        resultSet
                                                                                                                .getString(
                                                                                                                        "card_number"
                                                                                                                ),
                                                                                                cardType =
                                                                                                        CardType.valueOf(
                                                                                                                resultSet
                                                                                                                        .getString(
                                                                                                                                "card_type"
                                                                                                                        )
                                                                                                        ),
                                                                                                owner =
                                                                                                        null,
                                                                                                issuingBank =
                                                                                                        null,
                                                                                                linkedAccount =
                                                                                                        null,
                                                                                                cvv =
                                                                                                        "",
                                                                                                expiryDate =
                                                                                                        LocalDate
                                                                                                                .now(),
                                                                                                cardHolderName =
                                                                                                        "",
                                                                                                pin =
                                                                                                        "",
                                                                                                cardStatus =
                                                                                                        "",
                                                                                                addressLine1 =
                                                                                                        "",
                                                                                                addressLine2 =
                                                                                                        "",
                                                                                                city =
                                                                                                        "",
                                                                                                state =
                                                                                                        "",
                                                                                                country =
                                                                                                        "",
                                                                                                zipCode =
                                                                                                        "",
                                                                                                phone =
                                                                                                        "",
                                                                                                dailyLimit =
                                                                                                        0.0,
                                                                                                monthlyLimit =
                                                                                                        0.0
                                                                                        )
                                                                                } else null,
                                                                        transactionDate =
                                                                                resultSet
                                                                                        .getDate(
                                                                                                "transaction_date"
                                                                                        )
                                                                                        .toLocalDate(),
                                                                        transactionTime =
                                                                                resultSet
                                                                                        .getTime(
                                                                                                "transaction_time"
                                                                                        )
                                                                                        ?.toLocalTime(),
                                                                        amount =
                                                                                resultSet.getDouble(
                                                                                        "amount"
                                                                                ),
                                                                        transactionType =
                                                                                resultSet.getString(
                                                                                        "transaction_type"
                                                                                ),
                                                                        description =
                                                                                resultSet.getString(
                                                                                        "description"
                                                                                ),
                                                                        transactionStatus =
                                                                                resultSet.getString(
                                                                                        "transaction_status"
                                                                                ),
                                                                        friendlyDescription =
                                                                                resultSet.getString(
                                                                                        "friendly_description"
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

        // Helper function from the original Java code
        private fun containsColumnLabel(
                resultSet: java.sql.ResultSet,
                columnName: String
        ): Boolean {
                return try {
                        val metaData: ResultSetMetaData = resultSet.metaData
                        val columnCount = metaData.columnCount
                        for (i in 1..columnCount) {
                                val columnLabel = metaData.getColumnLabel(i)
                                if (columnLabel == columnName) {
                                        return true
                                }
                        }
                        false
                } catch (e: SQLException) {
                        false
                }
        }
}
