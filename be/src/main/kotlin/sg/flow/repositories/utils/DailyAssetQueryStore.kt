package sg.flow.repositories.utils

object DailyAssetQueryStore {

    /**
     * Calculate and upsert daily assets for all users for a specific date. This efficiently
     * calculates total asset value from all accounts (including cards) for all users in a single
     * query.
     */
    const val CALCULATE_AND_UPSERT_DAILY_ASSETS_FOR_DATE =
            """
        INSERT INTO daily_user_assets (user_id, asset_date, total_asset_value, account_count, calculated_at)
        SELECT 
            a.user_id,
            $1::date AS asset_date,
            COALESCE(SUM(a.balance), 0) AS total_asset_value,
            COUNT(a.id) AS account_count,
            NOW() AS calculated_at
        FROM accounts a
        WHERE a.user_id IN (SELECT id FROM users)
        GROUP BY a.user_id
        ON CONFLICT (user_id, asset_date) 
        DO UPDATE SET
            total_asset_value = EXCLUDED.total_asset_value,
            account_count = EXCLUDED.account_count,
            calculated_at = NOW()
    """

    /** Find asset value for a specific user and date */
    const val FIND_BY_USER_AND_DATE =
            """
        SELECT id, user_id, asset_date, total_asset_value, account_count, calculated_at
        FROM daily_user_assets
        WHERE user_id = $1 AND asset_date = $2
    """

    /** Find asset values for a specific user within a date range (inclusive) */
    const val FIND_BY_USER_AND_DATE_RANGE =
            """
        SELECT id, user_id, asset_date, total_asset_value, account_count, calculated_at
        FROM daily_user_assets
        WHERE user_id = $1 
          AND asset_date >= $2 
          AND asset_date <= $3
        ORDER BY asset_date DESC
    """

    /** Find users that are missing asset data for a specific date */
    const val FIND_USERS_MISSING_ASSETS_FOR_DATE =
            """
        SELECT u.id 
        FROM users u
        WHERE NOT EXISTS (
            SELECT 1 
            FROM daily_user_assets dua 
            WHERE dua.user_id = u.id 
              AND dua.asset_date = $1
        )
    """
}
