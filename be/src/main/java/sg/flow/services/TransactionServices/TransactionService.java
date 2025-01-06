package sg.flow.services.TransactionServices;

import jakarta.websocket.SendResult;
import sg.flow.models.transaction.history.DailyTransactionHistoryList;
import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.models.transaction.send.SendRecepient;
import sg.flow.models.transaction.send.SendRequestBody;

public interface TransactionService {

    MonthlyTransactionHistoryList getMonthlyTransaction(int year, int month);

    DailyTransactionHistoryList getDailyTransaction(int year, int month, int day);

    TransactionHistoryDetail getTransactionDetails(String bank_code, String transaction_id);

    SendRecepient getRelevantRecepient(String keyword);

    SendResult sendTransaction(String recepientId, Double amount);

    SendResult sendTransaction(SendRequestBody sendRequestBody);

    MonthlyTransactionHistoryList getLast30DaysHistoryList();

    MonthlyTransactionHistoryList getTransactionWithinRange(int startYear, int startMonth, int startDay, int endYear,
            int endMonth,
            int endDay);

}
