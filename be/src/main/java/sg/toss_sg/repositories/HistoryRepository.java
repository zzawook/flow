package sg.toss_sg.repositories;

import java.time.LocalDateTime;

import org.springframework.stereotype.Repository;

import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

@Repository
public interface HistoryRepository {

    MonthlyHistoryList getMonthlyTransaction(int year, int month);

    LocalDateTime getLastUpdatedDate();
    
}
