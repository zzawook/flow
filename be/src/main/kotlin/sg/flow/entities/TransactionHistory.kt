package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import java.time.LocalTime
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

@Table(name = "transaction_history")
data class TransactionHistory(
        @Id val id: Long? = null,
        @field:NotNull val transactionReference: String,
        val account: Account? = null,
        val card: Card? = null,
        @field:NotNull val transactionDate: LocalDate,
        val transactionTime: LocalTime? = null,
        @field:NotNull val amount: Double,
        @field:NotNull val transactionType: String,
        val description: String = "",
        @field:NotNull val transactionStatus: String,
        val friendlyDescription: String = ""
)
