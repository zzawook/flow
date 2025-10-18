package sg.flow.repositories.utils

object SubscriptionEventQueryStore {
    const val CREATE =
            """
        INSERT INTO subscription_events (
            user_id, platform, event_type,
            old_status, new_status,
            notification_type, transaction_id,
            raw_notification, error_message,
            processed_at
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?::jsonb, ?, ?)
        RETURNING *
    """

    const val FIND_BY_USER_ID =
            """
        SELECT * FROM subscription_events 
        WHERE user_id = ? 
        ORDER BY processed_at DESC
        LIMIT ?
    """

    const val FIND_BY_PLATFORM =
            """
        SELECT * FROM subscription_events 
        WHERE platform = ? 
        ORDER BY processed_at DESC
        LIMIT ?
    """

    const val FIND_BY_EVENT_TYPE =
            """
        SELECT * FROM subscription_events 
        WHERE event_type = ? 
        ORDER BY processed_at DESC
        LIMIT ?
    """

    const val DELETE_ALL = """
        DELETE FROM subscription_events
    """
}
