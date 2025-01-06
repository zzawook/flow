package sg.flow.repositories.utils;

public class AccountQueryStore {
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

        public static final String FIND_BRIEF_ACCOUNT_OF_USER = "SELECT a.id, " +
                        "a.balance, " +
                        "a.account_name, " +
                        "b.id AS bank_id, " +
                        "b.bank_name, " +
                        "b.bank_code " +
                        "FROM accounts a " +
                        "JOIN banks b ON a.bank_id = b.id " +
                        "WHERE a.user_id = ?";

        public static final String FIND_ACCOUNT_WITH_TRANSACTION_HISTORY_OF_USER = "SELECT a.id, " +
                        "a.account_number, " +
                        "a.user_id, " +
                        "a.balance, " +
                        "a.account_name, " +
                        "a.interest_rate_per_annum, " +
                        "a.account_type, " +
                        "b.id AS bank_id, " +
                        "b.bank_name, " +
                        "b.bank_code " +
                        "FROM accounts a " +
                        "JOIN banks b ON a.bank_id = b.id " +
                        "JOIN users u ON a.user_id = u.id " +
                        "WHERE a.user_id = ?";
}
