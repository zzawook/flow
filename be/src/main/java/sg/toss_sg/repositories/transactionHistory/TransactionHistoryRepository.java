package sg.toss_sg.repositories.transactionHistory;

import java.time.LocalDateTime;

import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;
import sg.toss_sg.repositories.Repository;

public interface TransactionHistoryRepository extends Repository<TransactionHistory, Long> {

    MonthlyHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();
}
