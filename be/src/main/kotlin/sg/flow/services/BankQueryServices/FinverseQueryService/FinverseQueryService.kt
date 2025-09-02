package sg.flow.services.BankQueryServices.FinverseQueryService

import aws.smithy.kotlin.runtime.util.length
import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.runBlocking
import org.slf4j.LoggerFactory
import org.springframework.http.MediaType
import org.springframework.stereotype.Service
import org.springframework.web.reactive.function.BodyInserters
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.WebClientResponseException
import sg.flow.common.v1.CommonBankProto
import sg.flow.entities.Bank
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.responses.CustomerTokenResponse
import sg.flow.models.finverse.responses.LinkTokenResponse
import sg.flow.models.finverse.responses.FinverseAuthTokenResponse
import sg.flow.models.finverse.responses.FinverseLoginIdentityResponse
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.bank.BankRepository
import sg.flow.repositories.user.UserRepository
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException
import java.time.Instant
import java.util.concurrent.atomic.AtomicReference
import kotlin.time.Duration.Companion.minutes

@Service
class FinverseQueryService(
    private val finverseLoginIdentityService: FinverseLoginIdentityService,

    private val finverseTimeoutWatcher: FinverseTimeoutWatcher,
    private val bankRepository: BankRepository,
    private val accountRepository: AccountRepository,
    private val finverseWebclientService: FinverseWebclientService,
    private val finverseResponseProcessor: FinverseResponseProcessor,
) {
    private val logger = LoggerFactory.getLogger(FinverseQueryService::class.java)

    fun fetchInstitutionData() {
        fun isIndividualBank(userTypes: List<String>): Boolean {
            return userTypes.size == 1 && userTypes[0] == "INDIVIDUAL"
        }
        fun isInAllowedList(institution: FinverseInstitution): Boolean {
            if (institution.institutionId == "testbank") {
                return true
            }
            return false
        }

        val countries = "SGP"
        val institutions = finverseWebclientService.fetchInstitutionData(countries)
        institutions.map { institution ->
            if (isIndividualBank(institution.userType) || isInAllowedList(institution)) {
                runBlocking {
                    val bank = finverseResponseProcessor.processInstitutionResponse(institution)
                    bankRepository.save(bank)
                    bank
                }
            }
        }
    }

    suspend fun hasRunningRefreshSession(userId: Int, institutionId: String): Boolean {
        return finverseLoginIdentityService.hasRunningRefreshSession(userId, institutionId);
    }

    suspend fun getBanksForRefresh(userId: Int, country: String = "SGP"): List<Bank> {
        val accounts = accountRepository.findAccountsOfUser(userId)
        val banks = accounts.map { account -> account.bank }
        return banks
    }

    suspend fun getBanksForLink(userId: Int, country: String = "SGP"): List<Bank> {
        val banks = bankRepository.findAllBanksInCountry(country)
        return banks
    }

    /**
     * Generates a Link Token for the given institution,
     * returning the URL the front-end can open for user authentication.
     */
    suspend fun relink(userId: Int, institutionId: String, country: String = "SGP"): String {
        val productsRequested =
            listOf("ACCOUNTS", "TRANSACTIONS", "ACCOUNT_NUMBERS")
        val productSupported = productsRequested;

        val automaticRefreshVal = "ON"

        val state = fnv1a32("$userId$institutionId${System.currentTimeMillis()}")

        finverseLoginIdentityService.startPreAuthSession(userId, institutionId, state)

        return try {
            val resp = finverseWebclientService.fetchLinkUrlInit(
                userId,
                institutionId,
                state,
                automaticRefreshVal,
                productSupported,
                productsRequested,
                listOf(country)
            )

            resp.linkUrl
        }
        catch (e: WebClientResponseException) {
            e.printStackTrace()
            logger.error("Finverse returned HTTP ${e.statusCode}: ${e.responseBodyAsString}")
            throw FinverseException("Failed to generate link URL: ${e.responseBodyAsString}")
        }
        catch (e: Exception) {
            logger.error("Unexpected error while generating link URL", e)
            throw FinverseException("Unexpected error: ${e.message}")
        }
    }

    /** 32‑bit FNV‑1a hash of a String. */
    /** 32‑bit FNV‑1a hash of a String, returned as 8‑char hex. */
    fun fnv1a32(str: String): String {
        // use unsigned to avoid sign‑extension issues
        var hash = 0x811c9dc5u
        val prime = 0x01000193u

        for (c in str) {
            hash = hash xor c.code.toUInt()
            hash *= prime
        }

        // format as 8‑digit hex (lowercase)
        return hash.toString(16).padStart(8, '0')
    }

    suspend fun refresh(userId: Int, institutionId: String): String {

        val loginIdentityToken = finverseLoginIdentityService.getLoginIdentityTokenWithUserIdAndInstitutionId(userId, institutionId)
        val state = fnv1a32("$userId$institutionId${System.currentTimeMillis()}")

        finverseLoginIdentityService.startPreAuthSession(userId, institutionId, state)

        if (finverseLoginIdentityService.getIsRefreshAllowed(userId, institutionId)) {
            return try {
                val linkTokenResponse = finverseWebclientService.fetchLinkUrlRefresh(loginIdentityToken, state)
                linkTokenResponse.linkUrl
            } catch (e: Exception) {
                e.printStackTrace()
                ""
            }
        }
        else {
            val automaticRefreshVal = "ON"
            val productsRequested =
                listOf("ACCOUNTS", "TRANSACTIONS", "ACCOUNT_NUMBERS")
            val productSupported = productsRequested;
            val linkTokenResponse = finverseWebclientService.fetchLinkUrlRelink(
                userId,
                institutionId,
                loginIdentityToken,
                state,
                automaticRefreshVal,
                productSupported,
                productsRequested,
                listOf("SGP"))
            return linkTokenResponse.linkUrl
        }
    }

    suspend fun fetchLoginIdentityToken(userId: Int, code: String, institutionId: String): String {
        val loginIdentityId = finverseLoginIdentityService.fetchLoginIdentityToken(userId, code, institutionId)
        return loginIdentityId
    }

    suspend fun getInstitutionAuthenticationResult(userId: Int, institutionId: String): FinverseAuthenticationStatus {
        val timeout = 5.minutes
        val status = finverseTimeoutWatcher.watchAuthentication(
            userId,
            institutionId,
            timeout
        )

        return status
    }

    suspend fun getUserDataRetrievalResult(userId: Int, institutionId: String): FinverseOverallRetrievalStatus {
        val timeout = 2.minutes
        val loginIdentityId = finverseLoginIdentityService.getLoginIdentityIdWithUserIdAndInstitutionId(userId, institutionId)
        val status = finverseTimeoutWatcher.watchDataRetrievalCompletion(
            loginIdentityId,
            timeout
        )

        return status
    }

    suspend fun getFinverseInstitutionId(institutionId: Long): String {
        return bankRepository.findFinverseIdWithId(institutionId)
    }

}