package sg.toss_sg.repositories.transactionHistory;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Account;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.Card;
import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.entities.utils.AccountType;
import sg.toss_sg.entities.utils.CardType;
import sg.toss_sg.models.transaction.history.MonthlyTransactionHistoryList;
import sg.toss_sg.models.transaction.history.TransactionHistoryDetail;
import sg.toss_sg.repositories.utils.TransactionHistoryQueryStore;

@Repository
public class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {

    private final DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY;

    private final String SAVE_WITH_ID = TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY_WITH_ID;

    private final String FIND_BY_ID = TransactionHistoryQueryStore.FIND_TRANSACTION_HISTORY_BY_ID;

    private final String DELETE_ALL = TransactionHistoryQueryStore.DELETE_ALL_TRANSACTION_HISTORIES;

    private final String FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT = TransactionHistoryQueryStore.FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT;

    public TransactionHistoryRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public MonthlyTransactionHistoryList getMonthlyTransaction(int year, int month) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getMonthlyTransaction'");
    }

    @Override
    public LocalDateTime getLastUpdatedDate() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getLastUpdatedDate'");
    }

    @Override
    public TransactionHistory save(TransactionHistory entity) {
        Connection connection = databaseConnectionPool.getConnection();
        boolean hasId = entity.getId() != null;
        String queryString = hasId ? SAVE_WITH_ID : SAVE;
        int parameterStart = hasId ? 1 : 0;
        try (PreparedStatement pstm = connection.prepareStatement(queryString)) {
            if (hasId) {
                pstm.setLong(parameterStart, entity.getId());
            }

            pstm.setLong(parameterStart + 1, entity.getToAccount().getId());
            pstm.setLong(parameterStart + 2, entity.getFromAccount().getId());

            Card card = entity.getCard();
            if (card != null) {
                pstm.setLong(parameterStart + 3, card.getId());
            } else {
                pstm.setNull(parameterStart + 3, java.sql.Types.BIGINT);
            }

            pstm.setDate(parameterStart + 4, Date.valueOf(entity.getTransactionDate()));
            pstm.setTime(parameterStart + 5, Time.valueOf(entity.getTransactionTime()));
            pstm.setDouble(parameterStart + 6, entity.getAmount());
            pstm.setString(parameterStart + 7, entity.getTransactionType().toString());
            pstm.setString(parameterStart + 8, entity.getDescription());
            pstm.setString(parameterStart + 9, entity.getTransactionStatus().toString());

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
    public Optional<TransactionHistory> findById(Long id) {
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
                TransactionHistory transactionHistory = TransactionHistory.builder()
                        .id(resultSet.getLong("id"))
                        .toAccount(Account.builder()
                                .id(resultSet.getLong("to_account_id"))
                                .accountNumber(resultSet.getString("to_account_number"))
                                .balance(resultSet.getDouble("to_account_balance"))
                                .accountName(resultSet.getString("to_account_name"))
                                .accountType(AccountType.valueOf(resultSet.getString("to_account_type")))
                                .lastUpdated(resultSet.getTimestamp("to_account_last_updated").toLocalDateTime())
                                .bank(Bank.builder()
                                        .id(resultSet.getInt("to_bank_id"))
                                        .name(resultSet.getString("to_bank_name"))
                                        .build())
                                .build())
                        .fromAccount(Account.builder()
                                .id(resultSet.getLong("from_account_id"))
                                .accountNumber(resultSet.getString("from_account_number"))
                                .balance(resultSet.getDouble("from_account_balance"))
                                .accountName(resultSet.getString("from_account_name"))
                                .accountType(AccountType.valueOf(resultSet.getString("from_account_type")))
                                .lastUpdated(resultSet.getTimestamp("from_account_last_updated").toLocalDateTime())
                                .bank(Bank.builder()
                                        .id(resultSet.getInt("from_bank_id"))
                                        .name(resultSet.getString("from_bank_name"))
                                        .build())
                                .build())
                        .card(resultSet.getObject("card_id") != null ? Card.builder()
                                .id(resultSet.getLong("card_id"))
                                .cardNumber(resultSet.getString("card_number"))
                                .cardType(CardType.valueOf(resultSet.getString("card_type")))
                                .build() : null)
                        .transactionDate(resultSet.getDate("transaction_date").toLocalDate())
                        .transactionTime(resultSet.getTime("transaction_time").toLocalTime())
                        .amount(resultSet.getDouble("amount"))
                        .transactionType(resultSet.getString("transaction_type"))
                        .description(resultSet.getString("description"))
                        .transactionStatus(resultSet.getString("transaction_status"))
                        .build();
                return Optional.of(transactionHistory);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return Optional.empty();
        } finally {
            try {
                connection.close();
            } catch (SQLException e1) {
                e1.printStackTrace();
            }
        }
        return null;
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

    @Override
    public List<TransactionHistoryDetail> findRecentTransactionHistoryDetailOfAccount(Long id) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT)) {
            pstm.setLong(1, id);

            List<TransactionHistoryDetail> transactionHistoryDetails = new ArrayList<>();
            ;

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.isLast()) {
                return transactionHistoryDetails;
            }

            while (resultSet.next()) {
                TransactionHistoryDetail transactionHistoryDetail = new TransactionHistoryDetail();
                transactionHistoryDetail.setId(resultSet.getLong("id"));
                transactionHistoryDetail.setToAccount(Account.builder()
                        .id(resultSet.getLong("to_account_id"))
                        .accountNumber(resultSet.getString("to_account_number"))
                        .balance(resultSet.getDouble("balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("last_updated").toLocalDateTime())
                        .build());
                transactionHistoryDetail.setFromAccount(Account.builder()
                        .id(resultSet.getLong("from_account_id"))
                        .accountNumber(resultSet.getString("account_number"))
                        .balance(resultSet.getDouble("balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("last_updated").toLocalDateTime())
                        .build());
                transactionHistoryDetail.setCard(resultSet.getObject("card_id") != null ? Card.builder()
                        .id(resultSet.getLong("card_id"))
                        .cardNumber(resultSet.getString("card_number"))
                        .cardType(CardType.valueOf(resultSet.getString("card_type")))
                        .build() : null);
                transactionHistoryDetail.setTransactionDate(resultSet.getDate("transaction_date").toLocalDate());
                transactionHistoryDetail.setTransactionTime(resultSet.getTime("transaction_time").toLocalTime());
                transactionHistoryDetail.setAmount(resultSet.getDouble("amount"));
                transactionHistoryDetail.setTransactionType(resultSet.getString("transaction_type"));
                transactionHistoryDetails.add(transactionHistoryDetail);
            }
            return transactionHistoryDetails;

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

}
