package sg.flow.repositories.transactionHistory;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Time;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.flow.configs.DatabaseConnectionPool;
import sg.flow.entities.Account;
import sg.flow.entities.Bank;
import sg.flow.entities.Card;
import sg.flow.entities.TransactionHistory;
import sg.flow.entities.utils.AccountType;
import sg.flow.entities.utils.CardType;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.models.transaction.history.TransactionHistoryList;
import sg.flow.repositories.utils.TransactionHistoryQueryStore;

@Repository
public class TransactionHistoryRepositoryImpl implements TransactionHistoryRepository {

    private final DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY;

    private final String SAVE_WITH_ID = TransactionHistoryQueryStore.SAVE_TRANSACTION_HISTORY_WITH_ID;

    private final String FIND_BY_ID = TransactionHistoryQueryStore.FIND_TRANSACTION_HISTORY_BY_ID;

    private final String FIND_DETAIL_BY_ID = TransactionHistoryQueryStore.FIND_TRANSACTION_DETAIL_BY_ID;

    private final String DELETE_ALL = TransactionHistoryQueryStore.DELETE_ALL_TRANSACTION_HISTORIES;

    private final String FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT = TransactionHistoryQueryStore.FIND_RECENT_TRANSACTION_HISTORY_BY_ACCOUNT_ID;

    private final String FIND_TRANSACTION_BETWEEN_DATES = TransactionHistoryQueryStore.FIND_TRANSACTION_BETWEEN_DATES;

    public TransactionHistoryRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
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

            pstm.setString(parameterStart + 1, entity.getTransactionReference());
            pstm.setLong(parameterStart + 2, entity.getAccount().getId());

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
            pstm.setString(parameterStart + 10, entity.getFriendlyDescription());

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
                        .transactionReference(resultSet.getString("transaction_reference"))
                        .account(Account.builder()
                            .id(resultSet.getLong("account_id"))
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
                        .friendlyDescription(resultSet.getString("friendly_description"))
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
    public List<TransactionHistoryDetail> findRecentTransactionHistoryDetailOfAccount(Long accountId) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT)) {
            pstm.setLong(1, accountId);

            List<TransactionHistoryDetail> transactionHistoryDetails = new ArrayList<>();;

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.isLast()) {
                return transactionHistoryDetails;
            }

            while (resultSet.next()) {
                TransactionHistoryDetail transactionHistoryDetail = new TransactionHistoryDetail();
                    transactionHistoryDetail.setId(resultSet.getLong("id"));
                    transactionHistoryDetail.setAccount(resultSet.getObject("account_id") != null ? Account.builder()
                        .id(resultSet.getLong("account_id"))
                        .accountNumber(resultSet.getString("account_number"))
                        .balance(resultSet.getDouble("account_balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("account_last_updated").toLocalDateTime())
                        .bank(Bank.builder()
                            .id(resultSet.getInt("bank_id"))
                            .name(resultSet.getString("bank_name"))
                            .bankCode(resultSet.getString("bank_code"))
                            .build())
                        .build() : null);
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

    @Override
    public TransactionHistoryList findTransactionBetweenDates(int userId, LocalDate start, LocalDate end) {
        return findTransactionBetweenDates(userId, start, end, 30);
    }

    @Override
    public TransactionHistoryList findTransactionBetweenDates(int userId, LocalDate start, LocalDate end, int limit) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_TRANSACTION_BETWEEN_DATES)) {
            pstm.setDate(1, Date.valueOf(start));
            pstm.setDate(2, Date.valueOf(end));
            pstm.setInt(3, userId);
            pstm.setInt(4, limit);

            TransactionHistoryList transactionHistoryList = new TransactionHistoryList(start, end);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.isLast()) {
                return transactionHistoryList;
            }

            while (resultSet.next()) {
                TransactionHistoryDetail transactionHistoryDetail = new TransactionHistoryDetail();
                transactionHistoryDetail.setId(resultSet.getLong("id"));
                transactionHistoryDetail.setTransactionReference(resultSet.getString("transaction_reference"));
                transactionHistoryDetail.setAccount(resultSet.getObject("account_id") != null ? Account.builder()
                        .id(resultSet.getLong("account_id"))
                        .accountNumber(resultSet.getString("account_number"))
                        .balance(resultSet.getDouble("account_balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("account_last_updated").toLocalDateTime())
                        .bank(Bank.builder()
                                .id(resultSet.getInt("bank_id"))
                                .name(resultSet.getString("bank_name"))
                                .bankCode(resultSet.getString("bank_code"))
                                .build())
                        .build() : null);
                transactionHistoryDetail.setCard(resultSet.getObject("card_id") != null ? Card.builder()
                        .id(resultSet.getLong("card_id"))
                        .cardNumber(resultSet.getString("card_number"))
                        .cardType(CardType.valueOf(resultSet.getString("card_type")))
                        .build() : null);
                transactionHistoryDetail.setTransactionDate(resultSet.getDate("transaction_date").toLocalDate());
                transactionHistoryDetail.setTransactionTime(resultSet.getTime("transaction_time").toLocalTime());
                transactionHistoryDetail.setAmount(resultSet.getDouble("amount"));
                transactionHistoryDetail.setTransactionType(resultSet.getString("transaction_type"));
                transactionHistoryDetail.setDescription(resultSet.getString("description"));
                transactionHistoryDetail.setTransactionStatus(resultSet.getString("transaction_status"));
                transactionHistoryDetail.setFriendlyDescription(resultSet.getString("friendly_description"));
                transactionHistoryList.add(transactionHistoryDetail);
            }
            return transactionHistoryList;

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
    public TransactionHistoryDetail findTransactionDetailById(long long1) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_DETAIL_BY_ID)) {
            pstm.setLong(1, long1);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.isLast()) {
                return null;
            }
            if (resultSet.next()) {
                TransactionHistoryDetail transactionHistoryDetail = new TransactionHistoryDetail();
                transactionHistoryDetail.setId(resultSet.getLong("id"));
                transactionHistoryDetail.setTransactionReference(resultSet.getString("transaction_reference"));
                transactionHistoryDetail.setAccount(resultSet.getObject("account_id") != null ? Account.builder()
                        .id(resultSet.getLong("account_id"))
                        .accountNumber(resultSet.getString("account_number"))
                        .balance(resultSet.getDouble("account_balance"))
                        .accountName(resultSet.getString("account_name"))
                        .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                        .lastUpdated(resultSet.getTimestamp("account_last_updated").toLocalDateTime())
                        .bank(Bank.builder()
                                .id(resultSet.getInt("bank_id"))
                                .name(resultSet.getString("bank_name"))
                                .bankCode(resultSet.getString("bank_code"))
                                .build())
                        .build() : null);
                transactionHistoryDetail.setCard(resultSet.getObject("card_id") != null ? Card.builder()
                        .id(resultSet.getLong("card_id"))
                        .cardNumber(resultSet.getString("card_number"))
                        .cardType(CardType.valueOf(resultSet.getString("card_type")))
                        .build() : null);
                transactionHistoryDetail.setTransactionDate(resultSet.getDate("transaction_date").toLocalDate());
                transactionHistoryDetail.setTransactionTime(resultSet.getTime("transaction_time").toLocalTime());
                transactionHistoryDetail.setAmount(resultSet.getDouble("amount"));
                transactionHistoryDetail.setTransactionType(resultSet.getString("transaction_type"));
                transactionHistoryDetail.setDescription(resultSet.getString("description"));
                transactionHistoryDetail.setTransactionStatus(resultSet.getString("transaction_status"));
                transactionHistoryDetail.setFriendlyDescription(resultSet.getString("friendly_description"));
                return transactionHistoryDetail;
            }
            return null;
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

    public boolean containsColumnLabel(ResultSet resultSet, String columnName) throws SQLException{
        ResultSetMetaData metaData = resultSet.getMetaData();
        int columnCount = metaData.getColumnCount();
        for (int i = 1; i <= columnCount; i++) {
            String columnLabel = metaData.getColumnLabel(i);
            if (columnLabel.equals(columnName)) {
                return true;
            }
        }
        return false;

    }

}
