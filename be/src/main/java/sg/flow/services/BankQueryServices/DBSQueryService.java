package sg.flow.services.BankQueryServices;

import java.time.LocalDate;

import org.springframework.stereotype.Component;

import sg.flow.entities.Bank;
import sg.flow.models.transaction.TransactionHistoryList;

@Component
public class DBSQueryService implements IBankQueryService{

    public TransactionHistoryList getTransactionHistoryBetween(int userId, String accountNumber, LocalDate startDate, LocalDate endDate) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionHistory'");
    }

    @Override
    public boolean hasAccountNumber(String accountNumber) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'hasAccountNumber'");
    }

    @Override
    public Bank getBank() {
        return Bank.builder()
                .name("DBS")
                .bankCode("DBS001")
                .build();
    }
}
