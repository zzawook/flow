package sg.flow.repositories.utils

object BankQueryStore {
    const val SAVE_BANK =
            """
        INSERT INTO banks 
        (bank_name, bank_code) 
        VALUES ($1, $2)
    """

    const val SAVE_BANK_WITH_ID =
            """
        INSERT INTO banks 
        (id, bank_name, bank_code) 
        VALUES ($1, $2, $3)
    """

    const val FIND_BANK_BY_ID =
            """
        SELECT b.id, 
        b.bank_name, 
        b.bank_code 
        FROM banks b 
        WHERE b.id = $1
    """

    const val DELETE_ALL_BANKS = "DELETE FROM banks"
}
