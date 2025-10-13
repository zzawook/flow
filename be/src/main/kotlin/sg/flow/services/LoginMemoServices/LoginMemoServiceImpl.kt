package sg.flow.services.LoginMemoServices

import org.springframework.stereotype.Service
import sg.flow.repositories.loginMemo.LoginMemoRepository

@Service
class LoginMemoServiceImpl(
    private val loginMemoRepository: LoginMemoRepository
) : LoginMemoService {
    override suspend fun getLoginMemo(userId: Int, institutionId: String): String {
        return loginMemoRepository.getLoginMemo(userId, institutionId)
    }

    override suspend fun setLoginMemo(userId: Int, institutionId: String, memo: String): Boolean {
        return loginMemoRepository.setLoginMemo(userId, institutionId, memo)
    }

}