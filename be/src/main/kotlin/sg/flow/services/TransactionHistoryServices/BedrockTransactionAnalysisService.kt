package sg.flow.services.TransactionHistoryServices

import com.fasterxml.jackson.databind.ObjectMapper
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.DateTimeParseException
import kotlin.math.pow
import kotlinx.coroutines.delay
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.configs.BedrockProperties
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.*
import software.amazon.awssdk.core.SdkBytes
import software.amazon.awssdk.services.bedrockruntime.BedrockRuntimeClient
import software.amazon.awssdk.services.bedrockruntime.model.InvokeModelRequest
import software.amazon.awssdk.services.bedrockruntime.model.InvokeModelResponse

@Service
class BedrockTransactionAnalysisService(
        private val bedrockClient: BedrockRuntimeClient,
        private val bedrockProperties: BedrockProperties,
        private val objectMapper: ObjectMapper
) {
    private val logger = LoggerFactory.getLogger(BedrockTransactionAnalysisService::class.java)

    suspend fun analyzeTransaction(transaction: TransactionHistory): TransactionAnalysisResult {
        return analyzeTransactionBatch(listOf(transaction)).first()
    }

    suspend fun analyzeTransactionBatch(
            transactions: List<TransactionHistory>
    ): List<TransactionAnalysisResult> {
        if (transactions.isEmpty()) {
            return emptyList()
        }

        return try {
            val request = createBedrockRequest(transactions)
            val response = invokeBedrockWithRetry(request)
            parseBedrockResponse(response, transactions)
        } catch (e: Exception) {
            logger.error("Failed to analyze transaction batch of size ${transactions.size}", e)
            transactions.map { createFailedResult(it.id!!, e.message) }
        }
    }

    private fun createBedrockRequest(
            transactions: List<TransactionHistory>
    ): BedrockAnalysisRequest {
        val transactionsForAnalysis =
                transactions.map { transaction ->
                    TransactionForAnalysis(
                            id = transaction.id!!,
                            description = transaction.description,
                            amount = transaction.amount,
                            transactionDate = transaction.transactionDate.toString(),
                            transactionType = transaction.transactionType
                    )
                }
        return BedrockAnalysisRequest(transactionsForAnalysis)
    }

    private suspend fun invokeBedrockWithRetry(
            request: BedrockAnalysisRequest
    ): InvokeModelResponse {
        var lastException: Exception? = null
        var retryCount = 0
        val maxRetries = 3

        while (retryCount <= maxRetries) {
            try {
                return invokeBedrock(request)
            } catch (e: Exception) {
                lastException = e
                retryCount++

                if (retryCount <= maxRetries) {
                    val delayMs = (1000 * 2.0.pow(retryCount - 1)).toLong()
                    logger.warn(
                            "Bedrock API call failed (attempt $retryCount/$maxRetries), retrying in ${delayMs}ms",
                            e
                    )
                    delay(delayMs)
                } else {
                    logger.error("Bedrock API call failed after $maxRetries retries", e)
                }
            }
        }

        throw lastException ?: RuntimeException("Unknown error during Bedrock API calls")
    }

    private fun invokeBedrock(request: BedrockAnalysisRequest): InvokeModelResponse {
        val prompt = createPrompt(request)
        val requestBody = createClaudeRequestBody(prompt)
        val requestBodyJson = objectMapper.writeValueAsString(requestBody)

        val invokeRequest =
                InvokeModelRequest.builder()
                        .modelId(bedrockProperties.modelId)
                        .body(SdkBytes.fromUtf8String(requestBodyJson))
                        .contentType("application/json")
                        .accept("application/json")
                        .build()

        return bedrockClient.invokeModel(invokeRequest)
    }

    private fun createPrompt(request: BedrockAnalysisRequest): String {
        val transactionsJson = objectMapper.writeValueAsString(request.transactions)

        return """
            You are a financial transaction analysis expert. Analyze the following transactions and provide structured information for each one.

            For each transaction, extract:
            1. category: A general category (e.g., "Food & Dining", "Transportation", "Shopping", "Bills & Utilities", "Entertainment", "Healthcare", "Travel", "Other")
            2. friendly_description: A clean, readable description of the merchant/transaction (e.g., "Starbucks Coffee" instead of "STARBUCKS STORE #1234 SEATTLE WA")
            3. extracted_card_number: Any card number mentioned in the description (last 4 digits format like "*1234")
            4. revised_transaction_date: If the description contains a different date than the transaction_date, extract it in YYYY-MM-DD format

            Transactions to analyze:
            $transactionsJson

            Respond with a JSON object in this exact format:
            {
              "results": [
                {
                  "transaction_id": 123,
                  "category": "Food & Dining",
                  "friendly_description": "Starbucks Coffee",
                  "extracted_card_number": "*1234",
                  "revised_transaction_date": "2024-01-15",
                  "confidence": 0.95
                }
              ]
            }

            Rules:
            - Always include all transaction_ids from the input
            - Use null for fields that cannot be determined
            - Confidence should be between 0.0 and 1.0
            - Keep friendly_description concise and readable
            - Only extract card numbers if clearly present in the description
            - Only provide revised_transaction_date if different from the original date
        """.trimIndent()
    }

    private fun createClaudeRequestBody(prompt: String): Map<String, Any> {
        return mapOf(
                "anthropic_version" to "bedrock-2023-05-31",
                "max_tokens" to bedrockProperties.maxTokens,
                "temperature" to bedrockProperties.temperature,
                "messages" to listOf(mapOf("role" to "user", "content" to prompt))
        )
    }

    private fun parseBedrockResponse(
            response: InvokeModelResponse,
            originalTransactions: List<TransactionHistory>
    ): List<TransactionAnalysisResult> {
        return try {
            val responseBody = response.body().asUtf8String()
            val claudeResponse = objectMapper.readValue(responseBody, Map::class.java)
            val content = (claudeResponse["content"] as List<*>).first() as Map<*, *>
            val responseText = content["text"] as String

            // Extract JSON from the response text
            val jsonStart = responseText.indexOf("{")
            val jsonEnd = responseText.lastIndexOf("}") + 1
            val jsonResponse = responseText.substring(jsonStart, jsonEnd)

            val analysisResponse =
                    objectMapper.readValue(jsonResponse, BedrockAnalysisResponse::class.java)

            // Convert to TransactionAnalysisResult
            analysisResponse.results.map { result ->
                TransactionAnalysisResult(
                        transactionId = result.transactionId,
                        revisedTransactionDate = parseDate(result.revisedTransactionDate),
                        category = result.category,
                        cardNumber = result.extractedCardNumber,
                        friendlyDescription = result.friendlyDescription,
                        confidence = result.confidence,
                        success = true
                )
            }
        } catch (e: Exception) {
            logger.error("Failed to parse Bedrock response", e)
            originalTransactions.map {
                createFailedResult(it.id!!, "Failed to parse response: ${e.message}")
            }
        }
    }

    private fun parseDate(dateString: String?): LocalDate? {
        if (dateString.isNullOrBlank()) return null

        return try {
            LocalDate.parse(dateString, DateTimeFormatter.ISO_LOCAL_DATE)
        } catch (e: DateTimeParseException) {
            logger.warn("Failed to parse date: $dateString", e)
            null
        }
    }

    private fun createFailedResult(
            transactionId: Long,
            errorMessage: String?
    ): TransactionAnalysisResult {
        return TransactionAnalysisResult(
                transactionId = transactionId,
                revisedTransactionDate = null,
                category = null,
                cardNumber = null,
                friendlyDescription = null,
                confidence = 0.0,
                success = false,
                errorMessage = errorMessage
        )
    }
}
