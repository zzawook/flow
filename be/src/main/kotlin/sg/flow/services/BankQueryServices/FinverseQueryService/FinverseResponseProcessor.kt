package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.runBlocking
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.TransactionHistory
import sg.flow.entities.User
import sg.flow.models.card.BriefCard
import sg.flow.models.finverse.FinverseInstitution
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.mappers.*
import sg.flow.models.finverse.responses.*
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.bank.BankRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.repositories.user.UserRepository
import sg.flow.services.BankQueryServices.FinverseQueryService.exceptions.FinverseException

@Component
class FinverseResponseProcessor(
    private val userRepository: UserRepository,
    private val bankRepository: BankRepository,
    private val accountRepository: AccountRepository,
    private val transactionRepository: TransactionHistoryRepository,
    private val finverseAuthCache: FinverseAuthCache
) {

    private val accountMapper =
            FinverseAccountToAccountMapper(
                    userMapper = { accountId -> findOrCreateUser(accountId) },
                    bankMapper = { finverseId ->
                        findOrCreateBank(finverseId)
                    }
            )

    private val transactionMapper =
            FinverseTransactionToTransactionHistoryMapper(
                    accountMapper = { accountId -> findAccountByExternalId(accountId) },
                    cardMapper = { cardNumber -> findCardByNumber(cardNumber) }
            )

//    private val accountNumberMapper =
//            FinverseAccountNumberMapper(
//                    userMapper = { accountId -> findOrCreateUser(accountId) },
//                    bankMapper = { institutionName, bankCode ->
//                        findOrCreateBank(institutionName, bankCode)
//                    }
//            )

    private val identityMapper = FinverseIdentityMapper()

    private val institutionMapper = FinverseInstitutionToBankMapper()

    /** Process accounts response and convert to domain entities */
    suspend fun processAccountList(accountList: List<Account>) {
        for (account in accountList) {
            accountRepository.save(account)
        }
    }

    fun processAccountsResponseIntoAccountList(response: FinverseAccountResponse): List<Account> {
        val accountList =
            response.accounts?.map { accountData -> accountMapper.map(accountData, response.institution, response.loginIdentity.loginIdentityId) }
                ?: emptyList()

        if (accountList.isEmpty()) {
            throw FinverseException("ACCOUNT RESPONSE IS EMPTY")
        }

        return accountList
    }

    /** Process transactions response and convert to domain entities */
    suspend fun processTransactionsResponse(
            response: FinverseTransactionResponse
    ): List<TransactionHistory> {
        val transactionHistoryList = response.transactions?.map { transactionData ->
            transactionMapper.map(transactionData)
        }
                ?: emptyList()

        for (transactionHistory in transactionHistoryList) {
            transactionRepository.save(transactionHistory)
        }


        return transactionHistoryList
    }

    /** Process identity response and convert to domain entity */
    suspend fun processIdentityResponse(response: FinverseIdentityResponse): User? {
        return response.identity?.let { identityData -> identityMapper.map(identityData) }
    }

    /** Process institution response and convert to domain entity */
    suspend fun processInstitutionResponse(institution: FinverseInstitution): Bank {
        return institutionMapper.map(institution)
    }

    /** Process balance history response */
    suspend fun processBalanceHistoryResponse(
            response: FinverseBalanceHistoryResponse
    ): List<FinverseBalanceHistoryData> {
        // You might want to create a specific domain entity for balance history
        // For now, returning the DTO data directly
        return response.balanceHistory ?: emptyList()
    }

    /** Process income estimation response */
    suspend fun processIncomeEstimationResponse(
            response: FinverseIncomeEstimationResponse
    ): FinverseIncomeEstimationData? {
        // You might want to create a specific domain entity for income estimation
        // For now, returning the DTO data directly
        return response.incomeEstimation
    }

    /** Process statements response */
    suspend fun processStatementsResponse(
            response: FinverseStatementsResponse
    ): List<FinverseStatementData> {
        // You might want to create a specific domain entity for statements
        // For now, returning the DTO data directly
        return response.statements ?: emptyList()
    }

    // Helper methods for entity lookup/creation
    private fun findOrCreateUser(loginIdentityId: String): User {
        var user: User? = null;

        runBlocking {
            val userId = finverseAuthCache.getUserId(loginIdentityId).toLong()
            println("user ID: $userId")
            user = userRepository.findById(userId)
            println("user: $user")
        }

        return user ?: throw FinverseException("User with given login identity ID not found")
    }

    private fun findOrCreateBank(finverseId: String): Bank {
        var bank: Bank? = null;
        runBlocking {
            bank = bankRepository.findByFinverseId(finverseId)
        }

        return bank ?: throw FinverseException("Bank not found")
    }

    private fun findAccountByExternalId(externalId: String): Account? {
        // Implementation would look up account by external ID
        return null
    }

    private fun findCardByNumber(cardNumber: String?): BriefCard? {
        // Implementation would look up card by number
        return null
    }
}
