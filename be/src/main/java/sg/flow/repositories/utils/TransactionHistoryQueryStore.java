package sg.flow.repositories.utils;

public class TransactionHistoryQueryStore {
        public static final String SAVE_TRANSACTION_HISTORY = "INSERT INTO transaction_histories " +
                        "(to_account_id, from_account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status) "
                        +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        public static final String SAVE_TRANSACTION_HISTORY_WITH_ID = "INSERT INTO transaction_histories " +
                        "(id, to_account_id, from_account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status) "
                        +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        public static final String FIND_TRANSACTION_HISTORY_BY_ID = "SELECT th.id, " +
                        "th.to_account_id, " +
                        "th.from_account_id, " +
                        "th.card_id, " +
                        "th.transaction_date, " +
                        "th.transaction_time, " +
                        "th.amount, " +
                        "th.transaction_type, " +
                        "th.description, " +
                        "th.transaction_status, " +
                        "to_acc.id AS to_account_id, " +
                        "to_acc.account_number AS to_account_number, " +
                        "to_acc.balance AS to_account_balance, " +
                        "to_acc.account_name AS to_account_name, " +
                        "to_acc.account_type AS to_account_type, " +
                        "to_acc.last_updated AS to_account_last_updated, " +
                        "from_acc.id AS from_account_id, " +
                        "from_acc.account_number AS from_account_number, " +
                        "from_acc.balance AS from_account_balance, " +
                        "from_acc.account_name AS from_account_name, " +
                        "from_acc.account_type AS from_account_type, " +
                        "from_acc.last_updated AS from_account_last_updated, " +
                        "b_to.id AS to_bank_id, " +
                        "b_to.bank_name AS to_bank_name, " +
                        "b_from.id AS from_bank_id, " +
                        "b_from.bank_name AS from_bank_name, " +
                        "c.id AS card_id, " +
                        "c.card_number, " +
                        "c.card_type " +
                        "FROM transaction_histories th " +
                        "JOIN accounts to_acc ON th.to_account_id = to_acc.id " +
                        "JOIN accounts from_acc ON th.from_account_id = from_acc.id " +
                        "JOIN banks b_to ON to_acc.bank_id = b_to.id " +
                        "JOIN banks b_from ON from_acc.bank_id = b_from.id " +
                        "LEFT JOIN cards c ON th.card_id = c.id " +
                        "WHERE th.id = ?";

        public static final String DELETE_ALL_TRANSACTION_HISTORIES = "DELETE FROM transaction_histories";

        public static final String FIND_RECENT_TRANSACTION_HISTORY_DETAIL_OF_ACCOUNT = "SELECT th.id, " +
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
                        "WHERE a.id = ? " +
                        "ORDER BY th.transaction_date DESC, th.transaction_time DESC " +
                        "LIMIT 5";
}
