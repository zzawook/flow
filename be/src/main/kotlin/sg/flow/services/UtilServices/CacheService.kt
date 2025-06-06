package sg.flow.services.UtilServices

import java.util.Optional

interface CacheService {
    fun getUserIdByAccessToken(token: String): Optional<Int>
    fun storeAccessToken(userId: Int, accessToken: String)
}
