package sg.flow.models.finverse.responses

import com.fasterxml.jackson.annotation.JsonProperty
import java.time.LocalDate

data class FinverseIncomeEstimationResponse(
        @JsonProperty("income_estimation")
        val incomeEstimation: FinverseIncomeEstimationData? = null
) : FinverseProductResponse()

data class FinverseIncomeEstimationData(
        @JsonProperty("estimated_monthly_income") val estimatedMonthlyIncome: Double? = null,
        @JsonProperty("estimated_annual_income") val estimatedAnnualIncome: Double? = null,
        @JsonProperty("currency") val currency: String,
        @JsonProperty("confidence_score") val confidenceScore: Double? = null,
        @JsonProperty("income_sources") val incomeSources: List<FinverseIncomeSourceData>? = null,
        @JsonProperty("analysis_period_start") val analysisPeriodStart: LocalDate? = null,
        @JsonProperty("analysis_period_end") val analysisPeriodEnd: LocalDate? = null,
        @JsonProperty("last_updated") val lastUpdated: LocalDate? = null
)

data class FinverseIncomeSourceData(
        @JsonProperty("source_type") val sourceType: String,
        @JsonProperty("monthly_amount") val monthlyAmount: Double,
        @JsonProperty("frequency") val frequency: String? = null,
        @JsonProperty("description") val description: String? = null,
        @JsonProperty("confidence") val confidence: Double? = null
)
