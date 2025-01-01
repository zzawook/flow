package sg.toss_sg.repositories.user;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.toss_sg.configs.DatabaseConnectionPool;
import sg.toss_sg.entities.User;
import sg.toss_sg.repositories.utils.QueryStore;

@Repository
public class UserRepositoryImpl implements UserRepository {
    DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = QueryStore.SAVE_USER;

    private final String SAVE_WITH_ID = QueryStore.SAVE_USER_WITH_ID;

    private final String FIND_BY_ID = QueryStore.FIND_USER_BY_ID;

    private final String DELETE_ALL = QueryStore.DELETE_ALL_USERS;

    public UserRepositoryImpl(DatabaseConnectionPool databaseConnectionPool) {
        this.databaseConnectionPool = databaseConnectionPool;
    }

    @Override
    public User save(User entity) {
        Connection connection = databaseConnectionPool.getConnection();
        boolean hasId = entity.getId() != null;
        String queryString = hasId ? SAVE_WITH_ID : SAVE;
        int parameterStart = hasId ? 1 : 0;
        try (PreparedStatement pstm = connection.prepareStatement(queryString)) {
            if (hasId) {
                pstm.setLong(parameterStart, entity.getId());
            }
            pstm.setString(parameterStart + 1, entity.getName());
            pstm.setString(parameterStart + 2, entity.getEmail());
            pstm.setString(parameterStart + 3, entity.getIdentificationNumber());
            pstm.setString(parameterStart + 4, entity.getPhoneNumber());
            pstm.setDate(parameterStart + 5, Date.valueOf(entity.getDateOfBirth()));
            pstm.setString(parameterStart + 6, entity.getSettingJson());

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
    public Optional<User> findById(Long id) {
        if (id == null) {
            return Optional.empty();
        }
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_BY_ID)) {
            pstm.setLong(1, id);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.next()) {
                User user = User.builder()
                        .id(resultSet.getInt("id"))
                        .name(resultSet.getString("name"))
                        .email(resultSet.getString("email"))
                        .identificationNumber(resultSet.getString("identification_number"))
                        .phoneNumber(resultSet.getString("phone_number"))
                        .dateOfBirth(resultSet.getDate("date_of_birth").toLocalDate())
                        .settingJson(resultSet.getString("setting_json"))
                        .build();
                return Optional.of(user);
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

}
