package sg.flow.services.BankQueryServices;

import java.time.LocalDate;
import org.springframework.stereotype.Service;

import sg.flow.models.transaction.history.TransactionHistoryList;

@Service
public class UOBQueryService implements BankQueryService {

    @Override
    public TransactionHistoryList getTransactionHistoryBetween(int userId, LocalDate startDate, LocalDate endDate) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionHistory'");
    }

}
