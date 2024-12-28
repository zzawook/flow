package sg.toss_sg.repositories.transactionHistory;

import java.time.LocalDateTime;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;

@Repository
public class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {

    private final DatabaseConnectionPool cDatabaseConnectionPool;

    public TransactionHistoryRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.cDatabaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public MonthlyHistoryList getMonthlyTransaction(int year, int month) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getMonthlyTransaction'");
    }

    @Override
    public LocalDateTime getLastUpdatedDate() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getLastUpdatedDate'");
    }

    @Override
    public TransactionHistory save(TransactionHistory transactionHistory) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'save'");
    }

    @Override
    public Optional<TransactionHistory> findById(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findById'");
    }

}
