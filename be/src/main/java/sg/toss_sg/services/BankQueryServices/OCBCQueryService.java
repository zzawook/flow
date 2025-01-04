package sg.toss_sg.services.BankQueryServices;

import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import sg.toss_sg.models.transaction.history.MonthlyTransactionHistoryList;

@Service
public class OCBCQueryService implements BankQueryService {

    @Override
    public MonthlyTransactionHistoryList getTransactionHistory(int year, int month, LocalDateTime lastUpdated) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionHistory'");
    }

}
