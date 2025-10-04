package sg.flow.repositories.utils

object RecurringSpendingQueryStore {
    const val UPSERT_RECURRING_SPENDING_MONTHLY =
            """
        INSERT INTO recurring_spending_monthly (
            user_id, merchant_key, sequence_key, display_name, brand_name, category, year, month,
            expected_amount, amount_stddev, occurrence_count, last_transaction_date,
            interval_days, period_label, next_transaction_date, confidence, transaction_ids, brand_domain, created_at, updated_at
        ) VALUES (
            $1, $2, $3, $4, $5, $6, $7, $8,
            $9, $10, $11, $12,
            $13, $14, $15, $16, $17, $18, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        )
        ON CONFLICT (user_id, merchant_key, sequence_key, year, month) DO UPDATE SET
            display_name = EXCLUDED.display_name,
            brand_name = EXCLUDED.brand_name,
            brand_domain = EXCLUDED.brand_domain,
            category = EXCLUDED.category,
            expected_amount = EXCLUDED.expected_amount,
            amount_stddev = EXCLUDED.amount_stddev,
            occurrence_count = EXCLUDED.occurrence_count,
            last_transaction_date = EXCLUDED.last_transaction_date,
            interval_days = EXCLUDED.interval_days,
            period_label = EXCLUDED.period_label,
            next_transaction_date = EXCLUDED.next_transaction_date,
            confidence = EXCLUDED.confidence,
            transaction_ids = EXCLUDED.transaction_ids,
            updated_at = CURRENT_TIMESTAMP
        """

    const val DELETE_FOR_USER_MONTH_RANGE =
            """
        DELETE FROM recurring_spending_monthly
        WHERE user_id = $1 AND (year > $2 OR (year = $2 AND month >= $3))
      """

    const val FIND_RECURRING_TRANSACTIONS_FOR_USER =
        """
            SELECT r.id,
            r.user_id,
            r.merchant_key,
            r.sequence_key,
            r.display_name,
            r.brand_name,
            r.brand_domain,
            r.category,
            r.year,
            r.month,
            r.expected_amount,
            r.amount_stddev,
            r.occurrence_count,
            r.last_transaction_date,
            r.interval_days,
            r.period_label,
            r.next_transaction_date,
            r.confidence,
            r.transaction_ids,
            r.updated_at
            FROM recurring_spending_monthly
            WHERE r.user_id = $1
        """
}