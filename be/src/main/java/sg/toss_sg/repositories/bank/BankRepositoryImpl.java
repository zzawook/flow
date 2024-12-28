package sg.toss_sg.repositories.bank;

import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Bank;

@Repository
public class BankRepositoryImpl implements BankRepository {

    DatabaseConnectionPool databaseConnectionPool;

    public BankRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Bank save(Bank entity) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'save'");
    }

    @Override
    public Optional<Bank> findById(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findById'");
    }
}
