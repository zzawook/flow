package sg.flow.services.BankQueryServices.FinverseQueryService

import org.springframework.stereotype.Component
import java.util.concurrent.atomic.AtomicReference

@Component
class FinverseAuthCache {
    private final val loginIdentityCache = AtomicReference<HashMap<String, HashMap<String, String>>>()
    private final val fetchStatusCache = AtomicReference<HashMap<String, HashMap<String, String>>>()

    suspend fun saveLoginIdentityToken(userId: String, bankId: String, loginIdentityToken: String) {
        val map = loginIdentityCache.get()

        if (! map.containsKey(userId)) {
            map[userId] = HashMap()
        }
        val userMap = map[userId] ?: HashMap() // Defensive programming

        userMap[bankId] = loginIdentityToken
    }

    suspend fun getLoginIdentityToken(userId: String, bankId: String): String? {
        return loginIdentityCache.get()[userId]?.get(bankId)
    }

    suspend fun saveFetchStatus(userId: String, bankId: String, fetchStatus: String) {
        val map = fetchStatusCache.get()

        if (! map.containsKey(userId)) {
            map[userId] = HashMap()
        }
        val userMap = map[userId] ?: HashMap()

        userMap[bankId] = fetchStatus
    }

    suspend fun getFetchStatus(userId: String, bankId: String): String? {
        return fetchStatusCache.get()[userId]?.get(bankId)
    }
}