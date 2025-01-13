package sg.flow.services.BankQueryServices;

import java.time.LocalDate;

import sg.flow.models.transaction.history.TransactionHistoryList;

public interface BankQueryService {

    public TransactionHistoryList getTransactionHistoryBetween(int userId, LocalDate startDate, LocalDate endDate);

}
