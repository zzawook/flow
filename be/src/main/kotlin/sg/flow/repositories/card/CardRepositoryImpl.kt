package sg.flow.repositories.card

import CardNotJoined
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.slf4j.LoggerFactory
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

        private val logger = LoggerFactory.getLogger(CardRepositoryImpl::class.java)

    override suspend fun save(entity: Card): Card {
        val hasId = entity.id != null
        val sql = if (hasId) CardQueryStore.SAVE_CARD_WITH_ID else CardQueryStore.SAVE_CARD

        // build the bind spec, shifting by one if we include an explicit ID
        var spec = databaseClient.sql(sql)
        var idx = 0
        if (hasId) {
            spec = spec.bind(idx++, entity.id)
        }

        spec =
                spec.bind(idx++, entity.owner?.id!!)
                        .bind(idx++, entity.issuingBank?.id!!)
                        .bind(idx++, entity.cardNumber)
                        .bind(idx++, entity.cardType.name)

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
                                                cardNumber =
                                                        row.get("card_number", String::class.java)
                                                                ?: "",
                                                cardType = row.get("card_type", String::class.java)
                                                                ?: "UNKNOWN",
                                        )
                                    }
                                    .one()
                                    .awaitSingleOrNull()
                                    ?: return null

                    var bank = bankRepository.findById(tuple.bankId)
                    var user = userRepository.findById(tuple.userId)

                    Card(
                            id = tuple.cardId,
                            issuingBank = bank,
                            owner = user,
                            cardNumber = tuple.cardNumber,
                            cardType = CardType.valueOf(tuple.cardType.uppercase()),
                    )
                }
                .onFailure { e ->
                    e.printStackTrace()
                    logger.error("Error fetching card id=$id", e)
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
