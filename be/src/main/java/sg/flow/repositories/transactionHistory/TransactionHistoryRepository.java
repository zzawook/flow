package sg.flow.repositories.transactionHistory;

import java.time.LocalDate;
import java.util.List;

import sg.flow.entities.TransactionHistory;
import sg.flow.models.transaction.TransactionHistoryDetail;
import sg.flow.models.transaction.TransactionHistoryList;
import sg.flow.repositories.Repository;

public interface TransactionHistoryRepository extends Repository<TransactionHistory, Long> {

    List<TransactionHistoryDetail> findRecentTransactionHistoryDetailOfAccount(Long accountId);

    TransactionHistoryList findTransactionBetweenDates(int userId, LocalDate startDate, LocalDate endDate);

    TransactionHistoryList findTransactionBetweenDates(int userId, LocalDate startDate, LocalDate endDate, int limit);

    TransactionHistoryDetail findTransactionDetailById(long long1);
}
