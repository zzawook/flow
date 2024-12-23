package sg.toss_sg.repositories;

import java.time.LocalDateTime;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;

import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

@Repository
public interface TransactionHistoryRepository extends JpaRepository<MonthlyHistoryList, Long> {

    MonthlyHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();
    
}
