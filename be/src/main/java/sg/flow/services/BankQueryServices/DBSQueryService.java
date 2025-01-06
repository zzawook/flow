package sg.flow.services.BankQueryServices;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;

@Service
public class DBSQueryService implements BankQueryService {

    @Override
    public MonthlyTransactionHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionHistory'");
    }
}
