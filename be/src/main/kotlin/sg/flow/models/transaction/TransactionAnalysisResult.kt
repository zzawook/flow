package sg.flow.models.transaction

import java.time.LocalDate

data class TransactionAnalysisResult(
        val transactionId: Long,
        val revisedTransactionDate: LocalDate?,
        val category: String?,
        val cardNumber: String?,
        val friendlyDescription: String?,
        val confidence: Double,
        val success: Boolean,
        val errorMessage: String? = null
)
