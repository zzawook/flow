package sg.flow.repositories.utils

object SpendingMedianQueryStore {

    const val FIND_BY_AGE_GROUP_AND_YEAR_MONTH =
            """
        SELECT id, age_group, year, month, median_spending, user_count, transaction_count, calculated_at
        FROM spending_medians_by_age_group
        WHERE age_group = $1 AND year = $2 AND month = $3
    """

    const val UPSERT_MEDIAN =
            """
        INSERT INTO spending_medians_by_age_group (
            age_group, year, month, median_spending, user_count, transaction_count, calculated_at
        ) VALUES ($1, $2, $3, $4, $5, $6, NOW())
        ON CONFLICT (age_group, year, month)
        DO UPDATE SET
            median_spending = EXCLUDED.median_spending,
            user_count = EXCLUDED.user_count,
            transaction_count = EXCLUDED.transaction_count,
            calculated_at = NOW()
    """

    // Query to find missing months that need to be calculated
    // Generates a series of year-month pairs and finds which ones are missing from the table
    const val FIND_MISSING_MONTHS =
            """
        WITH RECURSIVE month_series AS (
            SELECT $1 AS year, $2 AS month
            UNION ALL
            SELECT 
                CASE WHEN month = 12 THEN year + 1 ELSE year END AS year,
                CASE WHEN month = 12 THEN 1 ELSE month + 1 END AS month
            FROM month_series
            WHERE (year * 12 + month) < ($3 * 12 + $4)
        ),
        existing_months AS (
            SELECT DISTINCT year, month
            FROM spending_medians_by_age_group
        )
        SELECT ms.year, ms.month
        FROM month_series ms
        LEFT JOIN existing_months em ON ms.year = em.year AND ms.month = em.month
        WHERE em.year IS NULL
        ORDER BY ms.year, ms.month
    """

    /**
     * Complex query to calculate spending medians by age group for a specific month.
     *
     * Logic:
     * 1. Calculate user ages based on date_of_birth in SGT timezone
     * 2. Group users into age groups (0s, 10s, 20s, ..., 150s)
     * 3. Sum spending per user for the specified month (only negative amounts, is_included = true)
     * 4. Calculate median of user spending totals within each age group using PERCENTILE_CONT
     * 5. Return as positive values for better UX
     */
    const val CALCULATE_MEDIANS_FOR_MONTH =
            """
        WITH user_ages AS (
            SELECT 
                id AS user_id,
                LEAST(
                    FLOOR(
                        EXTRACT(YEAR FROM AGE(
                            (NOW() AT TIME ZONE 'Asia/Singapore')::date, 
                            date_of_birth
                        )) / 10
                    ) * 10,
                    150
                ) AS age_group_num
            FROM users
            WHERE date_of_birth IS NOT NULL
        ),
        user_spending AS (
            SELECT 
                ua.age_group_num,
                th.user_id,
                ABS(SUM(th.amount)) AS total_spending,
                COUNT(th.id) AS tx_count
            FROM transaction_histories th
            JOIN user_ages ua ON th.user_id = ua.user_id
            WHERE 
                EXTRACT(YEAR FROM th.transaction_date) = $1
                AND EXTRACT(MONTH FROM th.transaction_date) = $2
                AND th.is_included_in_spending_or_income = true
                AND th.amount < 0
            GROUP BY ua.age_group_num, th.user_id
        ),
        age_group_stats AS (
            SELECT 
                age_group_num,
                PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_spending) AS median_spending,
                COUNT(DISTINCT user_id) AS user_count,
                SUM(tx_count) AS transaction_count
            FROM user_spending
            GROUP BY age_group_num
        )
        SELECT 
            age_group_num || 's' AS age_group,
            COALESCE(median_spending, 0.0) AS median_spending,
            user_count,
            transaction_count
        FROM age_group_stats
        ORDER BY age_group_num
    """
}
