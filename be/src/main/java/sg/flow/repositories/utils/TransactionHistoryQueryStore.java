package sg.flow.repositories.utils;

public class TransactionHistoryQueryStore {
        public static final String SAVE_TRANSACTION_HISTORY = "INSERT INTO transaction_histories " +
                        "(transaction_reference, account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status, friendly_description) "
                        +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        public static final String SAVE_TRANSACTION_HISTORY_WITH_ID = "INSERT INTO transaction_histories " +
                        "(id, transaction_reference, account_id, card_id, transaction_date, transaction_time, amount, transaction_type, description, transaction_status, friendly_description) "
                        +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        public static final String FIND_TRANSACTION_HISTORY_BY_ID = "SELECT th.id, " +
                        "th.transaction_reference, " +
                        "th.account_id, " +
                        "th.card_id, " +
                        "th.transaction_date, " +
                        "th.transaction_time, " +
                        "th.amount, " +
                        "th.transaction_type, " +
                        "th.description, " +
                        "th.transaction_status, " +
                        "th.friendly_description, " +
                        "acc.id AS account_id, " +
                        "acc.account_number AS account_number, " +
                        "acc.balance AS account_balance, " +
                        "acc.account_name AS account_name, " +
                        "acc.account_type AS account_type, " +
                        "acc.last_updated AS account_last_updated, " +
                        "b.id AS bank_id, " +
                        "b.bank_name AS bank_name, " +
                        "b.bank_code AS bank_code, " +
                        "c.id AS card_id, " +
                        "c.card_number, " +
                        "c.card_type " +
                        "FROM transaction_histories th " +
                        "JOIN accounts acc ON th.account_id = acc.id " +
                        "JOIN banks b ON acc.bank_id = b.id " +
                        "LEFT JOIN cards c ON th.card_id = c.id " +
                        "WHERE th.id = ?";

        public static final String DELETE_ALL_TRANSACTION_HISTORIES = "DELETE FROM transaction_histories";

        public static final String FIND_RECENT_TRANSACTION_HISTORY_BY_ACCOUNT_ID = "SELECT th.id, " +
                        "th.transaction_reference, " +
                        "th.account_id, " +
                        "th.card_id, " +
                        "th.transaction_date, " +
                        "th.transaction_time, " +
                        "th.amount, " +
                        "th.transaction_type, " +
                        "th.description, " +
                        "th.transaction_status, " +
                        "th.friendly_description, " +
                        "acc.id AS account_id, " +
                        "acc.account_number AS account_number, " +
                        "acc.balance AS account_balance, " +
                        "acc.account_name AS account_name, " +
                        "acc.account_type AS account_type, " +
                        "acc.last_updated AS account_last_updated, " +
                        "b.id AS bank_id, " +
                        "b.bank_name AS bank_name, " +
                        "b.bank_code AS bank_code " +
                        "FROM transaction_histories th " +
                        "JOIN accounts acc ON th.account_id = acc.id " +
                        "JOIN banks b ON acc.bank_id = b.id " +
                        "WHERE th.account_id = ? " +
                        "ORDER BY th.transaction_date DESC, th.transaction_time DESC " +
                        "LIMIT 30";
}
