package sg.flow.repositories.transactionHistory;

import java.time.LocalDateTime;
import java.util.List;

import sg.flow.entities.TransactionHistory;
import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.repositories.Repository;

public interface TransactionHistoryRepository extends Repository<TransactionHistory, Long> {

    MonthlyTransactionHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();

    List<TransactionHistoryDetail> findRecentTransactionHistoryDetailOfAccount(Long id);
}
