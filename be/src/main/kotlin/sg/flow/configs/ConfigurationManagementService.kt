package sg.flow.configs

import org.slf4j.LoggerFactory
import org.springframework.boot.context.properties.ConfigurationPropertiesBinding
import org.springframework.context.ApplicationEventPublisher
import org.springframework.context.event.EventListener
import org.springframework.core.env.ConfigurableEnvironment
import org.springframework.core.env.MapPropertySource
import org.springframework.stereotype.Service
import org.springframework.validation.annotation.Validated
import jakarta.validation.Valid
import java.util.concurrent.ConcurrentHashMap

@Service
@Validated
class ConfigurationManagementService(
    private val environment: ConfigurableEnvironment,
    private val eventPublisher: ApplicationEventPublisher,
    private val transactionAnalysisProperties: TransactionAnalysisProperties,
    private val bedrockProperties: BedrockProperties
) {
    
    private val logger = LoggerFactory.getLogger(ConfigurationManagementService::class.java)
    private val runtimeProperties = ConcurrentHashMap<String, Any>()
    
    companion object {
        private const val RUNTIME_PROPERTY_SOURCE_NAME = "runtimeConfigurationProperties"
    }
    
    init {
        // Add runtime property source to environment
        val runtimePropertySource = MapPropertySource(RUNTIME_PROPERTY_SOURCE_NAME, runtimeProperties)
        environment.propertySources.addFirst(runtimePropertySource)
    }
    
    /**
     * Update transaction analysis configuration at runtime
     */
    fun updateTransactionAnalysisConfiguration(@Valid config: TransactionAnalysisProperties): Boolean {
        return try {
//            if (!config.isValidConfiguration()) {
//                logger.warn("Invalid transaction analysis configuration provided: {}", config)
//                return false
//            }
            
            // Update runtime properties
            runtimeProperties["flow.transaction-analysis.batch-size"] = config.batchSize
            runtimeProperties["flow.transaction-analysis.max-retries"] = config.maxRetries
            runtimeProperties["flow.transaction-analysis.retry-delay-ms"] = config.retryDelayMs
            runtimeProperties["flow.transaction-analysis.enabled"] = config.enabled
            runtimeProperties["flow.transaction-analysis.processing-timeout-ms"] = config.processingTimeoutMs
            runtimeProperties["flow.transaction-analysis.max-concurrent-batches"] = config.maxConcurrentBatches
            
            // Update the properties bean
            transactionAnalysisProperties.batchSize = config.batchSize
            transactionAnalysisProperties.maxRetries = config.maxRetries
            transactionAnalysisProperties.retryDelayMs = config.retryDelayMs
            transactionAnalysisProperties.enabled = config.enabled
            transactionAnalysisProperties.processingTimeoutMs = config.processingTimeoutMs
            transactionAnalysisProperties.maxConcurrentBatches = config.maxConcurrentBatches
            
            // Publish configuration change event
            eventPublisher.publishEvent(ConfigurationChangeEvent(
                "transaction-analysis", 
                mapOf(
                    "batchSize" to config.batchSize,
                    "maxRetries" to config.maxRetries,
                    "retryDelayMs" to config.retryDelayMs,
                    "enabled" to config.enabled,
                    "processingTimeoutMs" to config.processingTimeoutMs,
                    "maxConcurrentBatches" to config.maxConcurrentBatches
                )
            ))
            
            logger.info("Transaction analysis configuration updated successfully: {}", config)
            true
        } catch (e: Exception) {
            logger.error("Failed to update transaction analysis configuration", e)
            false
        }
    }
    
    /**
     * Update Bedrock configuration at runtime
     */
    fun updateBedrockConfiguration(@Valid config: BedrockProperties): Boolean {
        return try {
            if (!config.isValidConfiguration()) {
                logger.warn("Invalid Bedrock configuration provided: {}", config)
                return false
            }
            
            if (!config.isModelSupported(config.modelId)) {
                logger.warn("Unsupported Bedrock model ID: {}", config.modelId)
                return false
            }
            
            // Update runtime properties
            runtimeProperties["aws.bedrock.region"] = config.region
            runtimeProperties["aws.bedrock.model-id"] = config.modelId
            runtimeProperties["aws.bedrock.max-tokens"] = config.maxTokens
            runtimeProperties["aws.bedrock.temperature"] = config.temperature
            runtimeProperties["aws.bedrock.timeout-ms"] = config.timeoutMs
            runtimeProperties["aws.bedrock.max-retries"] = config.maxRetries
            runtimeProperties["aws.bedrock.base-retry-delay-ms"] = config.baseRetryDelayMs
            runtimeProperties["aws.bedrock.max-retry-delay-ms"] = config.maxRetryDelayMs
            
            // Update the properties bean
            bedrockProperties.region = config.region
            bedrockProperties.modelId = config.modelId
            bedrockProperties.maxTokens = config.maxTokens
            bedrockProperties.temperature = config.temperature
            bedrockProperties.timeoutMs = config.timeoutMs
            bedrockProperties.maxRetries = config.maxRetries
            bedrockProperties.baseRetryDelayMs = config.baseRetryDelayMs
            bedrockProperties.maxRetryDelayMs = config.maxRetryDelayMs
            
            // Publish configuration change event
            eventPublisher.publishEvent(ConfigurationChangeEvent(
                "bedrock", 
                mapOf(
                    "region" to config.region,
                    "modelId" to config.modelId,
                    "maxTokens" to config.maxTokens,
                    "temperature" to config.temperature,
                    "timeoutMs" to config.timeoutMs,
                    "maxRetries" to config.maxRetries,
                    "baseRetryDelayMs" to config.baseRetryDelayMs,
                    "maxRetryDelayMs" to config.maxRetryDelayMs
                )
            ))
            
            logger.info("Bedrock configuration updated successfully: {}", config)
            true
        } catch (e: Exception) {
            logger.error("Failed to update Bedrock configuration", e)
            false
        }
    }
    
    /**
     * Get current transaction analysis configuration
     */
    fun getCurrentTransactionAnalysisConfiguration(): TransactionAnalysisProperties {
        return transactionAnalysisProperties.copy()
    }
    
    /**
     * Get current Bedrock configuration
     */
    fun getCurrentBedrockConfiguration(): BedrockProperties {
        return bedrockProperties.copy()
    }
    
    /**
     * Validate configuration without applying changes
     */
    fun validateTransactionAnalysisConfiguration(config: TransactionAnalysisProperties): List<String> {
        val errors = mutableListOf<String>()
        
        if (config.batchSize < 1 || config.batchSize > 1000) {
            errors.add("Batch size must be between 1 and 1000")
        }
        
        if (config.maxRetries < 0 || config.maxRetries > 10) {
            errors.add("Max retries must be between 0 and 10")
        }
        
        if (config.retryDelayMs <= 0 || config.retryDelayMs > 60000) {
            errors.add("Retry delay must be between 1 and 60000 milliseconds")
        }
        
        if (config.processingTimeoutMs <= 0) {
            errors.add("Processing timeout must be positive")
        }
        
        if (config.maxConcurrentBatches < 1 || config.maxConcurrentBatches > 10) {
            errors.add("Max concurrent batches must be between 1 and 10")
        }
        
        return errors
    }
    
    /**
     * Validate Bedrock configuration without applying changes
     */
    fun validateBedrockConfiguration(config: BedrockProperties): List<String> {
        val errors = mutableListOf<String>()
        
        if (config.region.isBlank()) {
            errors.add("AWS region cannot be blank")
        }
        
        if (config.modelId.isBlank()) {
            errors.add("Model ID cannot be blank")
        } else if (!config.isModelSupported(config.modelId)) {
            errors.add("Unsupported model ID: ${config.modelId}")
        }
        
        if (config.maxTokens < 1 || config.maxTokens > 100000) {
            errors.add("Max tokens must be between 1 and 100,000")
        }
        
        if (config.temperature < 0.0 || config.temperature > 2.0) {
            errors.add("Temperature must be between 0.0 and 2.0")
        }
        
        if (config.timeoutMs <= 0 || config.timeoutMs > 300000) {
            errors.add("Timeout must be between 1 and 300,000 milliseconds")
        }
        
        if (config.maxRetries < 1 || config.maxRetries > 5) {
            errors.add("Max retries must be between 1 and 5")
        }
        
        if (config.baseRetryDelayMs <= 0) {
            errors.add("Base retry delay must be positive")
        }
        
        if (config.maxRetryDelayMs <= 0) {
            errors.add("Max retry delay must be positive")
        }
        
        if (config.baseRetryDelayMs > config.maxRetryDelayMs) {
            errors.add("Base retry delay cannot be greater than max retry delay")
        }
        
        return errors
    }
    
    /**
     * Reset configuration to defaults
     */
    fun resetToDefaults() {
        try {
            // Clear runtime properties
            runtimeProperties.clear()
            
            // Reset to default values
            val defaultTransactionAnalysis = TransactionAnalysisProperties()
            val defaultBedrock = BedrockProperties()
            
            updateTransactionAnalysisConfiguration(defaultTransactionAnalysis)
            updateBedrockConfiguration(defaultBedrock)
            
            logger.info("Configuration reset to defaults successfully")
        } catch (e: Exception) {
            logger.error("Failed to reset configuration to defaults", e)
        }
    }
    
    @EventListener
    fun handleConfigurationChange(event: ConfigurationChangeEvent) {
        logger.info("Configuration changed for component: {} with properties: {}", 
                   event.componentName, event.changedProperties)
    }
}

/**
 * Event published when configuration changes
 */
data class ConfigurationChangeEvent(
    val componentName: String,
    val changedProperties: Map<String, Any>
)