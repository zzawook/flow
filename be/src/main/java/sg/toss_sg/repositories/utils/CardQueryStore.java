package sg.toss_sg.repositories.utils;

public class CardQueryStore {
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
}
