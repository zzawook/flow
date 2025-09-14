package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "flow.recurring-analysis")
data class RecurringSpendingProperties(
        var enabled: Boolean = true,
        var lookbackMonths: Int = 12,
        var monthsToProject: Int = 6,
        var includeExpectedMonths: Boolean = true,
        var minOccurrences: Int = 3,
        var minPeriodDays: Int = 7,
        var maxPeriodDays: Int = 90,
        var confidenceThreshold: Double = 0.7,
        // multi-pattern
        var enableMultiPattern: Boolean = true,
        var maxSequencesPerGroup: Int = 2,
        // weights (sum ~ 1.0)
        var weightAmount: Double = 0.25,
        var weightPeriod: Double = 0.30,
        var weightOccurrences: Double = 0.20,
        var weightRecency: Double = 0.15,
        var weightAlignment: Double = 0.10,
        // scoring params
        var alphaAmountTightness: Double = 2.0,
        var betaPeriodRegularity: Double = 3.0,
        var gammaOccurrenceSaturation: Double = 0.6,
        var deltaRecencyDecay: Double = 1.0,
        var intervalMadMultiplier: Double = 3.0,
        var canonicalPeriods: List<Int> = listOf(30, 60, 90),
        var canonicalBoost: Double = 0.05,
        var categoryWeights: Map<String, Double> =
                mapOf(
                        "Utilities" to 1.2,
                        "Telecommunication" to 1.2,
                        "Insurance" to 1.1,
                        "Finance" to 1.05
                )
)
