package sg.flow.services.TransactionHistoryServices

import jakarta.websocket.SendResult
import java.time.LocalDate
import org.springframework.stereotype.Service
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody

@Service
class TransactionHistoryServiceImpl : TransactionHistoryService {

    override suspend fun getMonthlyTransaction(
            userId: Int,
            year: Int,
            month: Int
    ): TransactionHistoryList {
        // TODO: Implement getMonthlyTransaction
        val startDate = LocalDate.of(year, month, 1)
        val endDate = startDate.withDayOfMonth(startDate.lengthOfMonth())
        return TransactionHistoryList(startDate = startDate, endDate = endDate)
    }

    override suspend fun getDailyTransaction(userId: Int, date: LocalDate): TransactionHistoryList {
        // TODO: Implement getDailyTransaction
        return TransactionHistoryList(startDate = date, endDate = date)
    }

    override suspend fun getTransactionDetails(
            userId: Int,
            transactionId: String
    ): TransactionHistoryDetail {
        // TODO: Implement getTransactionDetails
        throw NotImplementedError("getTransactionDetails not implemented")
    }

    override suspend fun getRelevantRecepient(keyword: String): TransferRecepient {
        // TODO: Implement getRelevantRecepient
        throw NotImplementedError("getRelevantRecepient not implemented")
    }

    override suspend fun sendTransaction(recepientId: String, amount: Double): SendResult {
        // TODO: Implement sendTransaction
        throw NotImplementedError("sendTransaction not implemented")
    }

    override suspend fun sendTransaction(sendRequestBody: TransferRequestBody): SendResult {
        // TODO: Implement sendTransaction
        throw NotImplementedError("sendTransaction not implemented")
    }

    override suspend fun getLast30DaysHistoryList(userId: Int): TransactionHistoryList {
        // TODO: Implement getLast30DaysHistoryList
        val endDate = LocalDate.now()
        val startDate = endDate.minusDays(30)
        return TransactionHistoryList(startDate = startDate, endDate = endDate)
    }

    override suspend fun getTransactionWithinRange(
            userId: Int,
            startDate: LocalDate,
            endDate: LocalDate
    ): TransactionHistoryList {
        // TODO: Implement getTransactionWithinRange
        return TransactionHistoryList(startDate = startDate, endDate = endDate)
    }
}
