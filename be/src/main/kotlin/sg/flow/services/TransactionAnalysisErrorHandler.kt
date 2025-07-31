package sg.flow.services

import java.sql.SQLException
import java.time.Instant
import java.util.concurrent.ConcurrentHashMap
import kotlinx.coroutines.delay
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.dao.DataAccessException
import org.springframework.kafka.KafkaException
import org.springframework.stereotype.Service
import sg.flow.configs.BedrockProperties
import sg.flow.configs.TransactionAnalysisProperties
import sg.flow.entities.TransactionHistory
import sg.flow.events.TransactionAnalysisTriggerEvent
import sg.flow.models.exceptions.transaction.*
import software.amazon.awssdk.services.bedrockruntime.model.BedrockRuntimeException

@Service
class TransactionAnalysisErrorHandler(
        private val transactionAnalysisProperties: TransactionAnalysisProperties,
        private val bedrockProperties: BedrockProperties
) {

        private val logger = LoggerFactory.getLogger(TransactionAnalysisErrorHandler::class.java)
        private val errorMetrics = ConcurrentHashMap<String, ErrorMetrics>()

        companion object {
                private const val MDC_TRANSACTION_ID = "transactionId"
                private const val MDC_USER_ID = "userId"
                private const val MDC_ERROR_CODE = "errorCode"
                private const val MDC_RETRY_ATTEMPT = "retryAttempt"
        }

        /** Handle Bedrock API errors with retry logic and exponential backoff */
        suspend fun handleBedrockError(
                error: Exception,
                transaction: TransactionHistory,
                attempt: Int = 0
        ): TransactionAnalysisResult {
                val transactionId = transaction.id ?: 0L
                val userId = transaction.account?.owner?.id ?: 0

                // Set up MDC for structured logging
                MDC.put(MDC_TRANSACTION_ID, transactionId.toString())
                MDC.put(MDC_USER_ID, userId.toString())
                MDC.put(MDC_ERROR_CODE, "BEDROCK_ERROR")
                MDC.put(MDC_RETRY_ATTEMPT, attempt.toString())

                try {
                        val bedrockException =
                                when (error) {
                                        is BedrockRuntimeException -> {
                                                val retryable = isBedrockErrorRetryable(error)
                                                BedrockAnalysisException(
                                                        "Bedrock API error: ${error.message}",
                                                        error,
                                                        transactionId,
                                                        userId,
                                                        error.awsErrorDetails()?.errorCode(),
                                                        retryable
                                                )
                                        }
                                        is BedrockAnalysisException -> error
                                        else ->
                                                BedrockAnalysisException(
                                                        "Unexpected Bedrock error: ${error.message}",
                                                        error,
                                                        transactionId,
                                                        userId,
                                                        retryable = false
                                                )
                                }

                        // Log the error with context
                        logError(bedrockException, transaction, attempt)

                        // Update error metrics
                        updateErrorMetrics("BEDROCK_ERROR", bedrockException.retryable)

                        // Determine if we should retry
                        if (bedrockException.retryable && attempt < bedrockProperties.maxRetries) {
                                val delayMs = bedrockProperties.getRetryDelayForAttempt(attempt)

                                logger.warn(
                                        "Retrying Bedrock API call for transaction {} in {}ms (attempt {}/{})",
                                        transactionId,
                                        delayMs,
                                        attempt + 1,
                                        bedrockProperties.maxRetries
                                )

                                delay(delayMs)
                                throw bedrockException // Re-throw to trigger retry
                        }

                        // Max retries exceeded or non-retryable error
                        logger.error(
                                "Bedrock analysis failed permanently for transaction {} after {} attempts",
                                transactionId,
                                attempt + 1
                        )

                        return TransactionAnalysisResult(
                                transactionId = transactionId,
                                revisedTransactionDate = null,
                                category = null,
                                cardNumber = null,
                                friendlyDescription = null,
                                confidence = 0.0,
                                success = false,
                                errorMessage =
                                        "Bedrock analysis failed: ${bedrockException.message}"
                        )
                } finally {
                        MDC.clear()
                }
        }

        /** Handle database errors with appropriate retry logic */
        suspend fun handleDatabaseError(
                error: Exception,
                transactionId: Long? = null,
                userId: Int? = null,
                operation: String = "unknown"
        ): Boolean {
                // Set up MDC for structured logging
                transactionId?.let { MDC.put(MDC_TRANSACTION_ID, it.toString()) }
                userId?.let { MDC.put(MDC_USER_ID, it.toString()) }
                MDC.put(MDC_ERROR_CODE, "DATABASE_ERROR")

                try {
                        val dbException =
                                when (error) {
                                        is SQLException -> {
                                                val retryable = isDatabaseErrorRetryable(error)
                                                TransactionAnalysisDatabaseException(
                                                        "Database error during $operation: ${error.message}",
                                                        error,
                                                        transactionId,
                                                        userId,
                                                        error.sqlState,
                                                        retryable
                                                )
                                        }
                                        is DataAccessException -> {
                                                val retryable = isDatabaseErrorRetryable(error)
                                                TransactionAnalysisDatabaseException(
                                                        "Data access error during $operation: ${error.message}",
                                                        error,
                                                        transactionId,
                                                        userId,
                                                        retryable = retryable
                                                )
                                        }
                                        is TransactionAnalysisDatabaseException -> error
                                        else ->
                                                TransactionAnalysisDatabaseException(
                                                        "Unexpected database error during $operation: ${error.message}",
                                                        error,
                                                        transactionId,
                                                        userId,
                                                        retryable = false
                                                )
                                }

                        // Log the error with context
                        logger.error(
                                "Database error during {} for transaction {}: {} (SQL State: {}, Retryable: {})",
                                operation,
                                transactionId,
                                dbException.message,
                                dbException.sqlState,
                                dbException.retryable,
                                dbException
                        )

                        // Update error metrics
                        updateErrorMetrics("DATABASE_ERROR", dbException.retryable)

                        return dbException.retryable
                } finally {
                        MDC.clear()
                }
        }

        /** Handle Kafka errors with retry logic */
        suspend fun handleKafkaError(
                error: Exception,
                event: TransactionAnalysisTriggerEvent,
                attempt: Int = 0
        ): Boolean {
                // Set up MDC for structured logging
                MDC.put(MDC_USER_ID, event.userId.toString())
                MDC.put(MDC_ERROR_CODE, "KAFKA_ERROR")
                MDC.put(MDC_RETRY_ATTEMPT, attempt.toString())

                try {
                        val kafkaException =
                                when (error) {
                                        is KafkaException -> {
                                                val retryable = isKafkaErrorRetryable(error)
                                                TransactionAnalysisKafkaException(
                                                        "Kafka error: ${error.message}",
                                                        error,
                                                        userId = event.userId,
                                                        retryable = retryable
                                                )
                                        }
                                        is TransactionAnalysisKafkaException -> error
                                        else ->
                                                TransactionAnalysisKafkaException(
                                                        "Unexpected Kafka error: ${error.message}",
                                                        error,
                                                        userId = event.userId,
                                                        retryable = false
                                                )
                                }

                        // Log the error with context
                        logger.error(
                                "Kafka error for user {} (attempt {}): {} (Retryable: {})",
                                event.userId,
                                attempt + 1,
                                kafkaException.message,
                                kafkaException.retryable,
                                kafkaException
                        )

                        // Update error metrics
                        updateErrorMetrics("KAFKA_ERROR", kafkaException.retryable)

                        // Determine if we should retry
                        if (kafkaException.retryable &&
                                        attempt < transactionAnalysisProperties.maxRetries
                        ) {
                                val delayMs =
                                        transactionAnalysisProperties.getRetryDelayForAttempt(
                                                attempt
                                        )

                                logger.warn(
                                        "Will retry Kafka operation for user {} in {}ms (attempt {}/{})",
                                        event.userId,
                                        delayMs,
                                        attempt + 1,
                                        transactionAnalysisProperties.maxRetries
                                )

                                delay(delayMs)
                                return true // Indicate retry should happen
                        }

                        // Max retries exceeded or non-retryable error
                        logger.error(
                                "Kafka operation failed permanently for user {} after {} attempts",
                                event.userId,
                                attempt + 1
                        )

                        return false // Indicate no more retries
                } finally {
                        MDC.clear()
                }
        }

        /** Handle timeout errors */
        fun handleTimeoutError(
                timeoutMs: Long,
                transactionId: Long? = null,
                userId: Int? = null,
                operation: String = "unknown"
        ): TransactionAnalysisTimeoutException {
                // Set up MDC for structured logging
                transactionId?.let { MDC.put(MDC_TRANSACTION_ID, it.toString()) }
                userId?.let { MDC.put(MDC_USER_ID, it.toString()) }
                MDC.put(MDC_ERROR_CODE, "TIMEOUT_ERROR")

                try {
                        val timeoutException =
                                TransactionAnalysisTimeoutException(
                                        "Operation $operation timed out after ${timeoutMs}ms",
                                        transactionId = transactionId,
                                        userId = userId,
                                        timeoutMs = timeoutMs
                                )

                        logger.error(
                                "Timeout error during {} for transaction {} (timeout: {}ms)",
                                operation,
                                transactionId,
                                timeoutMs,
                                timeoutException
                        )

                        // Update error metrics
                        updateErrorMetrics("TIMEOUT_ERROR", false)

                        return timeoutException
                } finally {
                        MDC.clear()
                }
        }

        /** Handle validation errors */
        fun handleValidationError(
                validationErrors: List<String>,
                transactionId: Long? = null,
                userId: Int? = null
        ): TransactionAnalysisValidationException {
                // Set up MDC for structured logging
                transactionId?.let { MDC.put(MDC_TRANSACTION_ID, it.toString()) }
                userId?.let { MDC.put(MDC_USER_ID, it.toString()) }
                MDC.put(MDC_ERROR_CODE, "VALIDATION_ERROR")

                try {
                        val validationException =
                                TransactionAnalysisValidationException(
                                        "Validation failed: ${validationErrors.joinToString(", ")}",
                                        transactionId = transactionId,
                                        userId = userId,
                                        validationErrors = validationErrors
                                )

                        logger.error(
                                "Validation error for transaction {}: {}",
                                transactionId,
                                validationErrors.joinToString(", "),
                                validationException
                        )

                        // Update error metrics
                        updateErrorMetrics("VALIDATION_ERROR", false)

                        return validationException
                } finally {
                        MDC.clear()
                }
        }

        /** Get error metrics for monitoring */
        fun getErrorMetrics(): Map<String, ErrorMetrics> {
                return errorMetrics.toMap()
        }

        /** Reset error metrics */
        fun resetErrorMetrics() {
                errorMetrics.clear()
                logger.info("Error metrics reset")
        }

        private fun logError(
                exception: TransactionAnalysisException,
                transaction: TransactionHistory,
                attempt: Int
        ) {
                logger.error(
                        "Transaction analysis error for transaction {} (user: {}, attempt: {}): {} (Error Code: {}, Retryable: {})",
                        transaction.id,
                        transaction.account?.owner?.id,
                        attempt + 1,
                        exception.message,
                        exception.errorCode,
                        (exception as? BedrockAnalysisException)?.retryable ?: false,
                        exception
                )
        }

        private fun isBedrockErrorRetryable(error: BedrockRuntimeException): Boolean {
                return when {
                        error.statusCode() in 500..599 -> true // Server errors
                        error.statusCode() == 429 -> true // Rate limiting
                        error.awsErrorDetails()?.errorCode() in
                                listOf(
                                        "ThrottlingException",
                                        "ServiceUnavailableException",
                                        "InternalServerException"
                                ) -> true
                        else -> false
                }
        }

        private fun isDatabaseErrorRetryable(error: Exception): Boolean {
                return when (error) {
                        is SQLException ->
                                when (error.sqlState) {
                                        "08000", "08003", "08006" -> true // Connection errors
                                        "40001" -> true // Serialization failure
                                        "53000", "53100", "53200", "53300" ->
                                                true // Resource unavailable
                                        else -> false
                                }
                        is DataAccessException -> {
                                val message = error.message?.lowercase() ?: ""
                                message.contains("connection") ||
                                        message.contains("timeout") ||
                                        message.contains("deadlock")
                        }
                        else -> false
                }
        }

        private fun isKafkaErrorRetryable(error: KafkaException): Boolean {
                val message = error.message?.lowercase() ?: ""
                return message.contains("timeout") ||
                        message.contains("connection") ||
                        message.contains("retriable") ||
                        message.contains("network")
        }

        private fun updateErrorMetrics(errorType: String, retryable: Boolean) {
                errorMetrics.compute(errorType) { _, existing ->
                        val current = existing ?: ErrorMetrics()
                        current.copy(
                                totalCount = current.totalCount + 1,
                                retryableCount =
                                        if (retryable) current.retryableCount + 1
                                        else current.retryableCount,
                                lastOccurrence = Instant.now()
                        )
                }
        }
}

/** Data class for tracking error metrics */
data class ErrorMetrics(
        val totalCount: Long = 0,
        val retryableCount: Long = 0,
        val lastOccurrence: Instant? = null
)

/** Data class for transaction analysis results */
data class TransactionAnalysisResult(
        val transactionId: Long,
        val revisedTransactionDate: java.time.LocalDate?,
        val category: String?,
        val cardNumber: String?,
        val friendlyDescription: String?,
        val confidence: Double,
        val success: Boolean,
        val errorMessage: String? = null
)
