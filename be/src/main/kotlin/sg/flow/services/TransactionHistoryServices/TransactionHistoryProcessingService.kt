package sg.flow.services.TransactionHistoryServices

interface TransactionHistoryProcessingService {
    suspend fun processTransaction(transactionHistoryReference: String)
}