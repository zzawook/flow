package sg.toss_sg.repositories.transactionHistory;

import java.time.LocalDateTime;
import java.util.List;

import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.models.transaction.history.MonthlyTransactionHistoryList;
import sg.toss_sg.models.transaction.history.TransactionHistoryDetail;
import sg.toss_sg.repositories.Repository;

public interface TransactionHistoryRepository extends Repository<TransactionHistory, Long> {

    MonthlyTransactionHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();

    List<TransactionHistoryDetail> findRecentTransactionHistoryDetailOfAccount(Long id);
}
