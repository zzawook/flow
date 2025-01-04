package sg.toss_sg.services.BankQueryServices;

import java.time.LocalDateTime;

import sg.toss_sg.models.transaction.history.MonthlyTransactionHistoryList;

public interface BankQueryService {

    public MonthlyTransactionHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated);

}
