package sg.flow.repositories.loginMemo

interface LoginMemoRepository {
    suspend fun getLoginMemo(userId: Int, institutionId: String): String

    suspend fun setLoginMemo(userId: Int, institutionId: String, memo: String): Boolean
}