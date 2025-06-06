package sg.flow.repositories.user

import java.time.LocalDate
import kotlinx.coroutines.reactive.awaitFirstOrNull
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.User
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.utils.UserQueryStore

@Repository
class UserRepositoryImpl(private val databaseClient: DatabaseClient) : UserRepository {

    override suspend fun save(entity: User): User {
        val hasId = entity.id != null
        val queryString = if (hasId) UserQueryStore.SAVE_USER_WITH_ID else UserQueryStore.SAVE_USER

        if (hasId) {
            databaseClient
                    .sql(queryString)
                    .bind(0, entity.id!!)
                    .bind(1, entity.name)
                    .bind(2, entity.email)
                    .bind(3, entity.identificationNumber)
                    .bind(4, entity.phoneNumber)
                    .bind(5, entity.dateOfBirth)
                    .bind(6, entity.address)
                    .bind(7, entity.settingJson)
                    .fetch()
                    .awaitRowsUpdated()
        } else {
            databaseClient
                    .sql(queryString)
                    .bind(0, entity.name)
                    .bind(1, entity.email)
                    .bind(2, entity.identificationNumber)
                    .bind(3, entity.phoneNumber)
                    .bind(4, entity.dateOfBirth)
                    .bind(5, entity.address)
                    .bind(6, entity.settingJson)
                    .fetch()
                    .awaitRowsUpdated()
        }

        return entity
    }

    override suspend fun findById(id: Long): User? {
        return databaseClient
                .sql(UserQueryStore.FIND_USER_BY_ID)
                .bind(0, id)
                .map { row ->
                    User(
                            id = row.get("id", Int::class.java),
                            name = row.get("name", String::class.java)!!,
                            email = row.get("email", String::class.java)!!,
                            identificationNumber =
                                    row.get("identification_number", String::class.java)!!,
                            phoneNumber = row.get("phone_number", String::class.java)!!,
                            dateOfBirth = row.get("date_of_birth", LocalDate::class.java)!!,
                            address = row.get("address", String::class.java)!!,
                            settingJson = row.get("setting_json", String::class.java)!!
                    )
                }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql(UserQueryStore.DELETE_ALL_USERS).fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override suspend fun getUserProfile(id: Int): UserProfile {
        return databaseClient
                .sql(UserQueryStore.FIND_USER_PROFILE)
                .bind(0, id)
                .map { row ->
                    UserProfile(
                            id = id,
                            name = row.get("name", String::class.java)!!,
                            email = row.get("email", String::class.java)!!,
                            phoneNumber = row.get("phone_number", String::class.java)!!,
                            dateOfBirth = row.get("date_of_birth", LocalDate::class.java)!!,
                            identificationNumber =
                                    row.get("identification_number", String::class.java)!!,
                            settingJson = null
                    )
                }
                .one()
                .awaitFirstOrNull()
                ?: throw RuntimeException("User with id $id not found")
    }

    override suspend fun getUserPreferenceJson(userId: Int): String {
        return databaseClient
                .sql(UserQueryStore.FIND_USER_PREFERENCE_JSON)
                .bind(0, userId)
                .map { row -> row.get("setting_json", String::class.java) ?: "{}" }
                .one()
                .awaitFirstOrNull()
                ?: throw RuntimeException("User with id $userId not found")
    }

    override suspend fun updateUserProfile(
            userId: Int,
            userProfile: UpdateUserProfile
    ): UserProfile {
        val updateQuery =
                """
            UPDATE users 
            SET email = COALESCE(?, email), 
                phone_number = COALESCE(?, phone_number)
            WHERE id = ?
        """.trimIndent()

        val rowsUpdated =
                databaseClient
                        .sql(updateQuery)
                        .bind(0, userProfile.email ?: "")
                        .bind(1, userProfile.phoneNumber ?: "")
                        .bind(2, userId)
                        .fetch()
                        .awaitRowsUpdated()

        if (rowsUpdated == 0L) {
            throw RuntimeException("User with id $userId not found")
        }

        // Return the updated user profile
        return getUserProfile(userId)
    }
}
