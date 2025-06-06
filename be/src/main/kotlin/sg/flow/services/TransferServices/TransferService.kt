package sg.flow.services.TransferServices

import sg.flow.entities.Bank
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult

interface TransferService {
    suspend fun sendTransaction(sendRequestBody: TransferRequestBody): TransferResult
    suspend fun getRelevantRecepient(): List<TransferRecepient>
    suspend fun getRelevantRecepientByAccountNumber(accountNumber: String): List<Bank>
    suspend fun getRelevantRecepientByContact(contact: String): TransferRecepient
}
