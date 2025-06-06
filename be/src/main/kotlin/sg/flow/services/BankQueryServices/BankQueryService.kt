package sg.flow.services.BankQueryServices

import java.time.LocalDate
import org.springframework.stereotype.Service
import sg.flow.entities.Bank
import sg.flow.models.transaction.TransactionHistoryList

@Service
class BankQueryService(
        private val dbsQueryService: DBSQueryService,
        private val ocbcQueryService: OCBCQueryService,
        private val uobQueryService: UOBQueryService
) {

    private val bankQueryServices: List<IBankQueryService> =
            listOf(dbsQueryService, ocbcQueryService, uobQueryService)

    suspend fun getTransactionHistoryBetween(
            userId: Int,
            bank: Bank,
            accountNumber: String,
            startDate: LocalDate,
            endDate: LocalDate
    ): TransactionHistoryList {
        val bankQueryService = getBankQueryService(bank)
        return bankQueryService.getTransactionHistoryBetween(
                userId,
                accountNumber,
                startDate,
                endDate
        )
    }

    private fun getBankQueryService(bank: Bank): IBankQueryService {
        return when (bank.name.uppercase()) {
            "DBS" -> dbsQueryService
            "OCBC" -> ocbcQueryService
            "UOB" -> uobQueryService
            else -> throw UnsupportedOperationException("Unimplemented bank")
        }
    }

    suspend fun getBanksWithAccountNumber(accountNumber: String): List<Bank> {
        val banks = mutableListOf<Bank>()
        for (service in bankQueryServices) {
            if (service.hasAccountNumber(accountNumber)) {
                banks.add(service.getBank())
            }
        }
        return banks
    }
}
