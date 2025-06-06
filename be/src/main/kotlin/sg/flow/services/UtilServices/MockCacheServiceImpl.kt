package sg.flow.services.UtilServices

import java.util.Optional
import java.util.concurrent.ConcurrentHashMap
import org.springframework.stereotype.Service

@Service
class MockCacheServiceImpl : CacheService {
    private val tokenToUserId: MutableMap<String, Int> = ConcurrentHashMap()

    override fun getUserIdByAccessToken(token: String): Optional<Int> =
            Optional.ofNullable(tokenToUserId[token])

    override fun storeAccessToken(userId: Int, accessToken: String) {
        tokenToUserId[accessToken] = userId
    }
}
