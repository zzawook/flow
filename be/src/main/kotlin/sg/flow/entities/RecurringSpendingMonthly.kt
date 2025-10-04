package sg.flow.entities

import java.time.LocalDate
import org.springframework.data.annotation.Id

data class RecurringSpendingMonthly(
        @field:Id val id: Long?,
        val userId: Int,
        val merchantKey: String,
        val sequenceKey: String,
        val displayName: String?,
        val brandName: String?,
        val brandDomain: String?,
        val category: String?,
        val year: Int,
        val month: Int,
        val expectedAmount: Double,
        val amountStddev: Double?,
        val occurrenceCount: Int,
        val lastTransactionDate: LocalDate?,
        val intervalDays: Int?,
        val periodLabel: String?,
        val nextTransactionDate: LocalDate?,
        val confidence: Double,
        val transactionIds: List<Long>?
)
