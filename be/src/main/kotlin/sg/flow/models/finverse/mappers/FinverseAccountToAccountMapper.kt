package sg.flow.models.finverse.mappers

import java.time.LocalDateTime
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.models.finverse.responses.FinverseAccountData

class FinverseAccountToAccountMapper(
        private val userMapper: (String) -> User,
        private val bankMapper: (String, String?) -> Bank
) : Mapper<FinverseAccountData, Account> {

    override fun map(input: FinverseAccountData): Account {
        return Account(
                id = null,
                accountNumber = input.accountNumber,
                bank = bankMapper(input.institutionName, input.bankCode),
                owner =
                        userMapper(
                                input.accountId
                        ), // This would need to be mapped from user context
                balance = input.balance,
                accountName = input.accountName,
                accountType = mapAccountType(input.accountType),
                interestRatePerAnnum = input.interestRate ?: 0.0,
                lastUpdated = input.lastUpdated ?: LocalDateTime.now(),
                finverseId = input.accountId
        )
    }

    private fun mapAccountType(finverseAccountType: String): AccountType {
        return when (finverseAccountType.uppercase()) {
            "SAVINGS", "SAVINGS_ACCOUNT" -> AccountType.SAVINGS
            "CURRENT", "CHECKING", "CURRENT_ACCOUNT" -> AccountType.CURRENT
            "TIME_DEPOSIT", "FIXED_DEPOSIT", "CD" -> AccountType.TIME_DEPOSIT
            "CREDIT_CARD" -> AccountType.CREDIT_CARD
            "DEBIT_CARD" -> AccountType.DEBIT_CARD
            "MORTGAGE", "HOME_LOAN" -> AccountType.MORTGAGE
            "PERSONAL_LOAN" -> AccountType.PERSONAL_LOAN
            "INVESTMENT", "SECURITIES" -> AccountType.SECURITIES
            "RETIREMENT", "PENSION" -> AccountType.RETIREMENT
            else -> AccountType.OTHERS
        }
    }
}
