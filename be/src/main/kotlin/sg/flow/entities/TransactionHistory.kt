package sg.flow.entities

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import java.time.LocalTime
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import sg.flow.models.card.BriefCard

data class TransactionHistory(
        @field:Id val id: Long?,
        @field:NotBlank val transactionReference: String,
        val account: Account? = null,
        val card: BriefCard? = null,
        @field:NotNull val transactionDate: LocalDate,
        val transactionTime: LocalTime? = null,
        @field:NotNull val amount: Double,
        @field:NotBlank val transactionType: String,
        val description: String = "",
        @field:NotBlank val transactionStatus: String,
        val friendlyDescription: String = "",
        val transactionCategory: String = ""
)
