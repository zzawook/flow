package sg.flow.repositories.bank

import sg.flow.entities.Bank
import sg.flow.repositories.Repository

interface BankRepository : Repository<Bank, Long> {
    suspend fun findByFinverseId(finverseId: String): Bank?
    suspend fun findAllBanksInCountry(country: String): List<Bank>
    suspend fun findFinverseIdWithId(institutionId: Long): String
}
