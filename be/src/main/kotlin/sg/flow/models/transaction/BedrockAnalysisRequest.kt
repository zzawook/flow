package sg.flow.models.transaction

data class BedrockAnalysisRequest(val transactions: List<TransactionForAnalysis>)

data class TransactionForAnalysis(
        val id: Long,
        val description: String,
        val amount: Double,
        val transactionDate: String,
        val transactionType: String
)
