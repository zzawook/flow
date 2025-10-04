package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "flow.spending-median")
data class SpendingMedianProperties(val enabled: Boolean = true, val backfillMonths: Int = 12)
