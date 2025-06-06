package sg.flow.services.UtilServices

import java.util.Optional
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Service

@Service
@Profile("prod")
class CacheServiceImpl : CacheService {
    override fun getUserIdByAccessToken(token: String): Optional<Int> {
        TODO("Not yet implemented: integrate with real cache")
    }

    override fun storeAccessToken(userId: Int, accessToken: String) {
        TODO("Not yet implemented: integrate with real cache")
    }
}
