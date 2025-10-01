package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "flow.transaction-analysis")
data class TransactionAnalysisProperties(
        var batchSize: Int = 30,
        var maxRetries: Int = 3,
        var retryDelayMs: Long = 1000,
        var enabled: Boolean = true,
        var processingTimeoutMs: Long = 600000,
        var maxConcurrentBatches: Int = 3
)
