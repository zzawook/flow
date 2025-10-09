package sg.flow.repositories.utils

object AccountQueryStore {
    const val FIND_CARD_ACCOUNTS =
        """
            SELECT a.id,
            a.account_name AS card_name,
            c.card_number,
            c.card_type,
            b.id as bank_id,
            b.bank_name,
            b.bank_code,
            b.finverse_id,
            b.countries,
            a.balance
            FROM cards c
            JOIN accounts a ON a.account_number = c.card_number
            JOIN banks b ON a.bank_id = b.id
            WHERE a.user_id = $1
        """
    const val SAVE_ACCOUNT =
            """
        INSERT INTO accounts 
        (account_number, bank_id, user_id, balance, account_name, account_type, last_updated, finverse_id) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8) ON CONFLICT (finverse_id) DO NOTHING RETURNING finverse_id
    """

    const val SAVE_ACCOUNT_WITH_ID =
            """
        INSERT INTO accounts 
        (id, account_number, bank_id, user_id, balance, account_name, account_type, last_updated, finverse_id) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) ON CONFLICT (finverse_id) DO NOTHING RETURNING finverse_id
    """

    const val FIND_ACCOUNT_BY_ID =
            """
        SELECT a.id, 
        a.account_number, 
        a.bank_id, 
        a.user_id, 
        a.balance, 
        a.account_name, 
        a.account_type, 
        a.interest_rate_per_annum,
        a.last_updated, 
        a.finverse_id,
        b.id AS bank_id, 
        b.bank_name, 
        b.bank_code, 
        u.id AS user_id, 
        u.name, 
        u.email, 
        u.identification_number, 
        u.phone_number, 
        u.date_of_birth, 
        u.address,
        u.setting_json,
        u.gender 
        FROM accounts a 
        JOIN banks b ON a.bank_id = b.id 
        JOIN users u ON a.user_id = u.id 
        WHERE a.id = $1
    """

    const val DELETE_ALL_ACCOUNTS = "DELETE FROM accounts"

    const val FIND_BRIEF_ACCOUNT_OF_USER =
            """
        SELECT a.id, 
        a.balance, 
        a.account_name,
        a.account_number,
        a.account_type,
        b.id AS bank_id, 
        b.bank_name, 
        b.bank_code
        FROM accounts a 
        JOIN banks b ON a.bank_id = b.id 
        WHERE a.user_id = $1
    """

    const val FIND_ACCOUNT_WITH_TRANSACTION_HISTORY_OF_USER =
            """
        SELECT a.id, 
        a.account_number, 
        a.user_id, 
        a.balance, 
        a.account_name, 
        a.interest_rate_per_annum, 
        a.account_type, 
        a.finverse_id,
        b.id AS bank_id, 
        b.bank_name, 
        b.bank_code 
        FROM accounts a 
        JOIN banks b ON a.bank_id = b.id 
        JOIN users u ON a.user_id = u.id 
        WHERE a.user_id = $1
    """;

    const val FIND_ACCOUNT_BY_FINVERSE_ID =
        """
        SELECT a.id, 
        a.account_number, 
        a.bank_id, 
        a.user_id, 
        a.balance, 
        a.account_name, 
        a.account_type, 
        a.interest_rate_per_annum,
        a.last_updated, 
        a.finverse_id,
        b.id AS bank_id, 
        b.bank_name, 
        b.bank_code,
        u.id AS user_id, 
        u.name, 
        u.email, 
        u.identification_number, 
        u.phone_number, 
        u.date_of_birth, 
        u.address,
        u.gender,
        u.setting_json 
        FROM accounts a 
        JOIN banks b ON a.bank_id = b.id 
        JOIN users u ON a.user_id = u.id 
        WHERE a.finverse_id = $1
    """
}
