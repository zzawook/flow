package sg.flow.services.TransactionServices;

import java.time.LocalDate;

import jakarta.websocket.SendResult;
import sg.flow.models.transaction.history.TransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.models.transaction.send.SendRecepient;
import sg.flow.models.transaction.send.SendRequestBody;

public interface TransactionService {

    TransactionHistoryList getMonthlyTransaction(int userId, int year, int month);

    TransactionHistoryList getDailyTransaction(int userId, LocalDate date);

    TransactionHistoryDetail getTransactionDetails(int userId, String transaction_id);

    SendRecepient getRelevantRecepient(String keyword);

    SendResult sendTransaction(String recepientId, Double amount);

    SendResult sendTransaction(SendRequestBody sendRequestBody);

    TransactionHistoryList getLast30DaysHistoryList(int userId);

    TransactionHistoryList getTransactionWithinRange(int userId, LocalDate startDate, LocalDate endDate);

}
