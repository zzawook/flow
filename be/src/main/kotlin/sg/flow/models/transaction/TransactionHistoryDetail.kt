package sg.flow.models.transaction

import java.time.LocalDate
import java.time.LocalTime
import sg.flow.entities.Account
import sg.flow.models.card.BriefCard

data class TransactionHistoryDetail(
        val id: Long,
        val transactionReference: String? = null,
        val account: Account? = null,
        val card: BriefCard? = null,
        val transactionDate: LocalDate? = null,
        val transactionTime: LocalTime? = null,
        val amount: Double,
        val transactionType: String? = null,
        val description: String,
        val transactionStatus: String? = null,
        val friendlyDescription: String? = null
)
