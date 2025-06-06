package sg.flow.repositories.bank

import java.sql.SQLException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Repository
import sg.flow.configs.DatabaseConnectionPool
import sg.flow.entities.Bank
import sg.flow.repositories.utils.BankQueryStore

@Repository
class BankRepositoryImpl(private val databaseConnectionPool: DatabaseConnectionPool) :
        BankRepository {

    override suspend fun save(entity: Bank): Bank =
            withContext(Dispatchers.IO) {
                val connection =
                        databaseConnectionPool.getConnection()
                                ?: throw RuntimeException("Failed to get connection")
                val hasId = entity.id != null
                val queryString =
                        if (hasId) BankQueryStore.SAVE_BANK_WITH_ID else BankQueryStore.SAVE_BANK
                val parameterStart = if (hasId) 1 else 0

                try {
                    connection.use { conn ->
                        conn.prepareStatement(queryString).use { pstm ->
                            if (hasId) {
                                pstm.setInt(parameterStart, entity.id!!)
                            }
                            pstm.setString(parameterStart + 1, entity.name)
                            pstm.setString(parameterStart + 2, entity.bankCode)

                            pstm.executeUpdate()
                            entity
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    throw RuntimeException("Failed to save bank", e)
                }
            }

    override suspend fun findById(id: Long): Bank? =
            withContext(Dispatchers.IO) {
                val connection = databaseConnectionPool.getConnection() ?: return@withContext null

                try {
                    connection.use { conn ->
                        conn.prepareStatement(BankQueryStore.FIND_BANK_BY_ID).use { pstm ->
                            pstm.setLong(1, id)
                            val resultSet = pstm.executeQuery()

                            if (resultSet.next()) {
                                Bank(
                                        id = resultSet.getInt("id"),
                                        name = resultSet.getString("bank_name"),
                                        bankCode = resultSet.getString("bank_code")
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
                val connection = databaseConnectionPool.getConnection() ?: return@withContext false

                try {
                    connection.use { conn ->
                        conn.prepareStatement(BankQueryStore.DELETE_ALL_BANKS).use { pstm ->
                            pstm.executeUpdate()
                            true
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    false
                }
            }
}
