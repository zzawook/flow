package sg.flow.repositories.utils

object TrialTrackingQueryStore {
    const val FIND_BY_EMAIL =
            """
        SELECT * FROM trial_usage_tracking 
        WHERE email = ?
    """

    const val FIND_BY_USER_ID =
            """
        SELECT * FROM trial_usage_tracking 
        WHERE user_id = ?
    """

    const val CHECK_EMAIL_EXISTS =
            """
        SELECT COUNT(*) as count FROM trial_usage_tracking 
        WHERE email = ?
    """

    const val CREATE =
            """
        INSERT INTO trial_usage_tracking 
        (email, platform, first_trial_started_at, user_id, created_at)
        VALUES (?, ?, ?, ?, ?)
        ON CONFLICT (email) DO NOTHING
        RETURNING *
    """

    const val DELETE_ALL = """
        DELETE FROM trial_usage_tracking
    """
}
