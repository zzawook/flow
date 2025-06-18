package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseCacheMissException
import java.util.concurrent.atomic.AtomicReference

@Component
class FinverseAuthCache {
    private final val userIdTologinIdentityCache =
        AtomicReference<HashMap<Int, HashMap<String, FinverseLoginIdentityCredential>>>()

    suspend fun saveLoginIdentityToken(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityToken: String
    ) {
        val map = userIdTologinIdentityCache.get()

        if (!map.containsKey(userId)) {
            map[userId] = HashMap()
        }
        val userMap = map[userId] ?: HashMap() // Defensive programming

        userMap[institutionId] = FinverseLoginIdentityCredential(loginIdentityId, loginIdentityToken)
    }

    suspend fun getLoginIdentityCredential(userId: Int, institutionId: String): FinverseLoginIdentityCredential? {
        return userIdTologinIdentityCache.get()[userId]?.get(institutionId)
    }

    suspend fun getUserId(loginIdentityId: String): Int {
        val map = userIdTologinIdentityCache.get()

        for ((userId, innerMap) in map) {
            for ((institutionId, loginIdentityCredential) in innerMap) {
                if (loginIdentityCredential.loginIdentityId == loginIdentityId) {
                    return userId
                }
            }
        }

        return -1
    }
}