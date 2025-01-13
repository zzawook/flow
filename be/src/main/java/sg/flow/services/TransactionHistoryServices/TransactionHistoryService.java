package sg.flow.services.TransactionHistoryServices;

import java.time.LocalDate;

import jakarta.websocket.SendResult;
import sg.flow.models.transaction.TransactionHistoryDetail;
import sg.flow.models.transaction.TransactionHistoryList;
import sg.flow.models.transfer.TransferRecepient;
import sg.flow.models.transfer.TransferRequestBody;

public interface TransactionHistoryService {

    TransactionHistoryList getMonthlyTransaction(int userId, int year, int month);

    TransactionHistoryList getDailyTransaction(int userId, LocalDate date);

    TransactionHistoryDetail getTransactionDetails(int userId, String transaction_id);

    TransferRecepient getRelevantRecepient(String keyword);

    SendResult sendTransaction(String recepientId, Double amount);

    SendResult sendTransaction(TransferRequestBody sendRequestBody);

    TransactionHistoryList getLast30DaysHistoryList(int userId);

    TransactionHistoryList getTransactionWithinRange(int userId, LocalDate startDate, LocalDate endDate);

}
