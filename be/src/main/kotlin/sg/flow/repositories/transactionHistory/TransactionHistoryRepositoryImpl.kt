package sg.flow.repositories.transactionHistory

import java.time.LocalDate
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.utils.TransactionHistoryQueryStore

@Repository
class TransactionHistoryRepositoryImpl(private val databaseClient: DatabaseClient) :
        TransactionHistoryRepository {

    override suspend fun save(entity: TransactionHistory): TransactionHistory {
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC save operation using databaseClient
        return entity
    }

    override suspend fun findById(id: Long): TransactionHistory? {
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC findById operation using databaseClient
        return null
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
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC query using databaseClient
        return emptyList()
    }

        override suspend fun findTransactionBetweenDates(
        userId: Int,
        startDate: LocalDate,
        endDate: LocalDate
    ): TransactionHistoryList {
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC query using databaseClient
        return TransactionHistoryList(startDate, endDate, mutableListOf())
    }

    override suspend fun findTransactionBetweenDates(
        userId: Int,
        startDate: LocalDate,
        endDate: LocalDate,
        limit: Int
    ): TransactionHistoryList {
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC query using databaseClient
        return TransactionHistoryList(startDate, endDate, mutableListOf())
    }

    override suspend fun findTransactionDetailById(id: Long): TransactionHistoryDetail? {
        // R2DBC implementation - simplified stub for now
        // TODO: Implement full R2DBC query using databaseClient
        return null
    }
}
