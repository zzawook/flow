package sg.flow.repositories.utils

object BankQueryStore {
    const val SAVE_BANK = """
        INSERT INTO banks 
        (bank_name, bank_code) 
        VALUES (?, ?)
    """

    const val SAVE_BANK_WITH_ID = """
        INSERT INTO banks 
        (id, bank_name, bank_code) 
        VALUES (?, ?, ?)
    """

    const val FIND_BANK_BY_ID = """
        SELECT b.id, 
        b.bank_name, 
        b.bank_code 
        FROM banks b 
        WHERE b.id = ?
    """

    const val DELETE_ALL_BANKS = "DELETE FROM banks"
} 