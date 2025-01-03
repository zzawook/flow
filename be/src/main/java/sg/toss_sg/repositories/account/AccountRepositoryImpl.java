package sg.toss_sg.repositories.account;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Account;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.User;
import sg.toss_sg.entities.utils.AccountType;
import sg.toss_sg.repositories.utils.AccountQueryStore;

@Repository
public class AccountRepositoryImpl implements AccountRepository {

    DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = AccountQueryStore.SAVE_ACCOUNT;

    private final String SAVE_WITH_ID = AccountQueryStore.SAVE_ACCOUNT_WITH_ID;

    private final String FIND_BY_ID = AccountQueryStore.FIND_ACCOUNT_BY_ID;

    private final String DELETE_ALL = AccountQueryStore.DELETE_ALL_ACCOUNTS;

    public AccountRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Account save(Account entity) {
        Connection connection = databaseConnectionPool.getConnection();
        boolean hasId = entity.getId() != null;
        String queryString = hasId ? SAVE_WITH_ID : SAVE;
        int parameterStart = hasId ? 1 : 0;
        try (PreparedStatement pstm = connection.prepareStatement(queryString)) {
            if (hasId) {
                pstm.setLong(parameterStart, entity.getId());
            }
            pstm.setString(parameterStart + 1, entity.getAccountNumber());
            pstm.setInt(parameterStart + 2, entity.getBank().getId());
            pstm.setInt(parameterStart + 3, entity.getOwner().getId());
            pstm.setDouble(parameterStart + 4, entity.getBalance());
            pstm.setString(parameterStart + 5, entity.getAccountName());
            pstm.setString(parameterStart + 6, entity.getAccountType().toString());
            pstm.setTimestamp(parameterStart + 7, Timestamp.valueOf(entity.getLastUpdated()));

            pstm.executeUpdate();
            connection.close();
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
    public Optional<Account> findById(Long id) {
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
                Account account = Account.builder()
                        .id(resultSet.getLong("id"))
                        .accountNumber(resultSet.getString("account_number"))
                        .balance(resultSet.getDouble("balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("last_updated").toLocalDateTime())
                        .bank(Bank.builder()
                                .id(resultSet.getInt("bank_id"))
                                .name(resultSet.getString("bank_name"))
                                .bankCode(resultSet.getString("bank_code"))
                                .build())
                        .owner(User.builder()
                                .id(resultSet.getInt("user_id"))
                                .name(resultSet.getString("name"))
                                .email(resultSet.getString("email"))
                                .identificationNumber(resultSet.getString("identification_number"))
                                .phoneNumber(resultSet.getString("phone_number"))
                                .dateOfBirth(resultSet.getDate("date_of_birth").toLocalDate())
                                .settingJson(resultSet.getString("setting_json"))
                                .build())
                        .build();
                return Optional.of(account);
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
