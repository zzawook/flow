package sg.flow.repositories.card

import java.sql.SQLException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Repository
import sg.flow.configs.DatabaseConnectionPool
import sg.flow.entities.Card

@Repository
class CardRepositoryImpl(private val databaseConnectionPool: DatabaseConnectionPool) :
        CardRepository {

    override suspend fun save(entity: Card): Card =
            withContext(Dispatchers.IO) {
                // Simplified implementation for now - just return the entity
                // Real implementation would insert into database
                entity
            }

    override suspend fun findById(id: Long): Card? =
            withContext(Dispatchers.IO) {
                // Simplified implementation for now - return null
                // Real implementation would query database
                null
            }

    override suspend fun deleteAll(): Boolean =
            withContext(Dispatchers.IO) {
                val connection = databaseConnectionPool.getConnection() ?: return@withContext false

                try {
                    connection.use { conn ->
                        conn.prepareStatement("DELETE FROM cards").use { pstm ->
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
