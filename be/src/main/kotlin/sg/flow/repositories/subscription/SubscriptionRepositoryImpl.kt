package sg.flow.repositories.subscription

import java.time.Instant
import kotlinx.coroutines.reactive.awaitFirstOrNull
import kotlinx.coroutines.reactive.awaitSingle
import org.slf4j.LoggerFactory
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.r2dbc.core.awaitRowsUpdated
import org.springframework.stereotype.Repository
import sg.flow.entities.UserSubscription
import sg.flow.entities.utils.Platform
import sg.flow.entities.utils.SubscriptionStatus
import sg.flow.repositories.utils.SubscriptionQueryStore

@Repository
class SubscriptionRepositoryImpl(private val databaseClient: DatabaseClient) :
        SubscriptionRepository {

    private val logger = LoggerFactory.getLogger(SubscriptionRepositoryImpl::class.java)

    override suspend fun findByUserIdAndPlatform(
            userId: Int,
            platform: Platform
    ): UserSubscription? {
        return databaseClient
                .sql(SubscriptionQueryStore.FIND_BY_USER_ID_AND_PLATFORM)
                .bind(0, userId)
                .bind(1, platform.name)
                .map { row, _ -> mapRowToSubscription(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun findByUserId(userId: Int): List<UserSubscription> {
        return databaseClient
                .sql(SubscriptionQueryStore.FIND_BY_USER_ID)
                .bind(0, userId)
                .map { row, _ -> mapRowToSubscription(row) }
                .all()
                .collectList()
                .awaitSingle()
    }

    override suspend fun findById(id: Long): UserSubscription? {
        return databaseClient
                .sql(SubscriptionQueryStore.FIND_BY_ID)
                .bind(0, id)
                .map { row, _ -> mapRowToSubscription(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun findByIosTransactionId(transactionId: String): UserSubscription? {
        return databaseClient
                .sql(SubscriptionQueryStore.FIND_BY_IOS_TRANSACTION_ID)
                .bind(0, transactionId)
                .map { row, _ -> mapRowToSubscription(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun findByAndroidPurchaseToken(purchaseToken: String): UserSubscription? {
        return databaseClient
                .sql(SubscriptionQueryStore.FIND_BY_ANDROID_PURCHASE_TOKEN)
                .bind(0, purchaseToken)
                .map { row, _ -> mapRowToSubscription(row) }
                .one()
                .awaitFirstOrNull()
    }

    override suspend fun save(entity: UserSubscription): UserSubscription {
        return databaseClient
                .sql(SubscriptionQueryStore.CREATE)
                .bind(0, entity.userId)
                .bind(1, entity.platform.name)
                .bind(2, entity.subscriptionStatus.name)
                .bindNullable(3, entity.trialStartDate)
                .bindNullable(4, entity.trialEndDate)
                .bindNullable(5, entity.currentPeriodStart)
                .bindNullable(6, entity.currentPeriodEnd)
                .bind(7, entity.autoRenewing)
                .bindNullable(8, entity.expiredAt)
                .bindNullable(9, entity.expirationReason)
                .bindNullable(10, entity.canceledAt)
                .bindNullable(11, entity.cancellationReason)
                .bindNullable(12, entity.iosOriginalTransactionId)
                .bindNullable(13, entity.iosProductId)
                .bindNullable(14, entity.iosEnvironment)
                .bindNullable(15, entity.androidPurchaseToken)
                .bindNullable(16, entity.androidProductId)
                .bindNullable(17, entity.androidOrderId)
                .bind(18, entity.createdAt)
                .bind(19, Instant.now())
                .map { row, _ -> mapRowToSubscription(row) }
                .one()
                .awaitSingle()
    }

    override suspend fun updateSubscription(subscription: UserSubscription): Boolean {
        return try {
            val rowsUpdated =
                    databaseClient
                            .sql(SubscriptionQueryStore.UPDATE)
                            .bind(0, subscription.subscriptionStatus.name)
                            .bindNullable(1, subscription.trialStartDate)
                            .bindNullable(2, subscription.trialEndDate)
                            .bindNullable(3, subscription.currentPeriodStart)
                            .bindNullable(4, subscription.currentPeriodEnd)
                            .bind(5, subscription.autoRenewing)
                            .bindNullable(6, subscription.expiredAt)
                            .bindNullable(7, subscription.expirationReason)
                            .bindNullable(8, subscription.canceledAt)
                            .bindNullable(9, subscription.cancellationReason)
                            .bindNullable(10, subscription.iosOriginalTransactionId)
                            .bindNullable(11, subscription.iosProductId)
                            .bindNullable(12, subscription.iosEnvironment)
                            .bindNullable(13, subscription.androidPurchaseToken)
                            .bindNullable(14, subscription.androidProductId)
                            .bindNullable(15, subscription.androidOrderId)
                            .bind(16, Instant.now())
                            .bind(17, subscription.id!!)
                            .fetch()
                            .awaitRowsUpdated()

            rowsUpdated > 0
        } catch (e: Exception) {
            logger.error("Failed to update subscription: ${subscription.id}", e)
            false
        }
    }

    override suspend fun updateStatus(subscriptionId: Long, newStatus: String): Boolean {
        return try {
            val rowsUpdated =
                    databaseClient
                            .sql(SubscriptionQueryStore.UPDATE_STATUS)
                            .bind(0, newStatus)
                            .bind(1, Instant.now())
                            .bind(2, subscriptionId)
                            .fetch()
                            .awaitRowsUpdated()

            rowsUpdated > 0
        } catch (e: Exception) {
            logger.error("Failed to update subscription status: $subscriptionId", e)
            false
        }
    }

    override suspend fun deleteAll(): Boolean {
        return try {
            databaseClient.sql(SubscriptionQueryStore.DELETE_ALL).fetch().awaitRowsUpdated()
            true
        } catch (e: Exception) {
            logger.error("Failed to delete all subscriptions", e)
            false
        }
    }

    private fun mapRowToSubscription(row: io.r2dbc.spi.Row): UserSubscription {
        return UserSubscription(
                id = row.get("id", java.lang.Long::class.java)?.toLong(),
                userId = row.get("user_id", Integer::class.java)!!.toInt(),
                platform = Platform.valueOf(row.get("platform", String::class.java)!!),
                subscriptionStatus =
                        SubscriptionStatus.valueOf(
                                row.get("subscription_status", String::class.java)!!
                        ),
                trialStartDate = row.get("trial_start_date", Instant::class.java),
                trialEndDate = row.get("trial_end_date", Instant::class.java),
                currentPeriodStart = row.get("current_period_start", Instant::class.java),
                currentPeriodEnd = row.get("current_period_end", Instant::class.java),
                autoRenewing =
                        row.get("auto_renewing", java.lang.Boolean::class.java)?.booleanValue()
                                ?: true,
                expiredAt = row.get("expired_at", Instant::class.java),
                expirationReason = row.get("expiration_reason", String::class.java),
                canceledAt = row.get("canceled_at", Instant::class.java),
                cancellationReason = row.get("cancellation_reason", String::class.java),
                iosOriginalTransactionId =
                        row.get("ios_original_transaction_id", String::class.java),
                iosProductId = row.get("ios_product_id", String::class.java),
                iosEnvironment = row.get("ios_environment", String::class.java),
                androidPurchaseToken = row.get("android_purchase_token", String::class.java),
                androidProductId = row.get("android_product_id", String::class.java),
                androidOrderId = row.get("android_order_id", String::class.java),
                createdAt = row.get("created_at", Instant::class.java) ?: Instant.now(),
                updatedAt = row.get("updated_at", Instant::class.java) ?: Instant.now()
        )
    }

    private fun <T : Any> DatabaseClient.GenericExecuteSpec.bindNullable(
            index: Int,
            value: T?
    ): DatabaseClient.GenericExecuteSpec {
        return if (value == null) {
            this.bindNull(index, value?.javaClass ?: Any::class.java)
        } else {
            this.bind(index, value)
        }
    }
}
