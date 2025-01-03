package sg.toss_sg.repositories.card;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.Account;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.Card;
import sg.toss_sg.entities.User;
import sg.toss_sg.entities.utils.AccountType;
import sg.toss_sg.entities.utils.CardType;
import sg.toss_sg.repositories.utils.CardQueryStore;

@Repository
public class CardRepositoryImpl implements CardRepository {

    DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = CardQueryStore.SAVE_CARD;

    private final String SAVE_WITH_ID = CardQueryStore.SAVE_CARD_WITH_ID;

    private final String FIND_BY_ID = CardQueryStore.FIND_CARD_BY_ID;

    private final String DELETE_ALL = CardQueryStore.DELETE_ALL_CARDS;

    public CardRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public Card save(Card entity) {
        Connection connection = databaseConnectionPool.getConnection();
        boolean hasId = entity.getId() != null;
        String queryString = hasId ? SAVE_WITH_ID : SAVE;
        int parameterStart = hasId ? 1 : 0;

        try (PreparedStatement pstm = connection.prepareStatement(queryString)) {
            if (hasId) {
                pstm.setLong(parameterStart, entity.getId());
            }

            pstm.setInt(parameterStart + 1, entity.getOwner().getId());
            pstm.setLong(parameterStart + 2, entity.getLinkedAccount().getId());
            pstm.setInt(parameterStart + 3, entity.getIssuingBank().getId());
            pstm.setString(parameterStart + 4, entity.getCardNumber());
            pstm.setString(parameterStart + 5, entity.getCardType().name());
            pstm.setString(parameterStart + 6, entity.getCvv());
            pstm.setDate(parameterStart + 7, Date.valueOf(entity.getExpiryDate()));
            pstm.setString(parameterStart + 8, entity.getCardHolderName());
            pstm.setString(parameterStart + 9, entity.getPin());
            pstm.setString(parameterStart + 10, entity.getCardStatus());
            pstm.setString(parameterStart + 11, entity.getAddressLine1());
            pstm.setString(parameterStart + 12, entity.getAddressLine2());
            pstm.setString(parameterStart + 13, entity.getCity());
            pstm.setString(parameterStart + 14, entity.getState());
            pstm.setString(parameterStart + 15, entity.getCountry());
            pstm.setString(parameterStart + 16, entity.getZipCode());
            pstm.setString(parameterStart + 17, entity.getPhone());
            pstm.setDouble(parameterStart + 18, entity.getDailyLimit());
            pstm.setDouble(parameterStart + 19, entity.getMonthlyLimit());

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
    public Optional<Card> findById(Long id) {
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
                Card card = Card.builder()
                        .id(resultSet.getLong("id"))
                        .owner(User.builder()
                                .id(resultSet.getInt("owner_id"))
                                .name(resultSet.getString("name"))
                                .email(resultSet.getString("email"))
                                .identificationNumber(resultSet.getString("identification_number"))
                                .phoneNumber(resultSet.getString("phone_number"))
                                .dateOfBirth(resultSet.getDate("date_of_birth").toLocalDate())
                                .settingJson(resultSet.getString("setting_json"))
                                .build())
                        .linkedAccount(Account.builder()
                                .id(resultSet.getLong("linked_account_id"))
                                .accountNumber(resultSet.getString("account_number"))
                                .balance(resultSet.getDouble("balance"))
                                .accountName(resultSet.getString("account_name"))
                                .accountType(AccountType.valueOf(resultSet.getString("account_type")))
                                .lastUpdated(resultSet.getTimestamp("last_updated").toLocalDateTime())
                                .build())
                        .issuingBank(Bank.builder()
                                .id(resultSet.getInt("issuing_bank_id"))
                                .name(resultSet.getString("bank_name"))
                                .bankCode(resultSet.getString("bank_code"))
                                .build())
                        .cardNumber(resultSet.getString("card_number"))
                        .cardType(CardType.valueOf(resultSet.getString("card_type")))
                        .build();
                return Optional.of(card);
            }
            return Optional.empty();
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
