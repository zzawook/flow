package sg.toss_sg.repositories.user;

import java.util.Optional;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.User;

public class UserRepositoryImpl implements UserRepository {
    DatabaseConnectionPool databaseConnectionPool;

    public UserRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public User save(User entity) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'save'");
    }

    @Override
    public Optional<User> findById(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findById'");
    }
    
}
