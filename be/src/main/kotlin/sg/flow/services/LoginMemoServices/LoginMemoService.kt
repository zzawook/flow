package sg.flow.services.LoginMemoServices

interface LoginMemoService {
    suspend fun getLoginMemo(userId: Int, institutionId: String): String
    suspend fun setLoginMemo(userId: Int, institutionId: String, memo: String): Boolean
}