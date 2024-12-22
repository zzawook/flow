package sg.toss_sg.services;

import java.time.LocalDateTime;

import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

public interface BankQueryService {

    public MonthlyHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated);
    
}
