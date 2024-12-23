package sg.toss_sg.services.BankQueryServices;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

@Service
public class DBSQueryService implements BankQueryService{

    @Override
    public MonthlyHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionHistory'");
    }
}
