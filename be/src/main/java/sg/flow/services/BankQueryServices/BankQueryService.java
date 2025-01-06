package sg.flow.services.BankQueryServices;

import java.time.LocalDateTime;

import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;

public interface BankQueryService {

    public MonthlyTransactionHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated);

}
