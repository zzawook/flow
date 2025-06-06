package sg.flow.repositories.user

import java.sql.Date
import java.sql.SQLException
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.springframework.stereotype.Repository
import sg.flow.configs.DatabaseConnectionPool
import sg.flow.entities.User
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.utils.UserQueryStore

@Repository
class UserRepositoryImpl(private val databaseConnectionPool: DatabaseConnectionPool) :
        UserRepository {

    override suspend fun save(entity: User): User =
            withContext(Dispatchers.IO) {
                val connection =
                        databaseConnectionPool.getConnection()
                                ?: throw RuntimeException("Failed to get connection")
                val hasId = entity.id != null
                val queryString =
                        if (hasId) UserQueryStore.SAVE_USER_WITH_ID else UserQueryStore.SAVE_USER
                val parameterStart = if (hasId) 1 else 0

                try {
                    connection.use { conn ->
                        conn.prepareStatement(queryString).use { pstm ->
                            if (hasId) {
                                pstm.setInt(parameterStart, entity.id!!)
                            }
                            pstm.setString(parameterStart + 1, entity.name)
                            pstm.setString(parameterStart + 2, entity.email)
                            pstm.setString(parameterStart + 3, entity.identificationNumber)
                            pstm.setString(parameterStart + 4, entity.phoneNumber)
                            pstm.setDate(parameterStart + 5, Date.valueOf(entity.dateOfBirth))
                            pstm.setString(parameterStart + 6, entity.address)
                            pstm.setString(parameterStart + 7, entity.settingJson)

                            pstm.executeUpdate()
                            entity
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    throw RuntimeException("Failed to save user", e)
                }
            }

    override suspend fun findById(id: Long): User? =
            withContext(Dispatchers.IO) {
                val connection = databaseConnectionPool.getConnection() ?: return@withContext null

                try {
                    connection.use { conn ->
                        conn.prepareStatement(UserQueryStore.FIND_USER_BY_ID).use { pstm ->
                            pstm.setLong(1, id)
                            val resultSet = pstm.executeQuery()

                            if (resultSet.next()) {
                                User(
                                        id = resultSet.getInt("id"),
                                        name = resultSet.getString("name"),
                                        email = resultSet.getString("email"),
                                        identificationNumber =
                                                resultSet.getString("identification_number"),
                                        phoneNumber = resultSet.getString("phone_number"),
                                        dateOfBirth =
                                                resultSet.getDate("date_of_birth").toLocalDate(),
                                        address = resultSet.getString("address"),
                                        settingJson = resultSet.getString("setting_json")
                                )
                            } else null
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    null
                }
            }

    override suspend fun deleteAll(): Boolean =
            withContext(Dispatchers.IO) {
                val connection = databaseConnectionPool.getConnection() ?: return@withContext false

                try {
                    connection.use { conn ->
                        conn.prepareStatement(UserQueryStore.DELETE_ALL_USERS).use { pstm ->
                            pstm.executeUpdate()
                            true
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    false
                }
            }

    override suspend fun getUserProfile(id: Int): UserProfile =
            withContext(Dispatchers.IO) {
                val connection =
                        databaseConnectionPool.getConnection()
                                ?: throw RuntimeException("Failed to get connection")

                try {
                    connection.use { conn ->
                        conn.prepareStatement(UserQueryStore.FIND_USER_PROFILE).use { pstm ->
                            pstm.setInt(1, id)
                            val resultSet = pstm.executeQuery()

                            if (resultSet.next()) {
                                UserProfile(
                                        id = id,
                                        name = resultSet.getString("name"),
                                        email = resultSet.getString("email"),
                                        phoneNumber = resultSet.getString("phone_number"),
                                        dateOfBirth =
                                                resultSet.getDate("date_of_birth").toLocalDate(),
                                        identificationNumber =
                                                resultSet.getString("identification_number"),
                                        settingJson = null
                                )
                            } else {
                                throw RuntimeException("User with id $id not found")
                            }
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    throw RuntimeException("Failed to get user profile", e)
                }
            }

    override suspend fun getUserPreferenceJson(userId: Int): String =
            withContext(Dispatchers.IO) {
                val connection =
                        databaseConnectionPool.getConnection()
                                ?: throw RuntimeException("Failed to get connection")

                try {
                    connection.use { conn ->
                        conn.prepareStatement(UserQueryStore.FIND_USER_PREFERENCE_JSON).use { pstm
                            ->
                            pstm.setInt(1, userId)
                            val resultSet = pstm.executeQuery()

                            if (resultSet.next()) {
                                resultSet.getString("setting_json") ?: "{}"
                            } else {
                                throw RuntimeException("User with id $userId not found")
                            }
                        }
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    throw RuntimeException("Failed to get user preference json", e)
                }
            }

    override suspend fun updateUserProfile(
            userId: Int,
            userProfile: UpdateUserProfile
    ): UserProfile =
            withContext(Dispatchers.IO) {
                val connection =
                        databaseConnectionPool.getConnection()
                                ?: throw RuntimeException("Failed to get connection")

                try {
                    connection.use { conn ->
                        // Update the user with non-null fields
                        val updateQuery =
                                """
                    UPDATE users 
                    SET email = COALESCE(?, email), 
                        phone_number = COALESCE(?, phone_number)
                    WHERE id = ?
                """.trimIndent()

                        conn.prepareStatement(updateQuery).use { pstm ->
                            pstm.setString(1, userProfile.email)
                            pstm.setString(2, userProfile.phoneNumber)
                            pstm.setInt(3, userId)

                            val rowsUpdated = pstm.executeUpdate()
                            if (rowsUpdated == 0) {
                                throw RuntimeException("User with id $userId not found")
                            }
                        }

                        // Return the updated user profile
                        getUserProfile(userId)
                    }
                } catch (e: SQLException) {
                    e.printStackTrace()
                    throw RuntimeException("Failed to update user profile", e)
                }
            }
}
