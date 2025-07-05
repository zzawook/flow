package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate

data class FinverseStatementsResponse(
        @JsonProperty("statements") val statements: List<FinverseStatementData>? = null,
        @JsonProperty("account_id") val accountId: String? = null
) : FinverseProductResponse()

data class FinverseStatementData(
        @JsonProperty("statement_id") val statementId: String,
        @JsonProperty("account_id") val accountId: String,
        @JsonProperty("statement_date") val statementDate: LocalDate,
        @JsonProperty("period_start") val periodStart: LocalDate,
        @JsonProperty("period_end") val periodEnd: LocalDate,
        @JsonProperty("opening_balance") val openingBalance: Double,
        @JsonProperty("closing_balance") val closingBalance: Double,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("statement_url") val statementUrl: String? = null,
        @JsonProperty("statement_format") val statementFormat: String? = null,
        @JsonProperty("total_credits") val totalCredits: Double? = null,
        @JsonProperty("total_debits") val totalDebits: Double? = null,
        @JsonProperty("transaction_count") val transactionCount: Int? = null,
        @JsonProperty("status") val status: String? = null
)
