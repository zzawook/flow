package sg.flow.repositories.loginIdentity

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository
import sg.flow.models.finverse.LoginIdentity
import sg.flow.services.UtilServices.VaultService

@Repository
class LoginIdentityRepositoryImpl(
    private val vaultService: VaultService
) : LoginIdentityRepository {

    private val logger = LoggerFactory.getLogger(LoginIdentityRepositoryImpl::class.java)

    override suspend fun saveOrUpdateLoginIdentity(loginIdentity: LoginIdentity) {
        vaultService.saveOrUpdateLoginIdentity(loginIdentity)
    }

    override suspend fun updateLoginIdentity(newLoginIdentity: LoginIdentity) {
        vaultService.saveOrUpdateLoginIdentity(newLoginIdentity)
    }

    override suspend fun updateLoginIdentity(
        userId: Int,
        institutionId: String,
        loginIdentityId: String,
        loginIdentityRefreshToken: String,
        refreshAllowed: Boolean
    ) {
        vaultService.saveOrUpdateLoginIdentity(LoginIdentity(
            userId,
            institutionId,
            loginIdentityId,
            loginIdentityRefreshToken,
            refreshAllowed
        ))
    }

    override suspend fun deleteLoginIdentity(loginIdentity: LoginIdentity) {
        vaultService.deleteLoginIdentity(loginIdentity)
    }

    override suspend fun deleteLoginIdentity(userId: Int, institutionId: String) {
        vaultService.deleteLoginIdentity(userId, institutionId)
    }

    override suspend fun getLoginIdentity(
        userId: Int,
        institutionId: String
    ): LoginIdentity? {
        return vaultService.getLoginIdentity(userId, institutionId,)
    }

    override suspend fun getLoginIdentity(loginIdentityId: String): LoginIdentity? {
        return vaultService.getLoginIdentity(loginIdentityId)
    }
}