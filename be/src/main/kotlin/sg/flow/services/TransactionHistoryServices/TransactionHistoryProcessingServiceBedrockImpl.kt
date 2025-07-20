package sg.flow.services.TransactionHistoryServices

import org.springframework.stereotype.Service
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@Service
class TransactionHistoryProcessingServiceBedrockImpl(
    transactionHistoryRepository: TransactionHistoryRepository
) : TransactionHistoryProcessingService{
    override suspend fun processTransaction(transactionHistoryReference: String) {
        TODO("Not yet implemented")
    }

}