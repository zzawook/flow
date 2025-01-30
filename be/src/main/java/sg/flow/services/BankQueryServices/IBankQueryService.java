package sg.flow.services.BankQueryServices;

import java.time.LocalDate;

import sg.flow.entities.Bank;
import sg.flow.models.transaction.TransactionHistoryList;

public interface IBankQueryService {
    public TransactionHistoryList getTransactionHistoryBetween(int userId, String accountNumber, LocalDate startDate, LocalDate endDate);

    public boolean hasAccountNumber(String accountNumber);

    public Bank getBank();
}
