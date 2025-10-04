package sg.flow.repositories.user

import kotlinx.coroutines.flow.toList
import kotlinx.coroutines.reactive.asFlow
import java.time.LocalDate
import kotlinx.coroutines.reactive.awaitFirstOrNull
import kotlinx.coroutines.reactive.awaitSingle
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.User
import sg.flow.grpc.UserIdAndPasswordHash
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.utils.UserQueryStore

@Suppress("NULLABILITY_MISMATCH_BASED_ON_JAVA_ANNOTATIONS")
@Repository
class UserRepositoryImpl(private val databaseClient: DatabaseClient) : UserRepository {

    val logger = LoggerFactory.getLogger(UserRepositoryImpl::class.java)

    override suspend fun save(entity: User): User {
        val hasId = entity.id != null
        val queryString = if (hasId) UserQueryStore.SAVE_USER_WITH_ID else UserQueryStore.SAVE_USER

        if (hasId) {
            databaseClient
                    .sql(queryString)
                    .bind(0, entity.id)
                    .bind(1, entity.name)
                    .bind(2, entity.email)
                    .bind(3, entity.identificationNumber)
                    .bind(4, entity.phoneNumber)
                    .bind(5, entity.dateOfBirth)
                    .bind(6, entity.address)
                    .bind(7, entity.passwordHash)
                    .bind(8, entity.settingJson)
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
                    .bind(6, entity.passwordHash)
                    .bind(7, entity.settingJson)
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
                            id = row.get("id", Int::class.java)!!,
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

    override fun getAllUserIds(): List<Int> {
        return runCatching {
            val sql = UserQueryStore.FIND_ALL_USER_IDS

            databaseClient.sql(sql)
                .map { row -> row.get("id", Int::class.java) }
                .all()
                .collectList()              // Mono<List<Int?>>
                .map { it.filterNotNull() } // Mono<List<Int>>
                .block() ?: emptyList()

        }.onFailure { e ->
            e.printStackTrace()
            logger.error("Failed to fetch all user IDs")
        } .getOrElse { emptyList() }
    }

    override suspend fun getUserProfile(id: Int): UserProfile {
        try {
            val profile = databaseClient
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

            if (profile == null) {
                logger.error("Couldn't find profile with id: $id")
                throw RuntimeException()
            }
            return profile
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to get user profile of id: $id")
            throw RuntimeException("User with id $id not found")
        }
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
        val updateQuery = """
        UPDATE users 
        SET email = COALESCE($1, email), 
            phone_number = COALESCE($2, phone_number)
        WHERE id = $3
    """.trimIndent()


        // 2) bind & execute, without .fetch()
        val rowsUpdated = databaseClient
            .sql(updateQuery)
            .bind(0, userProfile.email ?: "")
            .bind(1, userProfile.phoneNumber ?: "")
            .bind(2, userId)
            .fetch()
            .rowsUpdated()
            .awaitSingle()


        if (rowsUpdated == 0L) {
            throw RuntimeException("User with id $userId not found")
        }
        return getUserProfile(userId)
    }

    override suspend fun checkUserExists(email: String): Boolean {
        val sql = UserQueryStore.CHECK_USER_EXISTS_BY_EMAIL

        val result = databaseClient.sql(sql)
            .bind(0, email)
            .map { row ->
                row.get("count", Int::class.java) == 1
            }
            .one()
            .awaitFirstOrNull()

        return result ?: false
    }

    override suspend fun getUserIdByEmail(email: String): Int {
        val sql = UserQueryStore.FIND_USER_ID_BY_EMAIL

        val result = databaseClient.sql(sql)
            .bind(0, email)
            .map {row ->
                row.get("id", Int::class.java)
            }
            .one()
            .awaitFirstOrNull()

        return result ?: -1
    }

    override suspend fun getUserIdAndPasswordHashWithEmail(email: String): UserIdAndPasswordHash {
        val sql = UserQueryStore.FIND_USER_ID_AND_PASSWORD_HASH_BY_EMAIL

        val userIdAndPasswordHash = databaseClient.sql(sql)
            .bind(0, email)
            .map { row ->
                UserIdAndPasswordHash(
                    row.get("id", Int::class.java) ?: -1,
                    row.get("password_hash", String::class.java) ?: ""
                )

            }
            .one()
            .awaitFirstOrNull()

        return userIdAndPasswordHash ?: UserIdAndPasswordHash(-1, "")
    }

    override suspend fun markUserEmailVerified(email: String): Boolean {
        val sql = UserQueryStore.MARK_USER_EMAIL_VERIFIED

        val result = databaseClient.sql(sql)
            .bind(0, email)
            .bind(1, true)
            .fetch()
            .awaitRowsUpdated()

        return result == 1L
    }

    override suspend fun fetchIsUserEmailVerified(email: String): Boolean {
        val sql = UserQueryStore.FIND_USER_EMAIL_VERIFIED

        val result = databaseClient.sql(sql)
            .bind(0, email)
            .map {row ->
                row.get("is_email_verified", Boolean::class.java)
            }
            .one()
            .awaitFirstOrNull()

        if (result != null) {
            return result
        }
        return false
    }


}
