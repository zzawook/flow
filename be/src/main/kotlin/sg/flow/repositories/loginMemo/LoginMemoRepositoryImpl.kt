package sg.flow.repositories.loginMemo

import kotlinx.coroutines.reactive.awaitFirstOrNull
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.repositories.utils.LoginMemoQueryStore

@Repository
class LoginMemoRepositoryImpl(
    private val databaseClient: DatabaseClient
) : LoginMemoRepository {
    val logger = LoggerFactory.getLogger(LoginMemoRepositoryImpl::class.java)
    override suspend fun getLoginMemo(userId: Int, institutionId: String): String {
        return runCatching {
            val sql = LoginMemoQueryStore.GET_LOGIN_MEMO
            val memo = databaseClient.sql(sql)
                .bind(0, userId)
                .bind(1, institutionId.toInt())
                .map { row ->
                    row.get("memo", String::class.java)
                }
                .one()
                .awaitFirstOrNull()
            memo ?: ""
        }.onFailure { e ->
            e.printStackTrace()
            logger.error("Error fetching login memo from DB for user $userId institution $institutionId")
        }
            .getOrElse { "" }
    }

    override suspend fun setLoginMemo(userId: Int, institutionId: String, memo: String): Boolean {
        return runCatching {
            val sql = LoginMemoQueryStore.STORE_LOGIN_MEMO
            val success = databaseClient.sql(sql)
                .bind(0, userId)
                .bind(1, institutionId.toInt())
                .bind(2, memo)
                .fetch()
                .awaitRowsUpdated() == 1L

            success
        }.onFailure { e ->
            e.printStackTrace()
            logger.error("Error while setting login memo: $memo for user ID $userId institution ID $institutionId")
        }.getOrElse { false }
    }

}