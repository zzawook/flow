package sg.toss_sg.services;

import jakarta.websocket.SendResult;
import sg.toss_sg.models.transaction.history.DailyHistoryList;
import sg.toss_sg.models.transaction.history.HistoryDetail;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;
import sg.toss_sg.models.transaction.send.SendRecepient;
import sg.toss_sg.models.transaction.send.SendRequestBody;

public interface TransactionService {

    MonthlyHistoryList getMonthlyTransaction(int year, int month);

    DailyHistoryList getDailyTransaction(int year, int month, int day);

    HistoryDetail getTransactionDetails(String bank_code, String transaction_id);

    SendRecepient getRelevantRecepient(String keyword);

    SendResult sendTransaction(String recepientId, Double amount);

    SendResult sendTransaction(SendRequestBody sendRequestBody);

    MonthlyHistoryList getLast30DaysHistoryList();

    MonthlyHistoryList getTransactionWithinRange(int startYear, int startMonth, int startDay, int endYear, int endMonth,
            int endDay);
    
}
