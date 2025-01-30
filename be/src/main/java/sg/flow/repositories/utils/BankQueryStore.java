package sg.flow.repositories.utils;

public class BankQueryStore {
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
}
