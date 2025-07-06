package sg.flow.repositories.bank

import sg.flow.entities.Bank
import sg.flow.repositories.Repository

interface BankRepository : Repository<Bank, Long> {
    suspend fun findByFinverseId(finverseId: String): Bank?
}
