package sg.flow.services.TransactionHistoryServices

import aws.sdk.kotlin.services.bedrockagentruntime.BedrockAgentRuntimeClient
import aws.sdk.kotlin.services.bedrockagentruntime.model.BedrockModelConfigurations
import aws.sdk.kotlin.services.bedrockagentruntime.model.InvokeAgentRequest
import com.fasterxml.jackson.databind.JsonNode
import com.fasterxml.jackson.databind.ObjectMapper
import java.time.LocalDate
import java.util.*
import kotlin.math.min
import kotlin.math.pow
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.single
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.configs.BedrockProperties
import sg.flow.entities.TransactionHistory

@Service
class BedrockTransactionAnalysisService(
        private val bedrockAgentRuntimeClient: BedrockAgentRuntimeClient,
        private val bedrockProperties: BedrockProperties,
        private val objectMapper: ObjectMapper
) {

    private val logger = LoggerFactory.getLogger(BedrockTransactionAnalysisService::class.java)

    suspend fun analyzeSingleTransaction(
            transaction: TransactionHistory
    ): TransactionAnalysisResult {
        return try {
            val transactionId =
                    transaction.id
                            ?: throw IllegalArgumentException("Transaction ID cannot be null")
            logger.debug("Analyzing single transaction with id: $transactionId")
            val prompt = createSingleTransactionPrompt(transaction)
            val response = invokeAgentWithRetry(prompt, transactionId)
            val analysisResponse = parseSingleTransactionResponse(response, transactionId)
            analysisResponse
        } catch (e: Exception) {
            val transactionId = transaction.id ?: -1L
            logger.error("Failed to analyze transaction $transactionId: ${e.message}", e)
            TransactionAnalysisResult(
                    transactionId = transactionId,
                    revisedTransactionDate = null,
                    category = null,
                    cardNumber = null,
                    brandName = null,
                    brandDomain = null,
                    friendlyDescription = null,
                    confidence = 0.0,
                    success = false,
                    errorMessage = e.message
            )
        }
    }

    private fun createSingleTransactionPrompt(transaction: TransactionHistory): String {
        return """
            {
                transaction_id: ${transaction.id},
                Description: ${transaction.description},
                Transaction registry date: ${transaction.transactionDate}
            }
        """.trimIndent()
    }

    private suspend fun invokeAgentWithRetry(prompt: String, transactionId: Long): String {
        var lastException: Exception? = null
        val sid = "txn-${System.currentTimeMillis()}"

        repeat(bedrockProperties.maxRetries) { attempt ->
            try {
                val request = InvokeAgentRequest {
                    agentId = bedrockProperties.agentId
                    agentAliasId = bedrockProperties.agentAliasId
                    inputText = prompt
                    sessionId = sid
                    enableTrace = false

                    BedrockModelConfigurations

                    streamingConfigurations { streamFinalResponse = false }
                }
                // Extract the completion text from the response
                val completionBuilder = StringBuilder()

                return bedrockAgentRuntimeClient.invokeAgent(request) { response ->
                    val chunk =
                            response.completion?.single()?.asChunkOrNull()?.bytes?.decodeToString()
                    if (chunk != null) {
                        completionBuilder.append(chunk)
                    }

                    completionBuilder.toString()
                }
            } catch (e: Exception) {
                lastException = e
                logger.warn(
                        "Bedrock agent invocation failed for transaction $transactionId, attempt ${attempt + 1}: ${e.message}"
                )

                if (attempt < bedrockProperties.maxRetries - 1) {
                    val delayMs = calculateRetryDelay(attempt)
                    logger.debug("Retrying in ${delayMs}ms...")
                    delay(delayMs)
                }
            }
        }

        throw lastException
                ?: RuntimeException(
                        "Failed to invoke Bedrock agent after ${bedrockProperties.maxRetries} attempts"
                )
    }

    private fun calculateRetryDelay(attempt: Int): Long {
        val exponentialDelay = bedrockProperties.baseRetryDelayMs * (2.0.pow(attempt)).toLong()
        return min(exponentialDelay, bedrockProperties.maxRetryDelayMs)
    }

    private suspend fun parseSingleTransactionResponse(
            response: String,
            transactionId: Long
    ): TransactionAnalysisResult {
        return try {
            logger.debug("Bedrock agent raw response: {}", response)
            val jsonStart = response.indexOf('{')
            val jsonEnd = response.lastIndexOf('}')

            var jsonPart = ""

            if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
                jsonPart = response.substring(jsonStart, jsonEnd + 1)
            }

            // Parse the JSON response
            val root = objectMapper.readTree(jsonPart)

            // Extract the transaction data node with multiple fallback strategies:
            // 1. Check for "result" (singular, object) - current Bedrock format
            // 2. Check for "results" (plural, array) - legacy format
            // 3. Assume root is the transaction data itself
            val node =
                    when {
                        root.has("result") && root.get("result").isObject -> {
                            root.get("result")
                        }
                        root.has("results") && root.get("results").isArray -> {
                            root.get("results").first()
                        }
                        else -> {
                            root
                        }
                    }

            TransactionAnalysisResult(
                    transactionId = node["transaction_id"]?.asLong() ?: transactionId,
                    revisedTransactionDate = parseDate(node["revised_transaction_date"]),
                    category = parseStringField(node["category"]),
                    cardNumber = parseStringField(node["extracted_card_number"]),
                    brandName = parseStringField(node["brand_name"]),
                    brandDomain = parseStringField(node["brand_domain"]),
                    friendlyDescription = parseStringField(node["friendly_description"]),
                    confidence = node["confidence"]?.asDouble() ?: 0.0,
                    success = true,
                    errorMessage = null
            )
        } catch (e: Exception) {
            logger.error("Failed to parse agent response: {}", e.message, e)
            TransactionAnalysisResult(
                    transactionId = transactionId,
                    revisedTransactionDate = null,
                    category = null,
                    cardNumber = null,
                    brandName = null,
                    brandDomain = null,
                    friendlyDescription = null,
                    confidence = 0.0,
                    success = false,
                    errorMessage = "Parse error: ${e.message}"
            )
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
        val brandName: String?,
        val brandDomain: String?,
        val friendlyDescription: String?,
        val confidence: Double,
        val success: Boolean,
        val errorMessage: String? = null
)
