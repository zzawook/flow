package sg.toss_sg.services.TransactionServices;

import jakarta.websocket.SendResult;
import sg.toss_sg.models.transaction.history.DailyTransactionHistoryList;
import sg.toss_sg.models.transaction.history.MonthlyTransactionHistoryList;
import sg.toss_sg.models.transaction.history.TransactionHistoryDetail;
import sg.toss_sg.models.transaction.send.SendRecepient;
import sg.toss_sg.models.transaction.send.SendRequestBody;

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
