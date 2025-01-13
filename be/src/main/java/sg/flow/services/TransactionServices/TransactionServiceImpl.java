package sg.flow.services.TransactionServices;

import java.time.LocalDate;

import org.springframework.stereotype.Service;

import jakarta.websocket.SendResult;
import lombok.RequiredArgsConstructor;
import sg.flow.models.transaction.history.TransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.models.transaction.send.SendRecepient;
import sg.flow.models.transaction.send.SendRequestBody;
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository;
import sg.flow.services.BankQueryServices.BankQueryService;
import sg.flow.services.BankQueryServices.DBSQueryService;

@Service
@RequiredArgsConstructor
public class TransactionServiceImpl implements TransactionService {

    private final TransactionHistoryRepository transactionHistoryRepository;
    private final DBSQueryService bankQueryService;

    @Override
    public TransactionHistoryList getLast30DaysHistoryList(int userId) {
        return transactionHistoryRepository.findTransactionBetweenDates(userId, LocalDate.now().minusDays(30),
                LocalDate.now());
    }

    @Override
    public TransactionHistoryList getMonthlyTransaction(int userId, int year, int month) {
        LocalDate currentMonthFirstDay = LocalDate.of(year, month, 1);
        LocalDate currentMonthLastDay = LocalDate.of(year, month, currentMonthFirstDay.lengthOfMonth());

        TransactionHistoryList monthlyHistoryList = transactionHistoryRepository.findTransactionBetweenDates(userId,
                currentMonthFirstDay, currentMonthLastDay);

        return monthlyHistoryList;
    }

    @Override
    public TransactionHistoryList getDailyTransaction(int userId, LocalDate date) {
        TransactionHistoryList dailyHistoryList = transactionHistoryRepository.findTransactionBetweenDates(userId, date,
                date);
        // if (date.isBefore(currentDate)) {
        // return dailyHistoryList;
        // }

        // LocalDateTime lastUpdated =
        // transactionHistoryRepository.getLastUpdatedDate();
        // TransactionHistoryList additionalHistoryList =
        // bankQueryService.getTransactionHistory(userId, );
        // dailyHistoryList.add(additionalHistoryList);
        return dailyHistoryList;
    }

    @Override
    public TransactionHistoryDetail getTransactionDetails(int userId, String transaction_id) {
        return transactionHistoryRepository.findTransactionDetailById(Long.parseLong(transaction_id));
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
    public TransactionHistoryList getTransactionWithinRange(int userId, LocalDate startDate, LocalDate endDate) {
        return transactionHistoryRepository.findTransactionBetweenDates(userId, startDate, endDate);
    }

}
