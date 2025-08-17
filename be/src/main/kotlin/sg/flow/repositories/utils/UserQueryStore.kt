package sg.flow.repositories.utils

object UserQueryStore {
    const val SAVE_USER =
            """
        INSERT INTO users 
        (name, email, identification_number, phone_number, date_of_birth, address, password_hash, setting_json) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8::jsonb)
    """

    const val SAVE_USER_WITH_ID =
            """
        INSERT INTO users 
        (id, name, email, identification_number, phone_number, date_of_birth, address, password_hash, setting_json) 
        VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9::jsonb)
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
        WHERE u.id = $1
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
        WHERE u.id = $1
    """

    const val FIND_USER_PREFERENCE_JSON =
            """
        SELECT u.setting_json 
        FROM users u 
        WHERE u.id = $1
    """

    const val UPDATE_USER_PROFILE =
            """
        UPDATE users 
        SET email = $1, phone_number = $2, address = $3 
        WHERE id = $4
    """

    const val CHECK_USER_EXISTS_BY_EMAIL =
        """
            SELECT COUNT(*) as count 
            FROM users u
            WHERE u.email = $1
        """

    const val FIND_USER_ID_BY_EMAIL =
        """
            SELECT u.id
            FROM users u
            WHERE u.email = $1
        """

    const val FIND_USER_ID_AND_PASSWORD_HASH_BY_EMAIL =
        """
            SELECT u.id, 
            u.password_hash
            FROM users u
            WHERE u.email = $1
        """
}
