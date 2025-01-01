package sg.toss_sg.repositories.utils;

public class QueryStore {

    public static final String SAVE_USER = "INSERT INTO users " +
            "(name, email, identification_number, phone_number, date_of_birth, setting_json) " +
            "VALUES (?, ?, ?, ?, ?, ?::jsonb)";

    public static final String SAVE_USER_WITH_ID = "INSERT INTO users " +
            "(id, name, email, identification_number, phone_number, date_of_birth, setting_json) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?::jsonb)";

    public static final String FIND_USER_BY_ID = "SELECT u.id, " +
            "u.name, " +
            "u.email, " +
            "u.identification_number, " +
            "u.phone_number, " +
            "u.date_of_birth, " +
            "u.setting_json " +
            "FROM users u " +
            "WHERE u.id = ?";

    public static final String DELETE_ALL_USERS = "DELETE FROM users";

    public static final String SAVE_BANK = "INSERT INTO banks " +
            "(bank_name, bank_code) " +
            "VALUES (?, ?)";

    public static final String SAVE_BANK_WITH_ID = "INSERT INTO banks " +
            "(id, bank_name, bank_code) " +
            "VALUES (?, ?, ?)";

    public static final String FIND_BANK_BY_ID = "SELECT b.id, " +
            "b.bank_name, " +
            "b.bank_code " +
            "FROM banks b " +
            "WHERE b.id = ?";

    public static final String DELETE_ALL_BANKS = "DELETE FROM banks";

    public static final String SAVE_ACCOUNT = "INSERT INTO accounts " +
            "(account_number, bank_id, user_id, balance, account_name, account_type, last_updated) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

    public static final String SAVE_ACCOUNT_WITH_ID = "INSERT INTO accounts " +
            "(id, account_number, bank_id, user_id, balance, account_name, account_type, last_updated) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String FIND_ACCOUNT_BY_ID = "SELECT a.id, " +
            "a.account_number, " +
            "a.bank_id, " +
            "a.user_id, " +
            "a.balance, " +
            "a.account_name, " +
            "a.account_type, " +
            "a.last_updated, " +
            "b.id AS bank_id, " +
            "b.bank_name, " +
            "b.bank_code, " +
            "u.id AS user_id, " +
            "u.name, " +
            "u.email, " +
            "u.identification_number, " +
            "u.phone_number, " +
            "u.date_of_birth, " +
            "u.setting_json " +
            "FROM accounts a " +
            "JOIN banks b ON a.bank_id = b.id " +
            "JOIN users u ON a.user_id = u.id " +
            "WHERE a.id = ?";

    public static final String DELETE_ALL_ACCOUNTS = "DELETE FROM accounts";

    public static final String SAVE_CARD = "INSERT INTO cards " +
            "(owner_id, linked_account_id, issuing_bank_id, card_number, card_type, cvv, expiry_date, card_holder_name, pin, card_status, address_line_1, address_line_2, city, state, country, zip_code, phone, daily_limit, monthly_limit) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String SAVE_CARD_WITH_ID = "INSERT INTO cards " +
            "(id, owner_id, linked_account_id, issuing_bank_id, card_number, card_type, cvv, expiry_date, card_holder_name, pin, card_status, address_line_1, address_line_2, city, state, country, zip_code, phone, daily_limit, monthly_limit) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    public static final String FIND_CARD_BY_ID = "SELECT c.id, " +
            "c.owner_id, " +
            "c.linked_account_id, " +
            "c.issuing_bank_id, " +
            "c.card_number, " +
            "c.card_type, " +
            "c.cvv, " +
            "c.expiry_date, " +
            "c.card_holder_name, " +
            "c.pin, " +
            "c.card_status, " +
            "c.address_line_1, " +
            "c.address_line_2, " +
            "c.city, " +
            "c.state, " +
            "c.country, " +
            "c.zip_code, " +
            "c.phone, " +
            "c.daily_limit, " +
            "c.monthly_limit, " +
            "u.id AS user_id, " +
            "u.name, " +
            "u.email, " +
            "u.identification_number, " +
            "u.phone_number, " +
            "u.date_of_birth, " +
            "u.setting_json, " +
            "a.id AS account_id, " +
            "a.account_number, " +
            "a.balance, " +
            "a.account_name, " +
            "a.account_type, " +
            "a.last_updated, " +
            "b.id AS bank_id, " +
            "b.bank_name, " +
            "b.bank_code " +
            "FROM cards c " +
            "JOIN users u ON c.owner_id = u.id " +
            "JOIN accounts a ON c.linked_account_id = a.id " +
            "JOIN banks b ON c.issuing_bank_id = b.id " +
            "WHERE c.id = ?";

    public static final String DELETE_ALL_CARDS = "DELETE FROM cards";

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
