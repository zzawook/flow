package sg.flow.models.finverse.mappers

import java.time.LocalDateTime
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.models.finverse.responses.FinverseAccountData
import sg.flow.models.finverse.responses.FinverseAccountType
import sg.flow.models.finverse.responses.FinverseInstitutionForAccountResponse

class FinverseAccountToAccountMapper(
        private val userMapper: (String) -> User,
        private val bankMapper: (String) -> Bank
) : Mapper<FinverseAccountData, Account> {

    fun map(input: FinverseAccountData, institution: FinverseInstitutionForAccountResponse, loginIdentityId: String): Account {
        return Account(
                id = null,
                accountNumber = input.accountNumberMasked,
                bank = bankMapper(institution.institutionId),
                owner =
                        userMapper(
                                loginIdentityId
                        ),
                balance = input.balance.amount,
                accountName = input.accountName,
                accountType = mapAccountType(input.accountType),
                interestRatePerAnnum = 0.0, // CANNOT BE IMPLEMENTED NOW DUE TO FINVERSE DATA API's NOT SUPPORTING
                lastUpdated = LocalDateTime.now(),
                finverseId = input.accountId
        )
    }

    private fun mapAccountType(finverseAccountType: FinverseAccountType): AccountType {
        return when (finverseAccountType.subtype.uppercase()) {
            "SAVINGS", "SAVINGS_ACCOUNT" -> AccountType.SAVINGS
            "CURRENT", "CHECKING", "CURRENT_ACCOUNT" -> AccountType.CURRENT
            "TIME_DEPOSIT", "FIXED_DEPOSIT", "CD" -> AccountType.TIME_DEPOSIT
            "CREDIT_CARD" -> AccountType.CREDIT_CARD
            "DEBIT_CARD" -> AccountType.DEBIT_CARD
            "MORTGAGE", "HOME_LOAN" -> AccountType.MORTGAGE
            "PERSONAL_LOAN" -> AccountType.PERSONAL_LOAN
            "REVOLVING_LOAN" -> AccountType.REVOLVING_LOAN
            "STOCKS" -> AccountType.STOCKS
            "INVESTMENT", "SECURITIES" -> AccountType.SECURITIES
            "RETIREMENT", "PENSION" -> AccountType.RETIREMENT
            else -> AccountType.OTHERS
        }
    }
}
