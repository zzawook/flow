package sg.flow.configs

import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.Positive
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.validation.annotation.Validated

@ConfigurationProperties(prefix = "flow.transaction-analysis")
@Validated
data class TransactionAnalysisProperties(
        @field:Min(value = 1, message = "Batch size must be at least 1")
        @field:Max(value = 1000, message = "Batch size cannot exceed 1000")
        var batchSize: Int = 50,
        @field:Min(value = 0, message = "Max retries cannot be negative")
        @field:Max(value = 10, message = "Max retries cannot exceed 10")
        var maxRetries: Int = 3,
        @field:Positive(message = "Retry delay must be positive")
        @field:Max(value = 60000, message = "Retry delay cannot exceed 60 seconds")
        var retryDelayMs: Long = 1000,
        var enabled: Boolean = true,
        @field:Positive(message = "Processing timeout must be positive")
        var processingTimeoutMs: Long = 300000, // 5 minutes default
        @field:Min(value = 1, message = "Max concurrent batches must be at least 1")
        @field:Max(value = 10, message = "Max concurrent batches cannot exceed 10")
        var maxConcurrentBatches: Int = 3
) {
        fun isValidConfiguration(): Boolean {
                return batchSize > 0 &&
                        maxRetries >= 0 &&
                        retryDelayMs > 0 &&
                        processingTimeoutMs > 0 &&
                        maxConcurrentBatches > 0
        }

        fun getRetryDelayForAttempt(attempt: Int): Long {
                // Exponential backoff: base delay * 2^attempt, capped at 30 seconds
                val exponentialDelay = retryDelayMs * (1L shl minOf(attempt, 5))
                return minOf(exponentialDelay, 30000L)
        }
}
