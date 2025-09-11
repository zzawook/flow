package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "flow.recurring-analysis")
data class RecurringSpendingProperties(
        var enabled: Boolean = true,
        var lookbackMonths: Int = 12,
        var monthsToProject: Int = 6,
        var includeExpectedMonths: Boolean = true,
        var minOccurrences: Int = 3,
        var amountSimilarityTolerancePct: Double = 0.15,
        var descriptionSimilarityThreshold: Double = 0.85,
        var brandSimilarityThreshold: Double = 0.85,
        var periodTolerancePct: Double = 0.15,
        var maxPeriodDays: Int = 90,
        var defaultConfidence: Double = 0.6,
        var categoryWeights: Map<String, Double> =
                mapOf(
                        "Utilities" to 1.2,
                        "Telecommunication" to 1.2,
                        "Insurance" to 1.1,
                        "Finance" to 1.05
                )
)
