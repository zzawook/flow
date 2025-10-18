package sg.flow.repositories.utils

object SubscriptionQueryStore {
    const val FIND_BY_USER_ID_AND_PLATFORM =
            """
        SELECT * FROM user_subscriptions 
        WHERE user_id = ? AND platform = ?
    """

    const val FIND_BY_USER_ID =
            """
        SELECT * FROM user_subscriptions 
        WHERE user_id = ?
    """

    const val FIND_BY_ID =
            """
        SELECT * FROM user_subscriptions 
        WHERE id = ?
    """

    const val FIND_BY_IOS_TRANSACTION_ID =
            """
        SELECT * FROM user_subscriptions 
        WHERE ios_original_transaction_id = ?
    """

    const val FIND_BY_ANDROID_PURCHASE_TOKEN =
            """
        SELECT * FROM user_subscriptions 
        WHERE android_purchase_token = ?
    """

    const val CREATE =
            """
        INSERT INTO user_subscriptions (
            user_id, platform, subscription_status,
            trial_start_date, trial_end_date,
            current_period_start, current_period_end, auto_renewing,
            expired_at, expiration_reason,
            canceled_at, cancellation_reason,
            ios_original_transaction_id, ios_product_id, ios_environment,
            android_purchase_token, android_product_id, android_order_id,
            created_at, updated_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        RETURNING *
    """

    const val UPDATE =
            """
        UPDATE user_subscriptions SET
            subscription_status = ?,
            trial_start_date = ?,
            trial_end_date = ?,
            current_period_start = ?,
            current_period_end = ?,
            auto_renewing = ?,
            expired_at = ?,
            expiration_reason = ?,
            canceled_at = ?,
            cancellation_reason = ?,
            ios_original_transaction_id = ?,
            ios_product_id = ?,
            ios_environment = ?,
            android_purchase_token = ?,
            android_product_id = ?,
            android_order_id = ?,
            updated_at = ?
        WHERE id = ?
    """

    const val UPDATE_STATUS =
            """
        UPDATE user_subscriptions SET
            subscription_status = ?,
            updated_at = ?
        WHERE id = ?
    """

    const val DELETE_ALL = """
        DELETE FROM user_subscriptions
    """
}
