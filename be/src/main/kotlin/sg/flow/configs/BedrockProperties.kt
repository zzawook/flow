package sg.flow.configs

import jakarta.validation.constraints.DecimalMax
import jakarta.validation.constraints.DecimalMin
import jakarta.validation.constraints.Max
import jakarta.validation.constraints.Min
import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.Pattern
import jakarta.validation.constraints.Positive
import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.validation.annotation.Validated

@ConfigurationProperties(prefix = "aws.bedrock")
@Validated
data class BedrockProperties(
        @field:NotBlank(message = "AWS region cannot be blank")
        @field:Pattern(
                regexp = "^[a-z0-9-]+$",
                message = "AWS region must contain only lowercase letters, numbers, and hyphens"
        )
        var region: String = "us-east-1",
        @field:NotBlank(message = "Agent ID cannot be blank")
        var agentId: String = "N8IR2MXV8S",
        @field:NotBlank(message = "Agent alias ID cannot be blank")
        var agentAliasId: String = "6WQOGYU4HS",
        @field:NotBlank(message = "Model ID cannot be blank")
        var modelId: String = "anthropic.claude-3-sonnet-20240229-v1:0",
        @field:Min(value = 1, message = "Max tokens must be at least 1")
        @field:Max(value = 100000, message = "Max tokens cannot exceed 100,000")
        var maxTokens: Int = 8192,
        @field:DecimalMin(value = "0.0", message = "Temperature must be between 0.0 and 2.0")
        @field:DecimalMax(value = "2.0", message = "Temperature must be between 0.0 and 2.0")
        var temperature: Double = 0.1,
        @field:Positive(message = "Timeout must be positive")
        @field:Max(value = 300000, message = "Timeout cannot exceed 5 minutes")
        var timeoutMs: Long = 30000,
        @field:Min(value = 1, message = "Max retries must be at least 1")
        @field:Max(value = 5, message = "Max retries cannot exceed 5")
        var maxRetries: Int = 3,
        @field:Positive(message = "Base retry delay must be positive")
        var baseRetryDelayMs: Long = 1000,
        @field:Positive(message = "Max retry delay must be positive")
        var maxRetryDelayMs: Long = 30000
) {
        fun isValidConfiguration(): Boolean {
                return region.isNotBlank() &&
                        modelId.isNotBlank() &&
                        maxTokens > 0 &&
                        temperature >= 0.0 &&
                        temperature <= 2.0 &&
                        timeoutMs > 0 &&
                        maxRetries > 0 &&
                        baseRetryDelayMs > 0 &&
                        maxRetryDelayMs > 0 &&
                        baseRetryDelayMs <= maxRetryDelayMs
        }

        fun getRetryDelayForAttempt(attempt: Int): Long {
                // Exponential backoff with jitter
                val exponentialDelay = baseRetryDelayMs * (1L shl minOf(attempt, 5))
                val cappedDelay = minOf(exponentialDelay, maxRetryDelayMs)

                // Add jitter (±25% of the delay)
                val jitter = (cappedDelay * 0.25 * (Math.random() - 0.5)).toLong()
                return maxOf(baseRetryDelayMs, cappedDelay + jitter)
        }

        fun getSupportedModels(): List<String> {
                return listOf(
                        "anthropic.claude-3-sonnet-20240229-v1:0",
                        "anthropic.claude-3-haiku-20240307-v1:0",
                        "anthropic.claude-3-opus-20240229-v1:0",
                        "anthropic.claude-instant-v1",
                        "anthropic.claude-v2"
                )
        }

        fun isModelSupported(modelId: String): Boolean {
                return getSupportedModels().contains(modelId)
        }
}
