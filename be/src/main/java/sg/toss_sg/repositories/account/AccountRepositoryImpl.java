package sg.toss_sg.repositories.account;

import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Account;

@Repository
public class AccountRepositoryImpl implements AccountRepository {

    DatabaseConnectionPool databaseConnectionPool;

    public AccountRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Account save(Account entity) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'save'");
    }

    @Override
    public Optional<Account> findById(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findById'");
    }
}
