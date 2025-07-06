package sg.flow.repositories.bank

import kotlinx.coroutines.reactive.awaitFirstOrNull
import kotlinx.coroutines.reactive.awaitSingle
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.Bank
import sg.flow.repositories.utils.BankQueryStore

@Repository
class BankRepositoryImpl(private val databaseClient: DatabaseClient) : BankRepository {

    override suspend fun save(entity: Bank): Bank {
        val hasId = entity.id != null
        val queryString = if (hasId) BankQueryStore.SAVE_BANK_WITH_ID else BankQueryStore.SAVE_BANK

        if (hasId) {
            databaseClient
                    .sql(queryString)
                    .bind(0, entity.id!!)
                    .bind(1, entity.name)
                    .bind(2, entity.bankCode)
                    .bind(3, entity.finverseId ?: "")
                    .fetch()
                    .awaitRowsUpdated()
        } else {
            databaseClient
                    .sql(queryString)
                    .bind(0, entity.name)
                    .bind(1, entity.bankCode)
                    .bind(2, entity.finverseId ?: "")
                    .fetch()
                    .awaitRowsUpdated()
        }

        return entity
    }

    override suspend fun findById(id: Long): Bank? {
        return databaseClient
                .sql(BankQueryStore.FIND_BANK_BY_ID)
                .bind(0, id)
                .map { row ->
                    Bank(
                            id = row.get("id", Int::class.java)!!,
                            name = row.get("bank_name", String::class.java)!!,
                            bankCode = row.get("bank_code", String::class.java)!!
                    )
                }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun findByFinverseId(finverseId: String): Bank? {
        return databaseClient
                .sql(BankQueryStore.FIND_BANK_BY_FINVERSE_ID)
                .bind(0, finverseId)
                .map { row ->
                    println(row.get("bank_name", String::class.java))
                    Bank(
                        id = row.get("id", Int::class.java)!!,
                        name = row.get("bank_name", String::class.java)!!,
                        bankCode = row.get("bank_code", String::class.java)!!
                    )
                }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql(BankQueryStore.DELETE_ALL_BANKS).fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
