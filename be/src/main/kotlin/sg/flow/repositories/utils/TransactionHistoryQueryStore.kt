package sg.flow.repositories.utils

object TransactionHistoryQueryStore {
    const val SAVE_TRANSACTION_HISTORY =
            """
        INSERT INTO transaction_histories 
        (transaction_reference, account_id, card_id, user_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status, friendly_description, finverse_id) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12) ON CONFLICT (finverse_id) DO NOTHING RETURNING finverse_id
    """

    const val SAVE_TRANSACTION_HISTORY_WITH_ID =
            """
        INSERT INTO transaction_histories 
        (id, transaction_reference, account_id, card_id, user_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status, friendly_description, finverse_id) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13)  ON CONFLICT (finverse_id) DO NOTHING RETURNING finverse_id
    """

    const val FIND_TRANSACTION_HISTORY_BY_ID =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.brand_name,
        th.brand_domain,
        th.is_included_in_spending_or_income,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated, 
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        c.id AS card_id, 
        c.card_number, 
        c.card_type 
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN banks b ON acc.bank_id = b.id 
        JOIN users u ON acc.user_id = u.id
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.id = $1
    """

    const val DELETE_ALL_TRANSACTION_HISTORIES = "DELETE FROM transaction_histories"

    const val FIND_RECENT_TRANSACTION_HISTORY_BY_ACCOUNT_ID =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.brand_name,
        th.brand_domain,
        th.is_included_in_spending_or_income,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated, 
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        c.id AS card_id, 
        c.card_number, 
        c.card_type 
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN banks b ON acc.bank_id = b.id 
        JOIN users u ON acc.user_id = u.id
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.account_id = $1 
        ORDER BY th.transaction_date DESC, th.transaction_time DESC 
        LIMIT 30
    """

    const val FIND_TRANSACTION_BETWEEN_DATES =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.revised_transaction_date,
        th.brand_name,
        th.brand_domain,
        th.is_included_in_spending_or_income,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated, 
        acc.finverse_id AS account_finverse_id,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        c.id AS card_id, 
        c.card_number, 
        c.card_type 
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN banks b ON acc.bank_id = b.id 
        JOIN users u ON acc.user_id = u.id
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.transaction_date BETWEEN $1 AND $2 AND acc.user_id = $3 
        ORDER BY th.transaction_date DESC, th.transaction_time DESC 
        LIMIT $4
    """

    const val FIND_TRANSACTION_DETAIL_BY_ID =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.is_included_in_spending_or_income,
        th.brand_name,
        th.brand_domain,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.id = $1
    """

    const val FIND_UNPROCESSED_TRANSACTIONS =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description,
        th.transaction_category,
        th.extracted_card_number,
        th.revised_transaction_date,
        th.brand_name,
        th.brand_domain,
        th.is_processed,
        is_included_in_spending_or_income,
        th.finverse_id,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        acc.finverse_id AS account_finverse_id,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.is_processed = false
        ORDER BY th.transaction_date DESC, th.transaction_time DESC
    """

    const val FIND_UNPROCESSED_TRANSACTIONS_BY_USER_ID =
            """
        SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description,
        th.transaction_category,
        th.extracted_card_number,
        th.revised_transaction_date,
        th.is_processed,
        is_included_in_spending_or_income,
        th.brand_name,
        th.brand_domain,
        th.finverse_id,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        acc.finverse_id AS account_finverse_id,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.is_processed = false AND u.id = $1
        ORDER BY th.transaction_date DESC, th.transaction_time DESC
    """

    const val UPDATE_TRANSACTION_ANALYSIS =
            """
        UPDATE transaction_histories
        SET
          transaction_category =
            CASE
              WHEN is_category_overridden_by_user IS FALSE THEN $2
              ELSE transaction_category
            END,
          friendly_description   = $3,
          extracted_card_number  = $4,
          brand_name             = $5,
          brand_domain           = $6,
          revised_transaction_date = $7,
          is_processed           = $8
        WHERE id = $1;
    """

    const val FIND_PROCESSED_TRANSACTIONS_BY_TRANSACTION_IDS =
        """
            SELECT th.id, 
            th.transaction_reference, 
            th.account_id, 
            th.card_id, 
            th.transaction_date, 
            th.transaction_time, 
            th.amount, 
            th.transaction_type, 
            th.description, 
            th.transaction_status, 
            th.friendly_description,
            th.transaction_category,
            th.extracted_card_number,
            th.revised_transaction_date,
            th.is_processed,
            th.brand_name,
            th.brand_domain,
            is_included_in_spending_or_income,
            th.finverse_id,
            acc.id AS account_id, 
            acc.account_number AS account_number, 
            acc.balance AS account_balance, 
            acc.account_name AS account_name, 
            acc.account_type AS account_type, 
            acc.last_updated AS account_last_updated,
            acc.finverse_id AS account_finverse_id,
            u.id AS user_id,
            u.name AS user_name,
            u.email AS email,
            u.identification_number AS identification_number,
            u.phone_number AS phone_number,
            u.date_of_birth AS date_of_birth,
            u.address AS address,
            u.setting_json AS setting_json,
            b.id AS bank_id, 
            b.bank_name AS bank_name, 
            b.bank_code AS bank_code, 
            c.id AS card_id, 
            c.card_number, 
            c.card_type
            FROM transaction_histories th 
            JOIN accounts acc ON th.account_id = acc.id 
            JOIN users u ON acc.user_id = u.id
            JOIN banks b ON acc.bank_id = b.id 
            LEFT JOIN cards c ON th.card_id = c.id 
            WHERE th.is_processed = true AND u.id = $1 AND th.id = ANY($2::bigint[])
            ORDER BY th.transaction_date DESC, th.transaction_time DESC
        """
const val FIND_TRANSACTIONS_FOR_USER_SINCE_DATE =
        """
            SELECT th.id,
                   th.transaction_reference,
                   th.account_id,
                   th.card_id,
                   th.transaction_date,
                   th.transaction_time,
                   th.amount,
                   th.transaction_type,
                   th.description,
                   th.transaction_status,
                   th.friendly_description,
                   th.transaction_category,
                   th.extracted_card_number,
                   th.revised_transaction_date,
                   th.is_processed,
                   th.brand_name,
                   th.brand_domain,
                   th.is_included_in_spending_or_income,
                   th.finverse_id,
                   acc.id AS account_id,
                   acc.account_number AS account_number,
                   acc.balance AS account_balance,
                   acc.account_name AS account_name,
                   acc.account_type AS account_type,
                   acc.last_updated AS account_last_updated,
                   acc.finverse_id AS account_finverse_id,
                   u.id AS user_id,
                   u.name AS user_name,
                   u.email AS email,
                   u.identification_number AS identification_number,
                   u.phone_number AS phone_number,
                   u.date_of_birth AS date_of_birth,
                   u.address AS address,
                   u.setting_json AS setting_json,
                   b.id AS bank_id,
                   b.bank_name AS bank_name,
                   b.bank_code AS bank_code,
                   c.id AS card_id,
                   c.card_number,
                   c.card_type
            FROM transaction_histories th
            JOIN accounts acc ON th.account_id = acc.id
            JOIN users u ON acc.user_id = u.id
            JOIN banks b ON acc.bank_id = b.id
            LEFT JOIN cards c ON th.card_id = c.id
            WHERE acc.user_id = $1 AND th.transaction_date >= $2
            ORDER BY th.transaction_date DESC, th.transaction_time DESC
        """

    const val SET_TRANSACTION_CATEGORY =
        """
            UPDATE transaction_histories
            SET transaction_category = $3, is_category_overridden_by_user = true 
            WHERE user_id = $1 AND id = $2
        """

    const val SET_TRANSACTION_INCLUSION =
        """
            UPDATE transaction_histories
            SET is_included_in_spending_or_income = $3
            WHERE user_id = $1 AND id = $2
        """

    const val FIND_TRANSACTIONS_FOR_ACCOUNT_AFTER =
        """
            SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.revised_transaction_date,
        th.is_included_in_spending_or_income,
        th.brand_name,
        th.brand_domain,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        acc.finverse_id AS account_finverse_id,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.user_id = $1 
            AND th.transaction_date >= (SELECT th2.transaction_date FROM transaction_histories th2 WHERE th2.id=$2) 
            AND b.id = $3 
            AND acc.account_number = $4 
        ORDER BY th.transaction_date 
        LIMIT $5
        """

    const val FIND_TRANSACTIONS_FOR_ACCOUNT_BEGINNING =
        """
            SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.revised_transaction_date,
        th.is_included_in_spending_or_income,
        th.brand_name,
        th.brand_domain,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        acc.finverse_id AS account_finverse_id,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.user_id = $1  
            AND b.id = $2 
            AND acc.account_number = $3 
        ORDER BY th.transaction_date 
        LIMIT $4
        """

    const val FIND_TRANSACTIONS_FOR_CARD_NUMBER =
        """
            SELECT th.id, 
        th.transaction_reference, 
        th.account_id, 
        th.card_id, 
        th.transaction_date, 
        th.transaction_time, 
        th.amount, 
        th.transaction_type, 
        th.description, 
        th.transaction_status, 
        th.friendly_description, 
        th.transaction_category,
        th.revised_transaction_date,
        th.is_included_in_spending_or_income,
        th.brand_name,
        th.brand_domain,
        acc.id AS account_id, 
        acc.account_number AS account_number, 
        acc.balance AS account_balance, 
        acc.account_name AS account_name, 
        acc.account_type AS account_type, 
        acc.last_updated AS account_last_updated,
        acc.finverse_id AS account_finverse_id,
        u.id AS user_id,
        u.name AS user_name,
        u.email AS email,
        u.identification_number AS identification_number,
        u.phone_number AS phone_number,
        u.date_of_birth AS date_of_birth,
        u.address AS address,
        u.setting_json AS setting_json,
        b.id AS bank_id, 
        b.bank_name AS bank_name, 
        b.bank_code AS bank_code, 
        c.id AS card_id, 
        c.card_number, 
        c.card_type
        FROM transaction_histories th 
        JOIN accounts acc ON th.account_id = acc.id 
        JOIN users u ON acc.user_id = u.id
        JOIN banks b ON acc.bank_id = b.id 
        LEFT JOIN cards c ON th.card_id = c.id 
        WHERE th.user_id = $1  
            AND acc.account_number = $2 
        ORDER BY th.transaction_date 
        LIMIT $4
        """
}
