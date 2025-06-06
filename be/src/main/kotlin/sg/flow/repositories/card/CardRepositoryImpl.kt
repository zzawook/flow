package sg.flow.repositories.card

import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.Card

@Repository
class CardRepositoryImpl(private val databaseClient: DatabaseClient) : CardRepository {

    override suspend fun save(entity: Card): Card {
        // Simplified implementation for now - just return the entity
        // Real implementation would insert into database
        return entity
    }

    override suspend fun findById(id: Long): Card? {
        // Simplified implementation for now - return null
        // Real implementation would query database
        return null
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
