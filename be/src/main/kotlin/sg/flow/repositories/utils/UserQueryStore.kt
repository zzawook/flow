package sg.flow.repositories.utils

object UserQueryStore {
    const val SAVE_USER =
            """
        INSERT INTO users 
        (name, email, identification_number, phone_number, date_of_birth, address, setting_json) 
        VALUES (?, ?, ?, ?, ?, ?, ?::jsonb)
    """

    const val SAVE_USER_WITH_ID =
            """
        INSERT INTO users 
        (id, name, email, identification_number, phone_number, date_of_birth, address, setting_json) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?::jsonb)
    """

    const val FIND_USER_BY_ID =
            """
        SELECT u.id, 
        u.name, 
        u.email, 
        u.identification_number, 
        u.phone_number, 
        u.date_of_birth, 
        u.address, 
        u.setting_json 
        FROM users u 
        WHERE u.id = ?
    """

    const val DELETE_ALL_USERS = "DELETE FROM users"

    const val FIND_USER_PROFILE =
            """
        SELECT u.name, 
        u.email, 
        u.phone_number, 
        u.date_of_birth, 
        u.identification_number, 
        u.address 
        FROM users u 
        WHERE u.id = ?
    """

    const val FIND_USER_PREFERENCE_JSON =
            """
        SELECT u.setting_json 
        FROM users u 
        WHERE u.id = ?
    """

    const val UPDATE_USER_PROFILE =
            """
        UPDATE users 
        SET email = ?, phone_number = ?, address = ? 
        WHERE id = ?
    """
}
