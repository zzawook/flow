package sg.flow.models.exceptions.transaction

/** Base exception for transaction analysis operations */
abstract class TransactionAnalysisException(
        message: String,
        cause: Throwable? = null,
        val transactionId: Long? = null,
        val userId: Int? = null,
        val errorCode: String? = null
) : RuntimeException(message, cause)

/** Exception thrown when Bedrock API operations fail */
class BedrockAnalysisException(
        message: String,
        cause: Throwable? = null,
        transactionId: Long? = null,
        userId: Int? = null,
        val apiErrorCode: String? = null,
        val retryable: Boolean = true
) : TransactionAnalysisException(message, cause, transactionId, userId, "BEDROCK_ERROR")

/** Exception thrown when database operations fail during transaction analysis */
class TransactionAnalysisDatabaseException(
        message: String,
        cause: Throwable? = null,
        transactionId: Long? = null,
        userId: Int? = null,
        val sqlState: String? = null,
        val retryable: Boolean = false
) : TransactionAnalysisException(message, cause, transactionId, userId, "DATABASE_ERROR")

/** Exception thrown when Kafka operations fail during transaction analysis */
class TransactionAnalysisKafkaException(
        message: String,
        cause: Throwable? = null,
        transactionId: Long? = null,
        userId: Int? = null,
        val topic: String? = null,
        val partition: Int? = null,
        val offset: Long? = null,
        val retryable: Boolean = true
) : TransactionAnalysisException(message, cause, transactionId, userId, "KAFKA_ERROR")

/** Exception thrown when configuration is invalid */
class TransactionAnalysisConfigurationException(
        message: String,
        cause: Throwable? = null,
        val configurationKey: String? = null
) : TransactionAnalysisException(message, cause, errorCode = "CONFIGURATION_ERROR")

/** Exception thrown when processing timeout occurs */
class TransactionAnalysisTimeoutException(
        message: String,
        cause: Throwable? = null,
        transactionId: Long? = null,
        userId: Int? = null,
        val timeoutMs: Long? = null
) : TransactionAnalysisException(message, cause, transactionId, userId, "TIMEOUT_ERROR")

/** Exception thrown when validation fails */
class TransactionAnalysisValidationException(
        message: String,
        cause: Throwable? = null,
        transactionId: Long? = null,
        userId: Int? = null,
        val validationErrors: List<String> = emptyList()
) : TransactionAnalysisException(message, cause, transactionId, userId, "VALIDATION_ERROR")
