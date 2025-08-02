package sg.flow.services.TransactionHistoryServices

import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import kotlinx.coroutines.delay
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.configs.BedrockProperties
import sg.flow.entities.TransactionHistory
import aws.sdk.kotlin.services.bedrockagentruntime.model.InvokeAgentRequest
import aws.sdk.kotlin.services.bedrockagentruntime.model.InvokeAgentResponse
import aws.sdk.kotlin.services.bedrockagentruntime.BedrockAgentRuntimeClient
import java.time.LocalDate
import java.util.*
import kotlin.math.min
import kotlin.math.pow

@Service
class BedrockTransactionAnalysisService(
    private val bedrockAgentRuntimeClient: BedrockAgentRuntimeClient,
    private val bedrockProperties: BedrockProperties,
    private val objectMapper: ObjectMapper
) {

    private val logger = LoggerFactory.getLogger(BedrockTransactionAnalysisService::class.java)
    private val session_id = UUID.randomUUID()

    suspend fun analyzeTransaction(transaction: TransactionHistory): TransactionAnalysisResult {
        return try {
            val prompt = createAnalysisPrompt(transaction.description)
            val response = invokeAgentWithRetry(prompt, transaction.id ?: -1)
            parseAnalysisResponse(response, transaction.id ?: -1)
        } catch (e: Exception) {
            logger.error("Failed to analyze transaction ${transaction.id}: ${e.message}", e)
            TransactionAnalysisResult(
                transactionId = transaction.id ?: -1,
                revisedTransactionDate = null,
                category = null,
                cardNumber = null,
                friendlyDescription = null,
                confidence = 0.0,
                success = false,
                errorMessage = e.message
            )
        }
    }

    suspend fun analyzeTransactionBatch(transactions: List<TransactionHistory>): List<TransactionAnalysisResult> {
        logger.info("Starting batch analysis of ${transactions.size} transactions")

        return transactions.map { transaction ->
            try {
                analyzeTransaction(transaction)
            } catch (e: Exception) {
                logger.error("Failed to analyze transaction ${transaction.id} in batch: ${e.message}", e)
                TransactionAnalysisResult(
                    transactionId = transaction.id ?: -1,
                    revisedTransactionDate = null,
                    category = null,
                    cardNumber = null,
                    friendlyDescription = null,
                    confidence = 0.0,
                    success = false,
                    errorMessage = e.message
                )
            }
        }
    }

    private fun createAnalysisPrompt(description: String): String {
        return """
            Transaction Description: "$description"
        """.trimIndent()
    }

    private suspend fun invokeAgentWithRetry(prompt: String, transactionId: Long): InvokeAgentResponse {
        var lastException: Exception? = null

        repeat(bedrockProperties.maxRetries) { attempt ->
            try {
                logger.debug("Invoking Bedrock agent for transaction $transactionId, attempt ${attempt + 1}")

                val request = InvokeAgentRequest {
                    agentId =  bedrockProperties.agentId
                    agentAliasId = bedrockProperties.agentAliasId
                    inputText = prompt
                }


                return bedrockAgentRuntimeClient.invokeAgent(request) { response ->
                    response
                }

            } catch (e: Exception) {
                lastException = e
                logger.warn("Bedrock agent invocation failed for transaction $transactionId, attempt ${attempt + 1}: ${e.message}")

                if (attempt < bedrockProperties.maxRetries - 1) {
                    val delayMs = calculateRetryDelay(attempt)
                    logger.debug("Retrying in ${delayMs}ms...")
                    delay(delayMs)
                }
            }
        }

        throw lastException ?: RuntimeException("Failed to invoke Bedrock agent after ${bedrockProperties.maxRetries} attempts")
    }

    private fun calculateRetryDelay(attempt: Int): Long {
        val exponentialDelay = bedrockProperties.baseRetryDelayMs * (2.0.pow(attempt)).toLong()
        return min(exponentialDelay, bedrockProperties.maxRetryDelayMs)
    }

    private fun parseAnalysisResponse(response: InvokeAgentResponse, transactionId: Long): TransactionAnalysisResult {
        return try {
            // Extract the completion text from the response
            val completionText = response.toString()
            logger.debug("Bedrock agent response for transaction $transactionId: $completionText")

            // Try to extract JSON from the response
            val jsonResponse = extractJsonFromResponse(completionText)
            val jsonNode = objectMapper.readTree(jsonResponse)

            TransactionAnalysisResult(
                transactionId = transactionId,
                revisedTransactionDate = parseDate(jsonNode.get("revised_transaction_date")),
                category = parseStringField(jsonNode.get("category")),
                cardNumber = parseStringField(jsonNode.get("card_number")),
                friendlyDescription = parseStringField(jsonNode.get("friendly_description")),
                confidence = jsonNode.get("confidence")?.asDouble() ?: 0.0,
                success = true,
                errorMessage = null
            )

        } catch (e: Exception) {
            logger.error("Failed to parse Bedrock agent response for transaction $transactionId: ${e.message}", e)
            TransactionAnalysisResult(
                transactionId = transactionId,
                revisedTransactionDate = null,
                category = null,
                cardNumber = null,
                friendlyDescription = null,
                confidence = 0.0,
                success = false,
                errorMessage = "Failed to parse response: ${e.message}"
            )
        }
    }

    private fun extractJsonFromResponse(response: String): String {
        // Look for JSON content between curly braces
        val jsonStart = response.indexOf('{')
        val jsonEnd = response.lastIndexOf('}')

        return if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
            response.substring(jsonStart, jsonEnd + 1)
        } else {
            // If no JSON found, try to create a minimal valid JSON
            logger.warn("No valid JSON found in response, creating minimal response")
            """{"category": null, "card_number": null, "friendly_description": null, "revised_transaction_date": null, "confidence": 0.0}"""
        }
    }

    private fun parseStringField(jsonNode: JsonNode?): String? {
        return when {
            jsonNode == null -> null
            jsonNode.isNull -> null
            jsonNode.asText().equals("null", ignoreCase = true) -> null
            jsonNode.asText().isBlank() -> null
            else -> jsonNode.asText()
        }
    }

    private fun parseDate(jsonNode: JsonNode?): LocalDate? {
        return try {
            val dateString = parseStringField(jsonNode)
            if (dateString != null) {
                LocalDate.parse(dateString)
            } else {
                null
            }
        } catch (e: Exception) {
            logger.warn("Failed to parse date from JSON node: ${jsonNode?.asText()}")
            null
        }
    }
}

data class TransactionAnalysisResult(
    val transactionId: Long,
    val revisedTransactionDate: LocalDate?,
    val category: String?,
    val cardNumber: String?,
    val friendlyDescription: String?,
    val confidence: Double,
    val success: Boolean,
    val errorMessage: String? = null
)