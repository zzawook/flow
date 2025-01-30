package sg.flow.repositories.user;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Optional;

import org.springframework.stereotype.Repository;

import sg.flow.configs.DatabaseConnectionPool;
import sg.flow.entities.User;
import sg.flow.models.user.UpdateUserProfile;
import sg.flow.models.user.UserProfile;
import sg.flow.repositories.utils.UserQueryStore;

@Repository
public class UserRepositoryImpl implements UserRepository {
    DatabaseConnectionPool databaseConnectionPool;

    private final String SAVE = UserQueryStore.SAVE_USER;

    private final String SAVE_WITH_ID = UserQueryStore.SAVE_USER_WITH_ID;

    private final String FIND_BY_ID = UserQueryStore.FIND_USER_BY_ID;

    private final String DELETE_ALL = UserQueryStore.DELETE_ALL_USERS;

    private final String FIND_USER_PROFILE = UserQueryStore.FIND_USER_PROFILE;

    private final String FIND_USER_PREFERENCE_JSON = UserQueryStore.FIND_USER_PREFERENCE_JSON;

    private final String UPDATE_USER_PROFILE = UserQueryStore.UPDATE_USER_PROFILE;

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
            pstm.setString(parameterStart + 6, entity.getAddress());
            pstm.setString(parameterStart + 7, entity.getSettingJson());

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
                        .address(resultSet.getString("address"))
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

    @Override
    public UserProfile getUserProfile(Integer id) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_USER_PROFILE)) {
            pstm.setInt(1, id);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.next()) {
                UserProfile userProfile = new UserProfile(
                        resultSet.getString("name"),
                        resultSet.getString("email"),
                        resultSet.getString("phone_number"),
                        resultSet.getDate("date_of_birth").toLocalDate(),
                        resultSet.getString("identification_number"),
                        resultSet.getString("address"));
                return userProfile;
            }
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
        return null;
    }

    @Override
    public String getUserPreferenceJson(Integer userId) {
        Connection connection = databaseConnectionPool.getConnection();
        try (PreparedStatement pstm = connection.prepareStatement(FIND_USER_PREFERENCE_JSON)) {
            pstm.setInt(1, userId);

            ResultSet resultSet = pstm.executeQuery();
            if (resultSet.next()) {
                return resultSet.getString("setting_json");
            }
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
        return null;
    }

    @Override
    public UserProfile updateUserProfile(Integer userId, UpdateUserProfile updateUserProfile) {
        Connection connection = databaseConnectionPool.getConnection();
        UserProfile userProfile = this.getUserProfile(userId);
        this.mergeUserProfile(userProfile, updateUserProfile);
        if (userProfile == null) {
            return null;
        }
        try (PreparedStatement pstm = connection.prepareStatement(UPDATE_USER_PROFILE)) {
            pstm.setString(1, userProfile.getEmail());
            pstm.setString(2, userProfile.getPhoneNumber());
            pstm.setString(3, userProfile.getAddress());

            pstm.setInt(4, userId);

            pstm.executeUpdate();

            return userProfile;
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

    private void mergeUserProfile(UserProfile originalUserProfile, UpdateUserProfile userProfile) {
        if (userProfile.getEmail() != null) {
            originalUserProfile.setEmail(userProfile.getEmail());
        }
        if (userProfile.getPhoneNumber() != null) {
            originalUserProfile.setPhoneNumber(userProfile.getPhoneNumber());
        }
        if (userProfile.getAddress() != null) {
            originalUserProfile.setAddress(userProfile.getAddress());
        }
    }
}
