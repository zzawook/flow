package sg.flow.services

import java.time.Instant
import java.time.format.DateTimeFormatter
import org.slf4j.LoggerFactory
import org.slf4j.MDC
import org.springframework.stereotype.Service
import sg.flow.entities.TransactionHistory
import sg.flow.events.TransactionAnalysisTriggerEvent

@Service
class TransactionAnalysisLogger {

    private val logger = LoggerFactory.getLogger(TransactionAnalysisLogger::class.java)

    companion object {
        // MDC Keys for structured logging
        const val MDC_TRANSACTION_ID = "transactionId"
        const val MDC_USER_ID = "userId"
        const val MDC_INSTITUTION_ID = "institutionId"
        const val MDC_LOGIN_IDENTITY_ID = "loginIdentityId"
        const val MDC_BATCH_ID = "batchId"
        const val MDC_BATCH_SIZE = "batchSize"
        const val MDC_PROCESSING_STAGE = "processingStage"
        const val MDC_ERROR_CODE = "errorCode"
        const val MDC_RETRY_ATTEMPT = "retryAttempt"
        const val MDC_PROCESSING_TIME_MS = "processingTimeMs"
        const val MDC_BEDROCK_MODEL = "bedrockModel"
        const val MDC_CONFIDENCE_SCORE = "confidenceScore"

        // Processing stages
        const val STAGE_TRIGGER_RECEIVED = "TRIGGER_RECEIVED"
        const val STAGE_FETCHING_TRANSACTIONS = "FETCHING_TRANSACTIONS"
        const val STAGE_BEDROCK_ANALYSIS = "BEDROCK_ANALYSIS"
        const val STAGE_DATABASE_UPDATE = "DATABASE_UPDATE"
        const val STAGE_PROCESSING_COMPLETE = "PROCESSING_COMPLETE"
        const val STAGE_ERROR_HANDLING = "ERROR_HANDLING"
    }

    /** Log trigger event received */
    fun logTriggerReceived(event: TransactionAnalysisTriggerEvent) {
        withEventContext(event) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_TRIGGER_RECEIVED)
            logger.info(
                    "Transaction analysis trigger received for user {} from institution {} (loginIdentityId: {}, totalTransactions: {})",
                    event.userId,
                    event.institutionId,
                    event.loginIdentityId,
                    event.totalTransactionsRetrieved
            )
        }
    }

    /** Log start of transaction fetching */
    fun logFetchingTransactions(event: TransactionAnalysisTriggerEvent) {
        withEventContext(event) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_FETCHING_TRANSACTIONS)
            logger.info("Fetching unprocessed transactions for user {}", event.userId)
        }
    }

    /** Log transactions fetched */
    fun logTransactionsFetched(
            event: TransactionAnalysisTriggerEvent,
            transactionCount: Int,
            processingTimeMs: Long
    ) {
        withEventContext(event) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_FETCHING_TRANSACTIONS)
            MDC.put(MDC_PROCESSING_TIME_MS, processingTimeMs.toString())
            logger.info(
                    "Fetched {} unprocessed transactions for user {} in {}ms",
                    transactionCount,
                    event.userId,
                    processingTimeMs
            )
        }
    }

    /** Log start of batch processing */
    fun logBatchProcessingStart(
            event: TransactionAnalysisTriggerEvent,
            batchId: String,
            batchSize: Int,
            totalBatches: Int,
            currentBatch: Int
    ) {
        withEventContext(event) {
            MDC.put(MDC_BATCH_ID, batchId)
            MDC.put(MDC_BATCH_SIZE, batchSize.toString())
            MDC.put(MDC_PROCESSING_STAGE, STAGE_BEDROCK_ANALYSIS)
            logger.info(
                    "Starting batch processing {} (batch {}/{}, size: {}) for user {}",
                    batchId,
                    currentBatch,
                    totalBatches,
                    batchSize,
                    event.userId
            )
        }
    }

    /** Log Bedrock analysis start */
    fun logBedrockAnalysisStart(
            transaction: TransactionHistory,
            modelId: String,
            attempt: Int = 0
    ) {
        withTransactionContext(transaction) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_BEDROCK_ANALYSIS)
            MDC.put(MDC_BEDROCK_MODEL, modelId)
            MDC.put(MDC_RETRY_ATTEMPT, attempt.toString())
            logger.debug(
                    "Starting Bedrock analysis for transaction {} using model {} (attempt {})",
                    transaction.id,
                    modelId,
                    attempt + 1
            )
        }
    }

    /** Log Bedrock analysis completion */
    fun logBedrockAnalysisComplete(
            transaction: TransactionHistory,
            result: TransactionAnalysisResult,
            processingTimeMs: Long
    ) {
        withTransactionContext(transaction) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_BEDROCK_ANALYSIS)
            MDC.put(MDC_PROCESSING_TIME_MS, processingTimeMs.toString())
            MDC.put(MDC_CONFIDENCE_SCORE, result.confidence.toString())

            if (result.success) {
                logger.info(
                        "Bedrock analysis completed for transaction {} in {}ms (confidence: {}, category: {}, card: {})",
                        transaction.id,
                        processingTimeMs,
                        result.confidence,
                        result.category ?: "none",
                        result.cardNumber ?: "none"
                )
            } else {
                logger.warn(
                        "Bedrock analysis failed for transaction {} in {}ms: {}",
                        transaction.id,
                        processingTimeMs,
                        result.errorMessage
                )
            }
        }
    }

    /** Log database update start */
    fun logDatabaseUpdateStart(transactionIds: List<Long>, userId: Int) {
        MDC.put(MDC_USER_ID, userId.toString())
        MDC.put(MDC_PROCESSING_STAGE, STAGE_DATABASE_UPDATE)
        logger.debug(
                "Starting database update for {} transactions (user: {})",
                transactionIds.size,
                userId
        )
    }

    /** Log database update completion */
    fun logDatabaseUpdateComplete(updatedCount: Int, userId: Int, processingTimeMs: Long) {
        MDC.put(MDC_USER_ID, userId.toString())
        MDC.put(MDC_PROCESSING_STAGE, STAGE_DATABASE_UPDATE)
        MDC.put(MDC_PROCESSING_TIME_MS, processingTimeMs.toString())
        logger.info(
                "Database update completed for {} transactions (user: {}) in {}ms",
                updatedCount,
                userId,
                processingTimeMs
        )
    }

    /** Log processing completion */
    fun logProcessingComplete(
            event: TransactionAnalysisTriggerEvent,
            totalProcessed: Int,
            successCount: Int,
            failureCount: Int,
            totalProcessingTimeMs: Long
    ) {
        withEventContext(event) {
            MDC.put(MDC_PROCESSING_STAGE, STAGE_PROCESSING_COMPLETE)
            MDC.put(MDC_PROCESSING_TIME_MS, totalProcessingTimeMs.toString())
            logger.info(
                    "Transaction analysis processing completed for user {}: {} total, {} successful, {} failed in {}ms",
                    event.userId,
                    totalProcessed,
                    successCount,
                    failureCount,
                    totalProcessingTimeMs
            )
        }
    }

    /** Log error with context */
    fun logError(
            error: Exception,
            stage: String,
            transactionId: Long? = null,
            userId: Int? = null,
            additionalContext: Map<String, String> = emptyMap()
    ) {
        transactionId?.let { MDC.put(MDC_TRANSACTION_ID, it.toString()) }
        userId?.let { MDC.put(MDC_USER_ID, it.toString()) }
        MDC.put(MDC_PROCESSING_STAGE, STAGE_ERROR_HANDLING)

        // Add additional context to MDC
        additionalContext.forEach { (key, value) -> MDC.put(key, value) }

        logger.error(
                "Error during {} for transaction {} (user: {}): {}",
                stage,
                transactionId,
                userId,
                error.message,
                error
        )
    }

    /** Log performance metrics */
    fun logPerformanceMetrics(
            operation: String,
            count: Int,
            totalTimeMs: Long,
            averageTimeMs: Double,
            minTimeMs: Long,
            maxTimeMs: Long,
            userId: Int? = null
    ) {
        userId?.let { MDC.put(MDC_USER_ID, it.toString()) }
        MDC.put(MDC_PROCESSING_TIME_MS, totalTimeMs.toString())

        logger.info(
                "Performance metrics for {}: count={}, total={}ms, avg={:.2f}ms, min={}ms, max={}ms",
                operation,
                count,
                totalTimeMs,
                averageTimeMs,
                minTimeMs,
                maxTimeMs
        )
    }

    /** Log configuration change */
    fun logConfigurationChange(
            component: String,
            changedProperties: Map<String, Any>,
            userId: Int? = null
    ) {
        userId?.let { MDC.put(MDC_USER_ID, it.toString()) }

        logger.info(
                "Configuration changed for {}: {}",
                component,
                changedProperties.entries.joinToString(", ") { "${it.key}=${it.value}" }
        )
    }

    /** Log health check status */
    fun logHealthCheck(
            component: String,
            healthy: Boolean,
            details: String? = null,
            responseTimeMs: Long? = null
    ) {
        responseTimeMs?.let { MDC.put(MDC_PROCESSING_TIME_MS, it.toString()) }

        val status = if (healthy) "HEALTHY" else "UNHEALTHY"
        val message =
                if (details != null) {
                    "Health check for {} is {}: {}"
                } else {
                    "Health check for {} is {}"
                }

        if (healthy) {
            if (details != null) {
                logger.info(message, component, status, details)
            } else {
                logger.info(message, component, status)
            }
        } else {
            if (details != null) {
                logger.warn(message, component, status, details)
            } else {
                logger.warn(message, component, status)
            }
        }
    }

    /** Execute block with event context in MDC */
    private inline fun withEventContext(event: TransactionAnalysisTriggerEvent, block: () -> Unit) {
        val originalMdc = MDC.getCopyOfContextMap()
        try {
            MDC.put(MDC_USER_ID, event.userId.toString())
            MDC.put(MDC_INSTITUTION_ID, event.institutionId)
            MDC.put(MDC_LOGIN_IDENTITY_ID, event.loginIdentityId)
            block()
        } finally {
            if (originalMdc != null) {
                MDC.setContextMap(originalMdc)
            } else {
                MDC.clear()
            }
        }
    }

    /** Execute block with transaction context in MDC */
    private inline fun withTransactionContext(transaction: TransactionHistory, block: () -> Unit) {
        val originalMdc = MDC.getCopyOfContextMap()
        try {
            MDC.put(MDC_TRANSACTION_ID, (transaction.id ?: 0L).toString())
            MDC.put(MDC_USER_ID, (transaction.account?.owner?.id ?: 0).toString())
            block()
        } finally {
            if (originalMdc != null) {
                MDC.setContextMap(originalMdc)
            } else {
                MDC.clear()
            }
        }
    }

    /** Clear all MDC context */
    fun clearContext() {
        MDC.clear()
    }

    /** Get current timestamp for logging */
    private fun getCurrentTimestamp(): String {
        return DateTimeFormatter.ISO_INSTANT.format(Instant.now())
    }
}
