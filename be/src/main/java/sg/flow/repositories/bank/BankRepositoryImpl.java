package sg.flow.repositories.bank;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.flow.configs.DatabaseConnectionPool;
import sg.flow.entities.Bank;
import sg.flow.repositories.utils.BankQueryStore;

@Repository
public class BankRepositoryImpl implements BankRepository {

    DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = BankQueryStore.SAVE_BANK;

    private final String SAVE_WITH_ID = BankQueryStore.SAVE_BANK_WITH_ID;

    private final String FIND_BY_ID = BankQueryStore.FIND_BANK_BY_ID;

    private final String DELETE_ALL = BankQueryStore.DELETE_ALL_BANKS;

    public BankRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Bank save(Bank entity) {
        Connection connection = databaseConnectionPool.getConnection();
        boolean hasId = entity.getId() != null;
        String queryString = hasId ? SAVE_WITH_ID : SAVE;
        int parameterStart = hasId ? 1 : 0;
        try (PreparedStatement pstm = connection.prepareStatement(queryString)) {
            if (hasId) {
                pstm.setLong(parameterStart, entity.getId());
            }

            pstm.setString(parameterStart + 1, entity.getName());
            pstm.setString(parameterStart + 2, entity.getBankCode());

            pstm.executeUpdate();
            return entity;
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
    }

    @Override
    public Optional<Bank> findById(Long id) {
        if (id == null) {
            return Optional.empty();
        }

        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_BY_ID)) {
            pstm.setLong(1, id);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.isLast()) {
                return Optional.empty();
            }
            if (resultSet.next()) {
                Bank bank = Bank.builder()
                        .id(resultSet.getInt("id"))
                        .name(resultSet.getString("bank_name"))
                        .bankCode(resultSet.getString("bank_code"))
                        .build();
                return Optional.of(bank);
            }
            return Optional.empty();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                connection.close();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
    }

    @Override
    public boolean deleteAll() {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(DELETE_ALL)) {
            pstm.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                connection.close();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
    }
}
