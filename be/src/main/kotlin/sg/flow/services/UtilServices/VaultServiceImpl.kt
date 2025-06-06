package sg.flow.services.UtilServices

import java.util.Optional
import org.springframework.context.annotation.Profile
import org.springframework.stereotype.Service

@Service
@Profile("prod")
class VaultServiceImpl : VaultService {
    override fun getUserIdByAccessToken(token: String): Optional<Int> {
        TODO("Not yet implemented: integrate with vault")
    }

    override fun getUserIdByRefreshToken(token: String): Optional<Int> {
        TODO("Not yet implemented: integrate with vault")
    }

    override fun storeAccessToken(userId: Int, accessToken: String) {
        TODO("Not yet implemented: integrate with vault")
    }

    override fun storeRefreshToken(userId: Int?, refreshToken: String) {
        TODO("Not yet implemented: integrate with vault")
    }
}
