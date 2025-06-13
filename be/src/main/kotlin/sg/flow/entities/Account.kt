package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDateTime
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import sg.flow.entities.utils.AccountType

data class Account(
        @field:Id val id: Long,
        @field:NotNull val accountNumber: String,
        @field:NotNull val bank: Bank,
        @field:NotNull val owner: User,
        @field:NotNull val balance: Double,
        @field:NotNull val accountName: String,
        @field:NotNull val accountType: AccountType,
        @field:NotNull val interestRatePerAnnum: Double = 0.0,
        @field:NotNull val lastUpdated: LocalDateTime
)
