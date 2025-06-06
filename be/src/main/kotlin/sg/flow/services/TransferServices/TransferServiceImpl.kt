package sg.flow.services.TransferServices

import org.springframework.stereotype.Service
import sg.flow.entities.Bank
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult
import sg.flow.services.BankQueryServices.BankQueryService
import sg.flow.services.BankQueryServices.PayNowQueryService

@Service
class TransferServiceImpl(
        private val payNowQueryService: PayNowQueryService,
        private val bankQueryService: BankQueryService,
) : TransferService {

    override suspend fun sendTransaction(sendRequestBody: TransferRequestBody): TransferResult =
            payNowQueryService.sendTransaction(sendRequestBody)

    override suspend fun getRelevantRecepient(): List<TransferRecepient> {
        val recentTransactionTargets = getRecentTransactionTargets()
        // TODO: More logics here
        return recentTransactionTargets
    }

    private suspend fun getRecentTransactionTargets(): List<TransferRecepient> {
        // TODO: Implement getRecentTransactionTargets
        return emptyList()
    }

    override suspend fun getRelevantRecepientByAccountNumber(accountNumber: String): List<Bank> =
            bankQueryService.getBanksWithAccountNumber(accountNumber)

    override suspend fun getRelevantRecepientByContact(contact: String): TransferRecepient =
            payNowQueryService.getRecepientByContact(contact)

    private fun validateTransaction(sendRequestBody: TransferRequestBody): Boolean {
        // TODO: Implement validateTransaction
        return true
    }
}
