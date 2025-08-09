package sg.flow.repositories.loginIdentity

import kotlinx.coroutines.reactive.asFlow
import kotlinx.coroutines.reactor.awaitSingleOrNull
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.models.finverse.LoginIdentity
import sg.flow.repositories.utils.LoginIdentityQueryStore
import kotlin.math.log

@Repository
class LoginIdentityRepositoryImpl(private val databaseClient: DatabaseClient) : LoginIdentityRepository {

    private val logger = LoggerFactory.getLogger(LoginIdentityRepositoryImpl::class.java)

    override suspend fun saveOrUpdateLoginIdentity(loginIdentity: LoginIdentity) {
        var i = 0
        var spec = databaseClient.sql(LoginIdentityQueryStore.SAVE_LOGIN_IDENTITY)

        spec = spec.bind(i++, loginIdentity.userId)
                .bind(i++, loginIdentity.finverseInstitutionId)
                .bind(i++, loginIdentity.loginIdentityId)
                .bind(i++, loginIdentity.loginIdentityRefreshToken)
                .bind(i++, loginIdentity.refreshAllowed)

        runCatching {
            val rows = spec.fetch().awaitRowsUpdated()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error saving login identity for $loginIdentity")
                throw e
            }

    }

    override suspend fun updateLoginIdentity(newLoginIdentity: LoginIdentity) {

        var i = 0
        var spec = databaseClient.sql(LoginIdentityQueryStore.UPDATE_LOGIN_IDENTITY)

        spec = spec.bind(i++, newLoginIdentity.loginIdentityId)
            .bind(i++, newLoginIdentity.loginIdentityRefreshToken)
            .bind(i++, newLoginIdentity.userId)
            .bind(i++, newLoginIdentity.finverseInstitutionId)
            .bind(i++, newLoginIdentity.refreshAllowed)
        runCatching {
            val rows = spec.fetch().awaitRowsUpdated()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while updating login identity $newLoginIdentity")
                throw e
            }
    }

    override suspend fun updateLoginIdentity(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityRefreshToken: String,
        refreshAllowed: Boolean
    ) {
        var i = 0
        val spec = databaseClient.sql(LoginIdentityQueryStore.UPDATE_LOGIN_IDENTITY)
            .bind(i++, loginIdentityId)
            .bind(i++, loginIdentityRefreshToken)
            .bind(i++, userId)
            .bind(i++, institutionId)
            .bind(i++, refreshAllowed)

        runCatching {
            val rows = spec.fetch().awaitRowsUpdated()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while updating login identity: LoginIdentityId: $loginIdentityId, User Id: $userId, Institution Id: $institutionId")
                throw e
            }
    }

    override suspend fun deleteLoginIdentity(loginIdentity: LoginIdentity) {

        var i = 0
        var spec = databaseClient.sql(LoginIdentityQueryStore.DELETE_LOGIN_IDENTITY)

        spec = spec
            .bind(i++, loginIdentity.userId)
            .bind(i++, loginIdentity.finverseInstitutionId)

        runCatching {
            val rows = spec.fetch().awaitRowsUpdated()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while deleting login identity $loginIdentity")
                throw e
            }
    }

    override suspend fun deleteLoginIdentity(userId: Int, institutionId: String) {
        var i = 0
        var spec = databaseClient.sql(LoginIdentityQueryStore.DELETE_LOGIN_IDENTITY)

        spec = spec
            .bind(i++, userId)
            .bind(i++, institutionId)

        runCatching {
            val rows = spec.fetch().awaitRowsUpdated()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while deleting login identity: User ID: $userId, Institution ID: $institutionId")
                throw e
            }
    }

    override suspend fun getLoginIdentity(
        userId: Int,
        institutionId: String
    ): LoginIdentity? {
        return runCatching {
            databaseClient.sql(LoginIdentityQueryStore.GET_LOGIN_IDENTITY_WITH_USERID_AND_FINVERSE_INSTITUTION_ID)
                .bind(0, userId)
                .bind(1, institutionId)
                .map { row ->
                    LoginIdentity(
                        userId = row.get("user_id", Int::class.java)!!,
                        finverseInstitutionId = row.get("finverse_institution_id", String::class.java)!!,
                        loginIdentityId = row.get("login_identity_id", String::class.java)!!,
                        loginIdentityRefreshToken = row.get("login_identity_refresh_token", String::class.java)!!,
                        refreshAllowed = row.get("refresh_allowed", Boolean::class.java)!!
                    )
                }
                .one()
                .awaitSingleOrNull()
            }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while fetching login identity: User ID: $userId, Institution ID: $institutionId")
                throw e
            }
            .getOrNull()
    }

    override suspend fun getLoginIdentity(loginIdentityId: String): LoginIdentity? {
        return runCatching {
            databaseClient.sql(LoginIdentityQueryStore.GET_LOGIN_IDENTITY_WITH_LOGIN_IDENTITY_ID)
                .bind(0, loginIdentityId)
                .map { row ->
                    LoginIdentity(
                        userId = row.get("user_id", Int::class.java)!!,
                        finverseInstitutionId = row.get("finverse_institution_id", String::class.java)!!,
                        loginIdentityId = row.get("login_identity_id", String::class.java)!!,
                        loginIdentityRefreshToken = row.get("login_identity_refresh_token", String::class.java)!!,
                        refreshAllowed = row.get("refresh_allowed", Boolean::class.java)!!
                    )
                }
                .one()
                .awaitSingleOrNull()
        }
            .onFailure { e ->
                e.printStackTrace()
                logger.error("Error while fetching login identity: Login Identity ID: $loginIdentityId")
                throw e
            }
            .getOrNull()
    }

}