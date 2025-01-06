package sg.flow.services.TransactionServices;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.stereotype.Service;

import jakarta.websocket.SendResult;
import lombok.RequiredArgsConstructor;
import sg.flow.models.transaction.history.DailyTransactionHistoryList;
import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.models.transaction.send.SendRecepient;
import sg.flow.models.transaction.send.SendRequestBody;
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository;
import sg.flow.services.BankQueryServices.DBSQueryService;

@Service
@RequiredArgsConstructor
public class TransactionServiceImpl implements TransactionService {

    private final TransactionHistoryRepository transactionHistoryRepository;
    private final DBSQueryService bankQueryService;

    @Override
    public MonthlyTransactionHistoryList getLast30DaysHistoryList() {
        return this.getMonthlyTransaction(LocalDate.now().getYear(), LocalDate.now().getMonthValue());
    }

    @Override
    public MonthlyTransactionHistoryList getMonthlyTransaction(int year, int month) {
        LocalDate currentMonth = LocalDate.now().withMonth(month);
        MonthlyTransactionHistoryList monthlyHistoryList = transactionHistoryRepository.getMonthlyTransaction(year,
                month);
        if (currentMonth.isBefore(LocalDate.now())) {
            return monthlyHistoryList;
        }

        LocalDateTime lastUpdated = transactionHistoryRepository.getLastUpdatedDate();
        MonthlyTransactionHistoryList additionalHistoryList = bankQueryService.getTransactionHistory(year, month,
                lastUpdated);
        monthlyHistoryList.add(additionalHistoryList);
        return monthlyHistoryList;
    }

    @Override
    public DailyTransactionHistoryList getDailyTransaction(int year, int month, int day) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getDailyTransaction'");
    }

    @Override
    public TransactionHistoryDetail getTransactionDetails(String bank_code, String transaction_id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionDetails'");
    }

    @Override
    public SendRecepient getRelevantRecepient(String keyword) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getRelevantRecepient'");
    }

    @Override
    public SendResult sendTransaction(String recepientId, Double amount) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'sendTransaction'");
    }

    @Override
    public SendResult sendTransaction(SendRequestBody sendRequestBody) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'sendTransaction'");
    }

    @Override
    public MonthlyTransactionHistoryList getTransactionWithinRange(int startYear, int startMonth, int startDay,
            int endYear,
            int endMonth, int endDay) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionWithinRange'");
    }

}
