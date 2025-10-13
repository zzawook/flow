package sg.flow.repositories.utils

object LoginMemoQueryStore {
    const val GET_LOGIN_MEMO =
        """
            SELECT memo
            FROM login_memo l
            WHERE l.user_id = $1
            AND l.bank_id = $2
        """

    const val STORE_LOGIN_MEMO =
        """
            INSERT INTO login_memo (user_id, bank_id, memo)
            VALUES ($1, $2, $3)
            ON CONFLICT (user_id, bank_id) DO UPDATE SET
                memo = EXCLUDED.memo
        """
}