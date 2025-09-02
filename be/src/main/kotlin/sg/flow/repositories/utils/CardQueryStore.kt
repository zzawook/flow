package sg.flow.repositories.utils

object CardQueryStore {
    const val SAVE_CARD =
            """
        INSERT INTO cards 
        (owner_id, issuing_bank_id, card_number, card_type) 
        VALUES ($1, $2, $3, $4)
    """

    const val SAVE_CARD_WITH_ID =
            """
        INSERT INTO cards 
        (id, owner_id, issuing_bank_id, card_number, card_type) 
        VALUES ($1, $2, $3, $4, $5)
    """

    const val FIND_CARD_BY_ID =
            """
        SELECT c.id, 
        c.owner_id, 
        c.issuing_bank_id, 
        c.card_number, 
        c.card_type, 
        u.id AS user_id, 
        u.name, 
        u.email, 
        u.identification_number, 
        u.phone_number, 
        u.date_of_birth, 
        u.setting_json, 
        u.address,
        a.id AS account_id, 
        a.account_number, 
        a.balance, 
        a.account_name, 
        a.account_type, 
        a.last_updated, 
        b.id AS bank_id,
        b.bank_name, 
        b.bank_code 
        FROM cards c 
        JOIN users u ON c.owner_id = u.id 
        JOIN accounts a ON c.linked_account_id = a.id 
        JOIN banks b ON c.issuing_bank_id = b.id 
        WHERE c.id = $1
    """

    const val DELETE_ALL_CARDS = "DELETE FROM cards"
}
