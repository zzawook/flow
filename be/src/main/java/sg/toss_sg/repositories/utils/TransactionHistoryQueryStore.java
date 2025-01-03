package sg.toss_sg.repositories.utils;

public class TransactionHistoryQueryStore {
    public static final String SAVE_TRANSACTION_HISTORY = "INSERT INTO transaction_histories " +
            "(account_id, to_account_id, from_account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String SAVE_TRANSACTION_HISTORY_WITH_ID = "INSERT INTO transaction_histories " +
            "(id, account_id, to_account_id, from_account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String FIND_TRANSACTION_HISTORY_BY_ID = "SELECT th.id, " +
            "th.account_id, " +
            "th.to_account_id, " +
            "th.from_account_id, " +
            "th.card_id, " +
            "th.transaction_date, " +
            "th.transaction_time, " +
            "th.amount, " +
            "th.transaction_type, " +
            "th.description, " +
            "th.transaction_status, " +
            "a.id AS account_id, " +
            "a.account_number, " +
            "a.balance, " +
            "a.account_name, " +
            "a.account_type, " +
            "a.last_updated, " +
            "u.id AS user_id, " +
            "u.name, " +
            "u.email, " +
            "u.identification_number, " +
            "u.phone_number, " +
            "u.date_of_birth, " +
            "u.setting_json, " +
            "b.id AS bank_id, " +
            "b.bank_name, " +
            "c.id AS card_id, " +
            "c.card_number, " +
            "c.card_type " +
            "FROM transaction_histories th " +
            "JOIN accounts a ON th.account_id = a.id " +
            "JOIN users u ON a.user_id = u.id " +
            "JOIN banks b ON a.bank_id = b.id " +
            "LEFT JOIN cards c ON th.card_id = c.id " +
            "WHERE th.id = ?";

    public static final String DELETE_ALL_TRANSACTION_HISTORIES = "DELETE FROM transaction_histories";
}
