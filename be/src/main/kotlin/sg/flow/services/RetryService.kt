package sg.flow.services

import kotlinx.coroutines.delay
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.configs.TransactionAnalysisProperties
import sg.flow.models.exceptions.transaction.TransactionAnalysisException
import kotlin.math.min
import kotlin.math.pow
import kotlin.random.Random

@Service
class RetryService(
    private val transactionAnalysisProperties: TransactionAnalysisProperties,
    private val errorHandler: TransactionAnalysisErrorHandler
) {
    
    private val logger = LoggerFactory.getLogger(RetryService::class.java)
    
    /**
     * Execute an operation with retry logic and exponential backoff
     */
    suspend fun <T> executeWithRetry(
        operation: String,
        maxRetries: Int = transactionAnalysisProperties.maxRetries,
        baseDelayMs: Long = transactionAnalysisProperties.retryDelayMs,
        maxDelayMs: Long = 30000L,
        retryPredicate: (Exception) -> Boolean = { true },
        block: suspend (attempt: Int) -> T
    ): T {
        var lastException: Exception? = null
        
        repeat(maxRetries + 1) { attempt ->
            try {
                logger.debug("Executing {} (attempt {}/{})", operation, attempt + 1, maxRetries + 1)
                return block(attempt)
            } catch (e: Exception) {
                lastException = e
                
                // Check if we should retry
                if (attempt >= maxRetries || !retryPredicate(e)) {
                    logger.error("Operation {} failed permanently after {} attempts", operation, attempt + 1, e)
                    throw e
                }
                
                // Calculate delay with exponential backoff and jitter
                val delayMs = calculateRetryDelay(attempt, baseDelayMs, maxDelayMs)
                
                logger.warn(
                    "Operation {} failed (attempt {}/{}), retrying in {}ms: {}",
                    operation, attempt + 1, maxRetries + 1, delayMs, e.message
                )
                
                delay(delayMs)
            }
        }
        
        // This should never be reached, but just in case
        throw lastException ?: RuntimeException("Unexpected retry loop exit")
    }
    
    /**
     * Execute a Bedrock operation with specific retry logic
     */
    suspend fun <T> executeBedrockWithRetry(
        operation: String,
        transactionId: Long? = null,
        userId: Int? = null,
        block: suspend (attempt: Int) -> T
    ): T {
        return executeWithRetry(
            operation = "Bedrock $operation",
            maxRetries = 3, // Bedrock-specific retry count
            baseDelayMs = 1000L,
            maxDelayMs = 30000L,
            retryPredicate = { exception ->
                when (exception) {
                    is TransactionAnalysisException -> {
                        // Check if it's a retryable Bedrock exception
                        (exception as? sg.flow.models.exceptions.transaction.BedrockAnalysisException)?.retryable ?: false
                    }
                    else -> {
                        // For non-TransactionAnalysisException, check if it's a known retryable error
                        val message = exception.message?.lowercase() ?: ""
                        message.contains("timeout") ||
                        message.contains("throttl") ||
                        message.contains("rate limit") ||
                        message.contains("service unavailable") ||
                        message.contains("internal server error")
                    }
                }
            },
            block = block
        )
    }
    
    /**
     * Execute a database operation with specific retry logic
     */
    suspend fun <T> executeDatabaseWithRetry(
        operation: String,
        transactionId: Long? = null,
        userId: Int? = null,
        block: suspend (attempt: Int) -> T
    ): T {
        return executeWithRetry(
            operation = "Database $operation",
            maxRetries = 2, // Database operations typically shouldn't be retried many times
            baseDelayMs = 500L,
            maxDelayMs = 5000L,
            retryPredicate = { exception ->
                when (exception) {
                    is TransactionAnalysisException -> {
                        // Check if it's a retryable database exception
                        (exception as? sg.flow.models.exceptions.transaction.TransactionAnalysisDatabaseException)?.retryable ?: false
                    }
                    else -> {
                        // For non-TransactionAnalysisException, check if it's a known retryable database error
                        val message = exception.message?.lowercase() ?: ""
                        message.contains("connection") ||
                        message.contains("timeout") ||
                        message.contains("deadlock") ||
                        message.contains("lock wait timeout")
                    }
                }
            },
            block = block
        )
    }
    
    /**
     * Execute a Kafka operation with specific retry logic
     */
    suspend fun <T> executeKafkaWithRetry(
        operation: String,
        userId: Int? = null,
        block: suspend (attempt: Int) -> T
    ): T {
        return executeWithRetry(
            operation = "Kafka $operation",
            maxRetries = transactionAnalysisProperties.maxRetries,
            baseDelayMs = transactionAnalysisProperties.retryDelayMs,
            maxDelayMs = 30000L,
            retryPredicate = { exception ->
                when (exception) {
                    is TransactionAnalysisException -> {
                        // Check if it's a retryable Kafka exception
                        (exception as? sg.flow.models.exceptions.transaction.TransactionAnalysisKafkaException)?.retryable ?: false
                    }
                    else -> {
                        // For non-TransactionAnalysisException, check if it's a known retryable Kafka error
                        val message = exception.message?.lowercase() ?: ""
                        message.contains("timeout") ||
                        message.contains("connection") ||
                        message.contains("retriable") ||
                        message.contains("network") ||
                        message.contains("broker")
                    }
                }
            },
            block = block
        )
    }
    
    /**
     * Calculate retry delay with exponential backoff and jitter
     */
    private fun calculateRetryDelay(
        attempt: Int,
        baseDelayMs: Long,
        maxDelayMs: Long
    ): Long {
        // Exponential backoff: baseDelay * 2^attempt
        val exponentialDelay = baseDelayMs * (2.0.pow(attempt.toDouble())).toLong()
        
        // Cap at maximum delay
        val cappedDelay = min(exponentialDelay, maxDelayMs)
        
        // Add jitter (±25% of the delay) to avoid thundering herd
        val jitterRange = (cappedDelay * 0.25).toLong()
        val jitter = Random.nextLong(-jitterRange, jitterRange + 1)
        
        // Ensure minimum delay of baseDelayMs
        return maxOf(baseDelayMs, cappedDelay + jitter)
    }
    
    /**
     * Create a circuit breaker pattern for operations that fail frequently
     */
    class CircuitBreaker(
        private val failureThreshold: Int = 5,
        private val recoveryTimeoutMs: Long = 60000L,
        private val name: String = "CircuitBreaker"
    ) {
        private var failureCount = 0
        private var lastFailureTime = 0L
        private var state = State.CLOSED
        
        private val logger = LoggerFactory.getLogger(CircuitBreaker::class.java)
        
        enum class State {
            CLOSED,    // Normal operation
            OPEN,      // Failing fast
            HALF_OPEN  // Testing if service recovered
        }
        
        suspend fun <T> execute(operation: suspend () -> T): T {
            when (state) {
                State.OPEN -> {
                    if (System.currentTimeMillis() - lastFailureTime > recoveryTimeoutMs) {
                        state = State.HALF_OPEN
                        logger.info("Circuit breaker {} transitioning to HALF_OPEN", name)
                    } else {
                        throw RuntimeException("Circuit breaker $name is OPEN")
                    }
                }
                State.HALF_OPEN -> {
                    // Allow one request through to test if service recovered
                }
                State.CLOSED -> {
                    // Normal operation
                }
            }
            
            return try {
                val result = operation()
                onSuccess()
                result
            } catch (e: Exception) {
                onFailure()
                throw e
            }
        }
        
        private fun onSuccess() {
            failureCount = 0
            state = State.CLOSED
            logger.debug("Circuit breaker {} reset to CLOSED", name)
        }
        
        private fun onFailure() {
            failureCount++
            lastFailureTime = System.currentTimeMillis()
            
            if (failureCount >= failureThreshold) {
                state = State.OPEN
                logger.warn("Circuit breaker {} opened after {} failures", name, failureCount)
            }
        }
        
        fun getState(): State = state
        fun getFailureCount(): Int = failureCount
    }
}