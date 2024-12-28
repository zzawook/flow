package sg.toss_sg.repositories.card;

import java.util.Optional;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Card;

public class CardRepositoryImpl implements CardRepository {

    DatabaseConnectionPool databaseConnectionPool;

    public CardRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Card save(Card entity) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'save'");
    }

    @Override
    public Optional<Card> findById(Long id) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'findById'");
    }
    
}
