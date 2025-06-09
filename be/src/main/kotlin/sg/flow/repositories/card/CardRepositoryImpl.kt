package sg.flow.repositories.card

import CardNotJoined
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.Card
import sg.flow.entities.utils.CardType
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.bank.BankRepository
import sg.flow.repositories.user.UserRepository
import sg.flow.repositories.utils.CardQueryStore

@Repository
class CardRepositoryImpl(
        private val databaseClient: DatabaseClient,
        private val bankRepository: BankRepository,
        private val userRepository: UserRepository,
        private val accountRepository: AccountRepository
) : CardRepository {

    override suspend fun save(entity: Card): Card {
        val hasId = entity.id != null
        val sql = if (hasId) CardQueryStore.SAVE_CARD_WITH_ID else CardQueryStore.SAVE_CARD

        // build the bind spec, shifting by one if we include an explicit ID
        var spec = databaseClient.sql(sql)
        var idx = 0
        if (hasId) {
            spec = spec.bind(idx++, entity.id!!)
        }

        spec =
                spec.bind(idx++, entity.owner?.id!!)
                        .bind(idx++, entity.linkedAccount?.id!!)
                        .bind(idx++, entity.issuingBank?.id!!)
                        .bind(idx++, entity.cardNumber)
                        .bind(idx++, entity.cardType.name)
                        .bind(idx++, entity.cvv)
                        .bind(idx++, entity.expiryDate) // LocalDate → DATE
                        .bind(idx++, entity.cardHolderName)
                        .bind(idx++, entity.pin)
                        .bind(idx++, entity.cardStatus)
                        .bind(idx++, entity.addressLine1)
                        .bind(idx++, entity.addressLine2)
                        .bind(idx++, entity.city)
                        .bind(idx++, entity.state)
                        .bind(idx++, entity.country)
                        .bind(idx++, entity.zipCode)
                        .bind(idx++, entity.phone)
                        .bind(idx++, entity.dailyLimit)
                        .bind(idx++, entity.monthlyLimit)

        // execute the insert/update
        spec.fetch().awaitRowsUpdated()

        return entity
    }

    override suspend fun findById(id: Long): Card? {
        return runCatching {
                    val tuple =
                            databaseClient
                                    .sql(CardQueryStore.FIND_CARD_BY_ID)
                                    .bind(0, id)
                                    .map { row ->
                                        CardNotJoined(
                                                cardId = row.get("id", Long::class.java) ?: 0L,
                                                bankId = row.get("bank_id", Long::class.java) ?: 0L,
                                                userId = row.get("user_id", Long::class.java) ?: 0L,
                                                accountId = row.get("account_id", Long::class.java),
                                                cardNumber =
                                                        row.get("card_number", String::class.java)
                                                                ?: "",
                                                cardType = row.get("card_type", String::class.java)
                                                                ?: "UNKNOWN",
                                                cvv = row.get("cvv", String::class.java) ?: "",
                                                expiryDate =
                                                        row.get(
                                                                "expiry_date",
                                                                java.time.LocalDate::class.java
                                                        )
                                                                ?: java.time.LocalDate.now(),
                                                holderName =
                                                        row.get(
                                                                "card_holder_name",
                                                                String::class.java
                                                        )
                                                                ?: "",
                                                pin = row.get("pin", String::class.java) ?: "",
                                                status = row.get("card_status", String::class.java)
                                                                ?: "",
                                                addr1 =
                                                        row.get(
                                                                "address_line_1",
                                                                String::class.java
                                                        )
                                                                ?: "",
                                                addr2 =
                                                        row.get(
                                                                "address_line_2",
                                                                String::class.java
                                                        )
                                                                ?: "",
                                                city = row.get("city", String::class.java) ?: "",
                                                state = row.get("state", String::class.java) ?: "",
                                                country = row.get("country", String::class.java)
                                                                ?: "",
                                                zip = row.get("zip_code", String::class.java) ?: "",
                                                phone = row.get("phone", String::class.java) ?: "",
                                                daily = row.get("daily_limit", Double::class.java)
                                                                ?: 0.0,
                                                monthly =
                                                        row.get("monthly_limit", Double::class.java)
                                                                ?: 0.0
                                        )
                                    }
                                    .one()
                                    .awaitSingleOrNull()
                                    ?: return null

                    var bank = bankRepository.findById(tuple.bankId)
                    var user = userRepository.findById(tuple.userId)
                    var account =
                            if (tuple.accountId != null) accountRepository.findById(tuple.accountId)
                            else null

                    Card(
                            id = tuple.cardId,
                            issuingBank = bank,
                            owner = user,
                            linkedAccount = account,
                            cardNumber = tuple.cardNumber,
                            cardType = CardType.valueOf(tuple.cardType.uppercase()),
                            cvv = tuple.cvv,
                            expiryDate = tuple.expiryDate,
                            cardHolderName = tuple.holderName,
                            pin = tuple.pin,
                            cardStatus = tuple.status,
                            addressLine1 = tuple.addr1,
                            addressLine2 = tuple.addr2,
                            city = tuple.city,
                            state = tuple.state,
                            country = tuple.country,
                            zipCode = tuple.zip,
                            phone = tuple.phone,
                            dailyLimit = tuple.daily,
                            monthlyLimit = tuple.monthly
                    )
                }
                .onFailure { e ->
                    e.printStackTrace()
                    println("Error fetching card id=$id")
                }
                .getOrNull()
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql("DELETE FROM cards").fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
