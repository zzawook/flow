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
import aws.sdk.kotlin.services.bedrockagentruntime.model.BedrockModelConfigurations
import aws.sdk.kotlin.services.bedrockagentruntime.model.ResponseStream
import kotlinx.coroutines.flow.single
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

    suspend fun analyzeTransaction(transaction: List<TransactionHistory>): List<TransactionAnalysisResult> {
        return try {
            val prompt = createAnalysisPrompt(transaction)
            println(prompt)
            val response = invokeAgentWithRetry(prompt)
            println(response)
            val analysisResponse = parseAnalysisResponse(response)
            analysisResponse
        } catch (e: Exception) {
            logger.error("Failed to analyze transaction ${transaction}: ${e.message}", e)
            listOf(TransactionAnalysisResult(
                transactionId = -1,
                revisedTransactionDate = null,
                category = null,
                cardNumber = null,
                brandName = null,
                friendlyDescription = null,
                confidence = 0.0,
                success = false,
                errorMessage = e.message
            ))
        }
    }

    suspend fun analyzeTransactionBatch(transactions: List<TransactionHistory>): List<TransactionAnalysisResult> {
        logger.info("Starting batch analysis of ${transactions.size} transactions")

        val analysisResultList: MutableList<TransactionAnalysisResult> = mutableListOf()
        try {
            val analysisResults = analyzeTransaction(transactions)
            analysisResults.map { analysisResult -> analysisResultList.add(analysisResult) }

        } catch (e: Exception) {
            logger.error("Failed to analyze transaction in batch: ${e.message}", e)
        }

        return analysisResultList
    }

    private fun createAnalysisPrompt(transactions: List<TransactionHistory>): String {
        return """
            Transactions: 
                ${transactions.map { transaction ->
                    "{transaction_id: " + transaction.id + ", \nDescription: " + transaction.description + ", \nTransaction registry date: " + transaction.transactionDate + "}\n"
        }}
        """.trimIndent()
    }

    private suspend fun invokeAgentWithRetry(prompt: String): String {
        var lastException: Exception? = null
        val sid = "txn-${System.currentTimeMillis()}"

        repeat(bedrockProperties.maxRetries) { attempt ->
            try {
                println(bedrockProperties.agentId)
                println(bedrockProperties.agentAliasId)
                val request = InvokeAgentRequest {
                    agentId =  bedrockProperties.agentId
                    agentAliasId = bedrockProperties.agentAliasId
                    inputText = prompt
                    sessionId = sid
                    enableTrace = false

                    BedrockModelConfigurations

                    streamingConfigurations {
                        streamFinalResponse = false
                    }
                }
                // Extract the completion text from the response
                val completionBuilder = StringBuilder()

                return bedrockAgentRuntimeClient.invokeAgent(request) { response ->
                    val chunk = response.completion?.single()?.asChunkOrNull()?.bytes?.decodeToString()
                    if (chunk != null) {
                        completionBuilder.append(chunk)
                    }

                    completionBuilder.toString()
                }

            } catch (e: Exception) {
                lastException = e
                logger.warn("Bedrock agent invocation failed for transaction, attempt ${attempt + 1}: ${e.message}")

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

    private suspend fun parseAnalysisResponse(response: String): List<TransactionAnalysisResult> {
        return try {
            logger.debug("Bedrock agent raw response: {}", response)
            val jsonStart = response.indexOf('{')
            val jsonEnd = response.lastIndexOf('}')

            var jsonPart = ""

            if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
                jsonPart = response.substring(jsonStart, jsonEnd + 1)
            }

            // 1️⃣ Parse the full JSON
            val root = objectMapper.readTree(jsonPart)

            // 2️⃣ Find the "results" array
            val resultsNode = root.get("results")
                ?: throw IllegalArgumentException("No 'results' field in response")

            // 3️⃣ Map each object in the array to your data class
            resultsNode.map { node ->
                TransactionAnalysisResult(
                    transactionId           = node["transaction_id"]?.asLong() ?: -1,
                    revisedTransactionDate  = parseDate(node["revised_transaction_date"]),
                    category                = parseStringField(node["category"]),
                    cardNumber              = parseStringField(node["extracted_card_number"]),
                    brandName               = parseStringField(node["brand_name"]),
                    friendlyDescription     = parseStringField(node["friendly_description"]),
                    confidence              = node["confidence"]?.asDouble() ?: 0.0,
                    success                 = true,
                    errorMessage            = null
                )
            }
        } catch (e: Exception) {
            logger.error("Failed to parse agent response: {}", e.message, e)
            listOf(
                TransactionAnalysisResult(
                    transactionId           = -1,
                    revisedTransactionDate  = null,
                    category                = null,
                    cardNumber              = null,
                    brandName               = null,
                    friendlyDescription     = null,
                    confidence              = 0.0,
                    success                 = false,
                    errorMessage            = "Parse error: ${e.message}"
                )
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
    val brandName: String?,
    val friendlyDescription: String?,
    val confidence: Double,
    val success: Boolean,
    val errorMessage: String? = null
)