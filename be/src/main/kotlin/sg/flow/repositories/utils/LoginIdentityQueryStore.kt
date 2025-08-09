package sg.flow.repositories.utils

object LoginIdentityQueryStore {
    const val SAVE_LOGIN_IDENTITY =
        """
            SELECT upsert_login_identity($1, $2, $3, $4, $5)
        """

    const val UPDATE_LOGIN_IDENTITY =
        """
            UPDATE login_identities
            SET login_identity_id = $1,
                login_identity_refresh_token = $2,
                refresh_allowed = $3
            WHERE user_id = $4 AND finverse_institution_id = $5
        """

    const val DELETE_LOGIN_IDENTITY =
        """
            DELETE FROM login_identities WHERE user_id = $1 AND finverse_institution_id = $2
        """

    const val GET_LOGIN_IDENTITY_WITH_USERID_AND_FINVERSE_INSTITUTION_ID =
        """
            SELECT 
            l.login_identity_id,
            l.login_identity_refresh_token,
            l.user_id,
            l.finverse_institution_id,
            l.refresh_allowed
            FROM login_identities l 
            WHERE l.user_id = $1 AND l.finverse_institution_id = $2
        """

    const val GET_LOGIN_IDENTITY_WITH_LOGIN_IDENTITY_ID =
        """
            SELECT 
            l.login_identity_id,
            l.login_identity_refresh_token,
            l.user_id,
            l.finverse_institution_id,
            l.refresh_allowed
            FROM login_identities l 
            WHERE l.login_identity_id = $1
        """

    const val GET_USER_ID_AND_INSTITUTION_ID_WITH_LOGIN_IDENTITY_ID =
        """
            SELECT
            l.user_id,
            b.bank_id,
            FROM login_identities l
            JOIN banks b ON l.finverse_institution_id = b.finverse_id
            WHERE l.finverse_institution_id = $1
        """
}