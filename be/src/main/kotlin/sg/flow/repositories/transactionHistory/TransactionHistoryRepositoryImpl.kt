package sg.flow.repositories.transactionHistory

import io.r2dbc.spi.Row
import java.time.LocalDate
import java.time.LocalTime
import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.TransactionHistory
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.entities.utils.CardType
import sg.flow.models.card.BriefCard
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.utils.TransactionHistoryQueryStore

@Repository
class TransactionHistoryRepositoryImpl(private val databaseClient: DatabaseClient) :
        TransactionHistoryRepository {

        private val logger = LoggerFactory.getLogger(TransactionHistoryRepositoryImpl::class.java)

        override suspend fun save(entity: TransactionHistory): TransactionHistory {
                val hasId = entity.id != null
                val sql =
                        if (hasId)
                                TransactionHistoryQueryStore
                                        .SAVE_TRANSACTION_HISTORY_WITH_ID // INSERT … (id, …)
                        else TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY

                // ── build the parameter list ─────────────────────────────
                var i = 0
                var spec = databaseClient.sql(sql)

                if (hasId) {
                        spec = spec.bind(i++, entity.id!!) // $1  (id)
                }

                spec =
                        spec.bind(i++, entity.transactionReference) // $2 / $1
                                .let { s ->
                                        entity.account?.id?.let { accId -> s.bind(i++, accId) }
                                                ?: s.bindNull(i++, Long::class.java)
                                }
                                .let { s -> // card_id (nullable)
                                        entity.card?.id?.let { cardId -> s.bind(i++, cardId) }
                                                ?: s.bindNull(i++, Long::class.java)
                                }
                                .let { s ->
                                        entity.account?.owner?.let { owner ->
                                                s.bind(i++, owner.id ?: -1)
                                        }
                                                ?: s.bindNull(i++, Int::class.java)
                                }
                                .bind(i++, entity.transactionDate) // LocalDate → DATE
                                .let { s -> // LocalTime → TIME (nullable)
                                        entity.transactionTime?.let { time -> s.bind(i++, time) }
                                                ?: s.bindNull(i++, java.time.LocalTime::class.java)
                                }
                                .bind(i++, entity.amount)
                                .bind(i++, entity.transactionType.toString())
                                .bind(i++, entity.description)
                                .bind(i++, entity.transactionStatus.toString())
                                .bind(i++, entity.friendlyDescription)
                                .bind(i++, entity.finverseId)

                // ── execute ─────────────────────────────────────────────
                runCatching {
                        val rows = spec.fetch().awaitRowsUpdated() // suspend
                        if (rows != 1L) {
                                logger.info(
                                        "Duplicate row - skipping insertion: ${spec.toString()}"
                                )
                        }
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error saving transaction history id=${entity.id}")
                                throw e // bubble up (or return a sentinel)
                        }

                return entity
        }

        private fun multiInsertSql(rowCount: Int): String {
                require(rowCount > 0) { "entities must not be empty" }

                val cols =
                        """
        (id, transaction_reference, account_id, card_id, user_id, transaction_date,
         transaction_time, amount, transaction_type, description,
         transaction_status, friendly_description)
    """.trimIndent()

                val paramsPerRow = 12
                val valuesClause =
                        (0 until rowCount).joinToString(", ") { rowIdx ->
                                val start = rowIdx * paramsPerRow + 1 // 1‑based in Postgres
                                val end = start + paramsPerRow - 1
                                "(" + (start..end).joinToString(", ") { "$$it" } + ")"
                        }

                return "INSERT INTO transaction_histories $cols VALUES $valuesClause"
        }

        override suspend fun saveAllWithId(
                entities: List<TransactionHistory>
        ): List<TransactionHistory> {

                val sql = multiInsertSql(entities.size)
                var spec = databaseClient.sql(sql)
                var i = 0 // global index across all rows

                entities.forEach { e ->
                        // non‑null because of the pre‑condition
                        spec =
                                spec.bind(i++, e.id ?: 0) // id
                                        .bind(i++, e.transactionReference) // transaction_reference
                                        .bind(i++, e.account?.id ?: -1) // account_id

                        spec =
                                e.card?.id?.let { spec.bind(i++, it) } // card_id (nullable)
                                 ?: spec.bindNull(i++, Long::class.java)

                        spec = spec.bind(i++, e.account?.owner?.id ?: -1)

                        spec = spec.bind(i++, e.transactionDate) // transaction_date

                        spec =
                                e.transactionTime?.let {
                                        spec.bind(i++, it)
                                } // transaction_time (nullable)
                                 ?: spec.bindNull(i++, LocalTime::class.java)

                        spec =
                                spec.bind(i++, e.amount) // amount
                                        .bind(i++, e.transactionType.toString()) // transaction_type
                                        .bind(i++, e.description) // description
                                        .bind(
                                                i++,
                                                e.transactionStatus.toString()
                                        ) // transaction_status
                                        .bind(i++, e.friendlyDescription) // friendly_description
                }

                val rows = spec.fetch().awaitRowsUpdated()
                require(rows == entities.size.toLong()) {
                        "Expected ${entities.size} rows, database reported $rows"
                }
                return entities
        }

        override suspend fun findById(id: Long): TransactionHistory? {
                return runCatching {
                                databaseClient
                                        .sql(
                                                TransactionHistoryQueryStore
                                                        .FIND_TRANSACTION_HISTORY_BY_ID
                                        )
                                        .bind(0, id) // SQL has “… WHERE th.id = $1”
                                        .map { row ->
                                                // ────────────── build nested objects
                                                // ──────────────
                                                val account =
                                                        Account(
                                                                id =
                                                                        row.get(
                                                                                "account_id",
                                                                                Long::class.java
                                                                        )!!,
                                                                accountNumber =
                                                                        row.get(
                                                                                "account_number",
                                                                                String::class.java
                                                                        )!!,
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
                                                                accountType =
                                                                        AccountType.valueOf(
                                                                                row.get(
                                                                                        "account_type",
                                                                                        String::class
                                                                                                .java
                                                                                )!!
                                                                        ),
                                                                lastUpdated =
                                                                        row.get(
                                                                                "last_updated",
                                                                                java.time
                                                                                                .LocalDateTime::class
                                                                                        .java
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
                                                                        ),
                                                                owner =
                                                                        User(
                                                                                id =
                                                                                        row.get(
                                                                                                "user_id",
                                                                                                Int::class
                                                                                                        .java
                                                                                        )!!,
                                                                                name =
                                                                                        row.get(
                                                                                                "user_name",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!,
                                                                                email =
                                                                                        row.get(
                                                                                                "email",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!,
                                                                                phoneNumber =
                                                                                        row.get(
                                                                                                "phoneNUmber",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!,
                                                                                dateOfBirth =
                                                                                        row.get(
                                                                                                "date_of_birth",
                                                                                                LocalDate::class
                                                                                                        .java
                                                                                        )!!,
                                                                                address =
                                                                                        row.get(
                                                                                                "address",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!,
                                                                                identificationNumber =
                                                                                        row.get(
                                                                                                "identification_number",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!,
                                                                                settingJson =
                                                                                        row.get(
                                                                                                "setting_json",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "{}",
                                                                        ),
                                                                finverseId =
                                                                        row.get(
                                                                                "finverse_id",
                                                                                String::class.java
                                                                        )
                                                                                ?: "",
                                                        )

                                                val cardId = row.get("card_id")
                                                val card =
                                                        if (cardId != null)
                                                                row.get("card_id", Long::class.java)
                                                                        ?.let {
                                                                                BriefCard(
                                                                                        id = it,
                                                                                        cardNumber =
                                                                                                row.get(
                                                                                                        "card_number",
                                                                                                        String::class
                                                                                                                .java
                                                                                                )!!,
                                                                                        cardType =
                                                                                                CardType.valueOf(
                                                                                                        row.get(
                                                                                                                "card_type",
                                                                                                                String::class
                                                                                                                        .java
                                                                                                        )!!
                                                                                                )
                                                                                )
                                                                        }
                                                        else null

                                                // ────────────── final entity ──────────────
                                                TransactionHistory(
                                                        id = row.get("id", Long::class.java)!!,
                                                        transactionReference =
                                                                row.get(
                                                                        "transaction_reference",
                                                                        String::class.java
                                                                )!!,
                                                        account = account,
                                                        card = card,
                                                        transactionDate =
                                                                row.get(
                                                                        "transaction_date",
                                                                        java.time.LocalDate::class
                                                                                .java
                                                                )!!,
                                                        transactionTime =
                                                                row.get(
                                                                        "transaction_time",
                                                                        java.time.LocalTime::class
                                                                                .java
                                                                )!!,
                                                        amount =
                                                                row.get(
                                                                        "amount",
                                                                        Double::class.java
                                                                )!!,
                                                        transactionType =
                                                                row.get(
                                                                        "transaction_type",
                                                                        String::class.java
                                                                )!!,
                                                        description =
                                                                row.get(
                                                                        "description",
                                                                        String::class.java
                                                                )!!,
                                                        transactionStatus =
                                                                row.get(
                                                                        "transaction_status",
                                                                        String::class.java
                                                                )!!,
                                                        friendlyDescription =
                                                                row.get(
                                                                        "friendly_description",
                                                                        String::class.java
                                                                )!!,
                                                        finverseId =
                                                                row.get(
                                                                        "finverse_id",
                                                                        String::class.java
                                                                )!!
                                                )
                                        }
                                        .one()
                                        .awaitSingleOrNull() // suspend function to get the first
                                // result or null
                        }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error fetching transaction history id=$id")
                        }
                        .getOrNull()
        }

        override suspend fun deleteAll(): Boolean {
                return try {
                        databaseClient
                                .sql(TransactionHistoryQueryStore.DELETE_ALL_TRANSACTION_HISTORIES)
                                .fetch()
                                .awaitRowsUpdated()
                        true
                } catch (e: Exception) {
                        e.printStackTrace()
                        false
                }
        }

        override suspend fun findRecentTransactionHistoryDetailOfAccount(
                accountId: Long
        ): List<TransactionHistoryDetail> {
                return runCatching {
                        databaseClient
                                .sql(
                                        TransactionHistoryQueryStore
                                                .FIND_RECENT_TRANSACTION_HISTORY_BY_ACCOUNT_ID
                                )
                                .bind(0, accountId)
                                .map { row ->

                                        /* ── nested Account (nullable) ───────────────────────── */
                                        val account =
                                                row.get("account_id", Long::class.java)?.let {
                                                        Account(
                                                                id = it,
                                                                accountNumber =
                                                                        row.get(
                                                                                "account_number",
                                                                                String::class.java
                                                                        )!!,
                                                                balance =
                                                                        row.get(
                                                                                "account_balance",
                                                                                Double::class.java
                                                                        )!!,
                                                                accountName =
                                                                        row.get(
                                                                                "account_name",
                                                                                String::class.java
                                                                        )!!,
                                                                accountType =
                                                                        AccountType.valueOf(
                                                                                row.get(
                                                                                        "account_type",
                                                                                        String::class
                                                                                                .java
                                                                                )!!
                                                                        ),
                                                                lastUpdated =
                                                                        row.get(
                                                                                "account_last_updated",
                                                                                java.time
                                                                                                .LocalDateTime::class
                                                                                        .java
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
                                                                        ),
                                                                finverseId =
                                                                        row.get(
                                                                                "finverse_id",
                                                                                String::class.java
                                                                        )
                                                                                ?: "",
                                                                owner =
                                                                        User(
                                                                                id =
                                                                                        row.get(
                                                                                                "user_id",
                                                                                                Int::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: 0,
                                                                                name =
                                                                                        row.get(
                                                                                                "user_name",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "",
                                                                                email =
                                                                                        row.get(
                                                                                                "email",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "",
                                                                                identificationNumber =
                                                                                        row.get(
                                                                                                "identification_number",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "",
                                                                                phoneNumber =
                                                                                        row.get(
                                                                                                "phone_number",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "",
                                                                                dateOfBirth =
                                                                                        row.get(
                                                                                                "date_of_birth",
                                                                                                java.time
                                                                                                                .LocalDate::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: java.time
                                                                                                        .LocalDate
                                                                                                        .now(),
                                                                                address =
                                                                                        row.get(
                                                                                                "address",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "",
                                                                                settingJson =
                                                                                        row.get(
                                                                                                "setting_json",
                                                                                                String::class
                                                                                                        .java
                                                                                        )
                                                                                                ?: "{}"
                                                                        )
                                                        )
                                                }

                                        /* ── nested Card (nullable) ─────────────────────────── */
                                        val cardId = row.get("card_id")

                                        val card =
                                                if (cardId != null)
                                                        row.get("card_id", Long::class.java)?.let {
                                                                it ->
                                                                BriefCard(
                                                                        id = it,
                                                                        cardNumber =
                                                                                row.get(
                                                                                        "card_number",
                                                                                        String::class
                                                                                                .java
                                                                                )!!,
                                                                        cardType =
                                                                                CardType.valueOf(
                                                                                        row.get(
                                                                                                "card_type",
                                                                                                String::class
                                                                                                        .java
                                                                                        )!!
                                                                                )
                                                                )
                                                        }
                                                else null

                                        /* ── final DTO ──────────────────────────────────────── */
                                        TransactionHistoryDetail(
                                                id = row.get("id", Long::class.java)!!,
                                                account = account,
                                                card = card,
                                                transactionDate =
                                                        row.get(
                                                                "transaction_date",
                                                                java.time.LocalDate::class.java
                                                        )!!,
                                                transactionTime =
                                                        row.get(
                                                                "transaction_time",
                                                                java.time.LocalTime::class.java
                                                        )!!,
                                                amount = row.get("amount", Double::class.java)!!,
                                                transactionType =
                                                        row.get(
                                                                "transaction_type",
                                                                String::class.java
                                                        )!!,
                                                description =
                                                        row.get(
                                                                "description",
                                                                String::class.java
                                                        )!!,
                                        )
                                }
                                .all() // Flux<TransactionHistoryDetail>
                                .asFlow() // Flow<TransactionHistoryDetail>
                                .toList() // suspend → List<TransactionHistoryDetail>
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error(
                                        "Error fetching recent transactions for accountId=$accountId"
                                )
                        }
                        .getOrElse { emptyList() }
        }

        override suspend fun findTransactionBetweenDates(
                userId: Int,
                startDate: LocalDate,
                endDate: LocalDate
        ): TransactionHistoryList {
                return findTransactionBetweenDates(userId, startDate, endDate, 30)
        }

        override suspend fun findTransactionBetweenDates(
                userId: Int,
                startDate: LocalDate,
                endDate: LocalDate,
                limit: Int
        ): TransactionHistoryList {
                return runCatching {
                        /* ── fetch the rows ───────────────────────────────────────────── */
                        val details =
                                databaseClient
                                        .sql(
                                                TransactionHistoryQueryStore
                                                        .FIND_TRANSACTION_BETWEEN_DATES
                                        )
                                        .bind(0, startDate) // $1  start_date
                                        .bind(1, endDate) // $2  end_date
                                        .bind(2, userId) // $3  user_id
                                        .bind(3, limit) // $4  limit
                                        .map { row ->
                                                toTransactionHistoryDetail(row as Row)
                                        }
                                        .all() // Flux<TransactionHistoryDetail>
                                        .asFlow() // Flow<TransactionHistoryDetail>
                                        .toList() // suspend → List<TransactionHistoryDetail>

                        /* ── wrap the list in your domain object ─────────────────────── */
                        TransactionHistoryList(startDate, endDate).apply {
                                details.forEach(::add) // same as details.forEach { add(it) }
                        }
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error(
                                        "Error fetching transactions between $startDate‑$endDate for userId=$userId"
                                )
                        }
                        .getOrElse { TransactionHistoryList(startDate, endDate) }
        }

        override suspend fun findTransactionDetailById(id: Long): TransactionHistoryDetail? {
                return runCatching {
                                databaseClient
                                        .sql(
                                                TransactionHistoryQueryStore
                                                        .FIND_TRANSACTION_DETAIL_BY_ID
                                        )
                                        .bind(0, id) // “… WHERE th.id = $1”
                                        .map { row ->
                                                toTransactionHistoryDetail(row as Row)
                                        }
                                        .one() // Mono<TransactionHistoryDetail>
                                        .awaitSingleOrNull() // suspend → TransactionHistoryDetail?
                        }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error fetching transaction detail id=$id")
                        }
                        .getOrNull()
        }

        private fun toTransactionHistoryDetail(row: Row) : TransactionHistoryDetail {
                val account =
                        row.get("account_id", Long::class.java)
                                ?.let {
                                        Account(
                                                id = it,
                                                accountNumber =
                                                        row.get(
                                                                "account_number",
                                                                String::class
                                                                        .java
                                                        )!!,
                                                balance =
                                                        row.get(
                                                                "account_balance",
                                                                Double::class
                                                                        .java
                                                        )!!,
                                                accountName =
                                                        row.get(
                                                                "account_name",
                                                                String::class
                                                                        .java
                                                        )!!,
                                                accountType =
                                                        AccountType
                                                                .valueOf(
                                                                        row.get(
                                                                                "account_type",
                                                                                String::class
                                                                                        .java
                                                                        )!!
                                                                ),
                                                lastUpdated =
                                                        row.get(
                                                                "account_last_updated",
                                                                java.time
                                                                        .LocalDateTime::class
                                                                        .java
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
                                                        ),
                                                owner =
                                                        User(
                                                                id =
                                                                        row.get(
                                                                                "user_id",
                                                                                Int::class
                                                                                        .java
                                                                        ),
                                                                name =
                                                                        row.get(
                                                                                "user_name",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "",
                                                                email =
                                                                        row.get(
                                                                                "email",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "",
                                                                identificationNumber =
                                                                        row.get(
                                                                                "identification_number",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "",
                                                                phoneNumber =
                                                                        row.get(
                                                                                "phone_number",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "",
                                                                dateOfBirth =
                                                                        row.get(
                                                                                "date_of_birth",
                                                                                java.time
                                                                                        .LocalDate::class
                                                                                        .java
                                                                        )
                                                                                ?: java.time
                                                                                        .LocalDate
                                                                                        .now(),
                                                                address =
                                                                        row.get(
                                                                                "address",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "",
                                                                settingJson =
                                                                        row.get(
                                                                                "setting_json",
                                                                                String::class
                                                                                        .java
                                                                        )
                                                                                ?: "{}"
                                                        ),
                                                finverseId =
                                                        row.get(
                                                                "account_finverse_id",
                                                                String::class
                                                                        .java
                                                        )
                                                                ?: ""
                                        )
                                }

                /* nested Card (nullable) */

                val cardId = row.get("card_id")

                val card =
                        if (cardId != null)
                                row.get("card_id", Long::class.java)
                                        ?.let { cid ->
                                                BriefCard(
                                                        id =
                                                                cid.toLong(),
                                                        cardNumber =
                                                                row.get(
                                                                        "card_number",
                                                                        String::class
                                                                                .java
                                                                )!!,
                                                        cardType =
                                                                CardType.valueOf(
                                                                        row.get(
                                                                                "card_type",
                                                                                String::class
                                                                                        .java
                                                                        )!!
                                                                )
                                                )
                                        }
                        else null

                /* final DTO */
                return TransactionHistoryDetail(
                        id = row.get("id", Long::class.java)!!,
                        transactionReference =
                                row.get(
                                        "transaction_reference",
                                        String::class.java
                                )!!,
                        account = account,
                        card = card,
                        transactionDate =
                                row.get(
                                        "transaction_date",
                                        java.time.LocalDate::class
                                                .java
                                )!!,
                        transactionTime =
                                row.get(
                                        "transaction_time",
                                        java.time.LocalTime::class
                                                .java
                                ),
                        amount =
                                row.get(
                                        "amount",
                                        Double::class.java
                                )!!,
                        transactionType =
                                row.get(
                                        "transaction_type",
                                        String::class.java
                                ),
                        description =
                                row.get(
                                        "description",
                                        String::class.java
                                )!!,
                        transactionStatus =
                                row.get(
                                        "transaction_status",
                                        String::class.java
                                ),
                        friendlyDescription =
                                row.get(
                                        "friendly_description",
                                        String::class.java
                                ),
                        transactionCategory =
                                row.get(
                                        "transaction_category",
                                        String::class.java
                                ),
                        revisedTransactionDate =
                                row.get(
                                        "revised_transaction_date",
                                        java.time.LocalDate::class.java
                                ),
                        brandName =
                                row.get(
                                        "brand_name",
                                        String::class.java
                                )
                )
        }

        override suspend fun findUnprocessedTransactions(): List<TransactionHistory> {
                return runCatching {
                        databaseClient
                                .sql(TransactionHistoryQueryStore.FIND_UNPROCESSED_TRANSACTIONS)
                                .map { row -> mapRowToTransactionHistory(row as Row) }
                                .all()
                                .asFlow()
                                .toList()
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error fetching unprocessed transactions", e)
                        }
                        .getOrElse { emptyList() }
        }

        override suspend fun findUnprocessedTransactionsByUserId(
                userId: Int
        ): List<TransactionHistory> {
                return runCatching {
                        databaseClient
                                .sql(
                                        TransactionHistoryQueryStore
                                                .FIND_UNPROCESSED_TRANSACTIONS_BY_USER_ID
                                )
                                .bind(0, userId)
                                .map { row -> mapRowToTransactionHistory(row as Row) }
                                .all()
                                .asFlow()
                                .toList()
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error(
                                        "Error fetching unprocessed transactions for user $userId",
                                        e
                                )
                        }
                        .getOrElse { emptyList() }
        }

        override suspend fun updateTransactionAnalysis(
                id: Long,
                category: String?,
                friendlyDescription: String?,
                extractedCardNumber: String?,
                brandName: String?,
                revisedTransactionDate: LocalDate?,
                isProcessed: Boolean
        ): Boolean {
                return runCatching {
                        val rowsUpdated =
                                databaseClient
                                        .sql(
                                                TransactionHistoryQueryStore
                                                        .UPDATE_TRANSACTION_ANALYSIS
                                        )
                                        .bind(0, id)
                                        .let { spec ->
                                                category?.let { spec.bind(1, it) }
                                                        ?: spec.bindNull(1, String::class.java)
                                        }
                                        .let { spec ->
                                                friendlyDescription?.let { spec.bind(2, it) }
                                                        ?: spec.bindNull(2, String::class.java)
                                        }
                                        .let { spec ->
                                                extractedCardNumber?.let { spec.bind(3, it) }
                                                        ?: spec.bindNull(3, String::class.java)
                                        }
                                        .let { spec ->
                                                brandName?.let { spec.bind(4, it) }
                                                        ?: spec.bindNull(4, String::class.java)
                                        }
                                        .let { spec ->
                                                revisedTransactionDate?.let { spec.bind(5, it) }
                                                        ?: spec.bindNull(5, LocalDate::class.java)
                                        }
                                        .bind(6, isProcessed)
                                        .fetch()
                                        .awaitRowsUpdated()

                        rowsUpdated == 1L
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error updating transaction analysis for id=$id", e)
                        }
                        .getOrElse { false }
        }

        override suspend fun batchUpdateTransactionAnalysis(
                updates: List<TransactionAnalysisUpdate>
        ): Int {
                if (updates.isEmpty()) return 0

                return runCatching {
                        var totalUpdated = 0

                        // Process updates in batches for efficient batch operations
                        updates.chunked(50).forEach { batch ->
                                logger.info("Processing batch of ${batch.size} transaction updates")

                                batch.forEach { update ->
                                        val success =
                                                updateTransactionAnalysis(
                                                        update.transactionId,
                                                        update.category,
                                                        update.friendlyDescription,
                                                        update.extractedCardNumber,
                                                        update.brandName,
                                                        update.revisedTransactionDate,
                                                        update.isProcessed
                                                )
                                        if (success) totalUpdated++
                                }

                                logger.info("Completed batch: $totalUpdated total updates so far")
                        }

                        logger.info("Batch update completed: $totalUpdated transactions updated")
                        totalUpdated
                }
                        .onFailure { e ->
                                e.printStackTrace()
                                logger.error("Error in batch update of transaction analysis", e)
                        }
                        .getOrElse { 0 }
        }

        override suspend fun findProcessedTransactionsFromTransactionIds(userId: Int, transactionIds: List<String>): TransactionHistoryList {
                return runCatching {
                        val ids: Array<Long> = transactionIds.map(String::toLong).toTypedArray()
                        val details = databaseClient.sql(TransactionHistoryQueryStore.FIND_PROCESSED_TRANSACTIONS_BY_TRANSACTION_IDS)
                                .bind(0, userId)
                                .bind(1, ids)
                                .map { row ->
                                        toTransactionHistoryDetail(row as Row)
                                }
                                .all() // Flux<TransactionHistoryDetail>
                                .asFlow() // Flow<TransactionHistoryDetail>
                                .toList() // suspend → List<TransactionHistoryDetail>

                        TransactionHistoryList(LocalDate.now(), LocalDate.now()).apply {
                                details.forEach(::add) // same as details.forEach { add(it) }
                        }
                } .onFailure { e ->
                        e.printStackTrace()
                        logger.error(
                                "Error fetching processed transactions for userId=$userId"
                        )
                }
                        .getOrElse { TransactionHistoryList(LocalDate.now(), LocalDate.now()) }
        }

        private fun processTransactionIdsToString(transactionIds: List<String>): String {
                var str = ""
                transactionIds.forEach { transactionId ->
                        if (transactionId != transactionIds.last()) {
                                str += "$transactionId,"
                        } else {
                                str += transactionId
                        }
                }
                return "($str)"
        }

override suspend fun findTransactionsForUserSinceDate(
        userId: Int,
        sinceDate: LocalDate
): List<TransactionHistory> {
        return runCatching {
                databaseClient
                        .sql(TransactionHistoryQueryStore.FIND_TRANSACTIONS_FOR_USER_SINCE_DATE)
                        .bind(0, userId)
                        .bind(1, sinceDate)
                        .map { row -> mapRowToTransactionHistory(row as Row) }
                        .all()
                        .asFlow()
                        .toList()
        }
                .onFailure { e ->
                        e.printStackTrace()
                        logger.error(
                                "Error fetching transactions since $sinceDate for userId=$userId"
                        )
                }
                .getOrElse { emptyList() }
}

        private fun mapRowToTransactionHistory(row: Row): TransactionHistory {
                // Build nested Account object
                val account =
                        Account(
                                id = row.get("account_id", Long::class.java)!!,
                                accountNumber = row.get("account_number", String::class.java)!!,
                                balance = row.get("account_balance", Double::class.java)!!,
                                accountName = row.get("account_name", String::class.java)!!,
                                accountType =
                                        AccountType.valueOf(
                                                row.get("account_type", String::class.java)!!
                                        ),
                                lastUpdated =
                                        row.get(
                                                "account_last_updated",
                                                java.time.LocalDateTime::class.java
                                        )!!,
                                bank =
                                        Bank(
                                                id = row.get("bank_id", Int::class.java)!!,
                                                name = row.get("bank_name", String::class.java)!!,
                                                bankCode =
                                                        row.get("bank_code", String::class.java)!!
                                        ),
                                owner =
                                        User(
                                                id = row.get("user_id", Int::class.java)!!,
                                                name = row.get("user_name", String::class.java)!!,
                                                email = row.get("email", String::class.java)!!,
                                                phoneNumber =
                                                        row.get(
                                                                "phone_number",
                                                                String::class.java
                                                        )!!,
                                                dateOfBirth =
                                                        row.get(
                                                                "date_of_birth",
                                                                LocalDate::class.java
                                                        )!!,
                                                address = row.get("address", String::class.java)!!,
                                                identificationNumber =
                                                        row.get(
                                                                "identification_number",
                                                                String::class.java
                                                        )!!,
                                                settingJson =
                                                        row.get("setting_json", String::class.java)
                                                                ?: "{}"
                                        ),
                                finverseId = row.get("account_finverse_id", String::class.java)
                                                ?: ""
                        )

                // Build nested Card object (nullable)
            val card = row
                .get("card_id", java.lang.Long::class.java)    // boxed type
                ?.let { cardId ->
                    BriefCard(
                        id         = cardId.toLong(),
                        cardNumber = row.get("card_number", String::class.java)!!,
                        cardType   = CardType.valueOf(row.get("card_type", String::class.java)!!)
                    )
                }

                // Build TransactionHistory entity
                return TransactionHistory(
                        id = row.get("id", Long::class.java)!!,
                        transactionReference =
                                row.get("transaction_reference", String::class.java)!!,
                        account = account,
                        card = card,
                        transactionDate = row.get("transaction_date", LocalDate::class.java)!!,
                        transactionTime = row.get("transaction_time", LocalTime::class.java),
                        amount = row.get("amount", Double::class.java)!!,
                        transactionType = row.get("transaction_type", String::class.java)!!,
                        description = row.get("description", String::class.java) ?: "",
                        transactionStatus = row.get("transaction_status", String::class.java)!!,
                        friendlyDescription = row.get("friendly_description", String::class.java)
                                        ?: "",
                        transactionCategory = row.get("transaction_category", String::class.java)
                                        ?: "",
                        extractedCardNumber = row.get("extracted_card_number", String::class.java),
                        revisedTransactionDate =
                                row.get("revised_transaction_date", LocalDate::class.java),
                        isProcessed = row.get("is_processed", Boolean::class.java) ?: false,
                        finverseId = row.get("finverse_id", String::class.java)!!
                )
        }

        fun Row.hasColumn(name: String): Boolean =
                try {
                        this.metadata.getColumnMetadata(name) // throws if absent
                        true
                } catch (e: IllegalArgumentException) {
                        false
                }
}
