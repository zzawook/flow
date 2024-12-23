package sg.toss_sg.services.TransactionServices;

import java.time.LocalDate;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import jakarta.websocket.SendResult;
import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.transaction.history.DailyHistoryList;
import sg.toss_sg.models.transaction.history.HistoryDetail;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;
import sg.toss_sg.models.transaction.send.SendRecepient;
import sg.toss_sg.models.transaction.send.SendRequestBody;
import sg.toss_sg.repositories.TransactionHistoryRepository;
import sg.toss_sg.services.BankQueryServices.BankQueryService;


@Service
@RequiredArgsConstructor
public class TransactionServiceImpl implements TransactionService{

    @Autowired
    private final TransactionHistoryRepository historyRepository;

    @Autowired
    private final BankQueryService bankQueryService;

    @Override
    public MonthlyHistoryList getLast30DaysHistoryList() {
        return this.getMonthlyTransaction(LocalDate.now().getYear(), LocalDate.now().getMonthValue());
    }

    @Override
    public MonthlyHistoryList getMonthlyTransaction(int year, int month) {
        LocalDate currentMonth = LocalDate.now().withMonth(month);
        MonthlyHistoryList monthlyHistoryList = historyRepository.getMonthlyTransaction(year, month);
        if (currentMonth.isBefore(LocalDate.now())) {
            return monthlyHistoryList;
        }

        LocalDateTime lastUpdated = historyRepository.getLastUpdatedDate();
        MonthlyHistoryList additionalHistoryList = bankQueryService.getTransactionHistory(year, month, lastUpdated);
        monthlyHistoryList.add(additionalHistoryList);
        return monthlyHistoryList;
    }

    @Override
    public DailyHistoryList getDailyTransaction(int year, int month, int day) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getDailyTransaction'");
    }

    @Override
    public HistoryDetail getTransactionDetails(String bank_code, String transaction_id) {
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
    public MonthlyHistoryList getTransactionWithinRange(int startYear, int startMonth, int startDay, int endYear,
            int endMonth, int endDay) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getTransactionWithinRange'");
    }

    
    
}
