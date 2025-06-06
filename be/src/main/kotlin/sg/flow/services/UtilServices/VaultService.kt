package sg.flow.services.UtilServices

import java.util.Optional

interface VaultService {
    fun getUserIdByAccessToken(token: String): Optional<Int>
    fun getUserIdByRefreshToken(token: String): Optional<Int>
    fun storeAccessToken(userId: Int, accessToken: String)
    fun storeRefreshToken(userId: Int?, refreshToken: String)
}
