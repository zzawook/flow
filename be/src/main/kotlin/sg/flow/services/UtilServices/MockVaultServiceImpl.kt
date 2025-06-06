package sg.flow.services.UtilServices

import java.util.Optional
import java.util.concurrent.ConcurrentHashMap
import org.springframework.stereotype.Service

@Service
class MockVaultServiceImpl : VaultService {
    private val vaultMap: MutableMap<String, MutableMap<String, Int>> = ConcurrentHashMap()

    override fun getUserIdByAccessToken(token: String): Optional<Int> {
        val map = vaultMap["access_tokens"] ?: return Optional.empty()
        return Optional.ofNullable(map[token])
    }

    override fun getUserIdByRefreshToken(token: String): Optional<Int> {
        val map = vaultMap["refresh_tokens"] ?: return Optional.empty()
        return Optional.ofNullable(map[token])
    }

    override fun storeAccessToken(userId: Int, accessToken: String) {
        val map = vaultMap.computeIfAbsent("access_tokens") { ConcurrentHashMap() }
        map[accessToken] = userId
    }

    override fun storeRefreshToken(userId: Int?, refreshToken: String) {
        val map = vaultMap.computeIfAbsent("refresh_tokens") { ConcurrentHashMap() }
        if (userId != null) {
            map[refreshToken] = userId
        }
    }
}
