package sg.toss_sg.repositories;

import java.time.LocalDateTime;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;

import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

@Repository
@Component
public interface TransactionHistoryRepository extends JpaRepository<TransactionHistory, Long> {

    MonthlyHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();

}
