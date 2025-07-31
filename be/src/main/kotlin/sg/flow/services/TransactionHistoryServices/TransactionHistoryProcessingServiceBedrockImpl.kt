package sg.flow.services.TransactionHistoryServices

import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Service
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionAnalysisResult
import sg.flow.repositories.transactionHistory.TransactionAnalysisUpdate
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

@Service
class TransactionHistoryProcessingServiceBedrockImpl(
    private val transactionHistoryRepository: TransactionHistoryRepository,
    private val bedrockTransactionAnalysisService: BedrockTransactionAnalysisService,
    @Value("\${flow.transaction-analysis.batch-size:50}") private val batchSize: Int
) : TransactionHistoryProcessingService {
    
    private val logger = LoggerFactory.getLogger(TransactionHistoryProcessingServiceBedrockImpl::class.java)

    override suspend fun processTransaction(transactionHistoryReference: String) {
        logger.info("Processing single transaction with reference: $transactionHistoryReference")
        
        try {
            // Note: Since there's no findByTransactionReference method in the repository,
            // we'll need to implement this functionality or modify the approach.
            // For now, we'll log this limitation and suggest using batch processing instead.
            logger.warn("Single transaction processing by reference is not yet implemented. " +
                       "Consider using processUnprocessedTransactions() for batch processing instead.")
            
            // TODO: Implement findByTransactionReference in repository or modify approach
            // This could be done by:
            // 1. Adding a findByTransactionReference method to the repository
            // 2. Or by processing all unprocessed transactions and filtering by reference
            
        } catch (e: Exception) {
            logger.error("Error processing transaction $transactionHistoryReference", e)
            throw e
        }
    }

    suspend fun processUnprocessedTransactions(userId: Int? = null): ProcessingResult {
        logger.info("Starting batch processing of unprocessed transactions${userId?.let { " for user $it" } ?: ""}")
        
        return try {
            // Fetch unprocessed transactions
            val unprocessedTransactions = if (userId != null) {
                transactionHistoryRepository.findUnprocessedTransactionsByUserId(userId)
            } else {
                transactionHistoryRepository.findUnprocessedTransactions()
            }

            if (unprocessedTransactions.isEmpty()) {
                logger.info("No unprocessed transactions found${userId?.let { " for user $it" } ?: ""}")
                return ProcessingResult(
                    totalTransactions = 0,
                    processedSuccessfully = 0,
                    processedWithErrors = 0,
                    skipped = 0,
                    errors = emptyList()
                )
            }

            logger.info("Found ${unprocessedTransactions.size} unprocessed transactions to analyze")

            // Process transactions in batches
            val batches = unprocessedTransactions.chunked(batchSize)
            var totalProcessed = 0
            var totalErrors = 0
            val allErrors = mutableListOf<String>()

            for ((batchIndex, batch) in batches.withIndex()) {
                logger.info("Processing batch ${batchIndex + 1}/${batches.size} with ${batch.size} transactions")
                
                val batchResult = processTransactionBatch(batch)
                totalProcessed += batchResult.processedSuccessfully
                totalErrors += batchResult.processedWithErrors
                allErrors.addAll(batchResult.errors)
                
                logger.info("Batch ${batchIndex + 1} completed: ${batchResult.processedSuccessfully} successful, ${batchResult.processedWithErrors} errors")
            }

            val result = ProcessingResult(
                totalTransactions = unprocessedTransactions.size,
                processedSuccessfully = totalProcessed,
                processedWithErrors = totalErrors,
                skipped = 0,
                errors = allErrors
            )

            logger.info("Batch processing completed: ${result.totalTransactions} total, ${result.processedSuccessfully} successful, ${result.processedWithErrors} errors")
            result

        } catch (e: Exception) {
            logger.error("Error during batch processing of unprocessed transactions", e)
            throw e
        }
    }

    suspend fun processTransactionBatch(transactions: List<TransactionHistory>): BatchProcessingResult {
        if (transactions.isEmpty()) {
            return BatchProcessingResult(
                batchSize = 0,
                processedSuccessfully = 0,
                processedWithErrors = 0,
                errors = emptyList()
            )
        }

        logger.debug("Processing batch of ${transactions.size} transactions")
        
        return try {
            // Analyze transactions using Bedrock
            val analysisResults = bedrockTransactionAnalysisService.analyzeTransactionBatch(transactions)
            
            // Prepare updates for batch processing
            val updates = mutableListOf<TransactionAnalysisUpdate>()
            val errors = mutableListOf<String>()
            var successCount = 0
            var errorCount = 0

            for (result in analysisResults) {
                try {
                    val update = TransactionAnalysisUpdate(
                        transactionId = result.transactionId,
                        category = result.category,
                        friendlyDescription = result.friendlyDescription,
                        extractedCardNumber = result.cardNumber,
                        revisedTransactionDate = result.revisedTransactionDate,
                        isProcessed = true
                    )
                    updates.add(update)
                    
                    if (result.success) {
                        successCount++
                        logger.debug("Transaction ${result.transactionId} analyzed successfully with confidence ${result.confidence}")
                    } else {
                        errorCount++
                        val errorMsg = "Transaction ${result.transactionId} analysis failed: ${result.errorMessage}"
                        errors.add(errorMsg)
                        logger.warn(errorMsg)
                    }
                } catch (e: Exception) {
                    errorCount++
                    val errorMsg = "Error preparing update for transaction ${result.transactionId}: ${e.message}"
                    errors.add(errorMsg)
                    logger.error(errorMsg, e)
                }
            }

            // Perform batch update
            if (updates.isNotEmpty()) {
                try {
                    val updatedCount = transactionHistoryRepository.batchUpdateTransactionAnalysis(updates)
                    logger.debug("Batch update completed: $updatedCount transactions updated")
                    
                    if (updatedCount != updates.size) {
                        val errorMsg = "Batch update mismatch: expected ${updates.size} updates, but $updatedCount were applied"
                        errors.add(errorMsg)
                        logger.warn(errorMsg)
                    }
                } catch (e: Exception) {
                    val errorMsg = "Batch database update failed: ${e.message}"
                    errors.add(errorMsg)
                    logger.error(errorMsg, e)
                    errorCount = transactions.size // Mark all as errors if batch update fails
                    successCount = 0
                }
            }

            BatchProcessingResult(
                batchSize = transactions.size,
                processedSuccessfully = successCount,
                processedWithErrors = errorCount,
                errors = errors
            )

        } catch (e: Exception) {
            val errorMsg = "Critical error processing transaction batch: ${e.message}"
            logger.error(errorMsg, e)
            
            BatchProcessingResult(
                batchSize = transactions.size,
                processedSuccessfully = 0,
                processedWithErrors = transactions.size,
                errors = listOf(errorMsg)
            )
        }
    }

    private suspend fun updateTransactionWithAnalysis(
        transaction: TransactionHistory,
        analysisResult: TransactionAnalysisResult
    ): Boolean {
        return try {
            val success = transactionHistoryRepository.updateTransactionAnalysis(
                id = transaction.id!!,
                category = analysisResult.category,
                friendlyDescription = analysisResult.friendlyDescription,
                extractedCardNumber = analysisResult.cardNumber,
                revisedTransactionDate = analysisResult.revisedTransactionDate,
                isProcessed = true
            )
            
            if (success) {
                logger.debug("Transaction ${transaction.id} updated with analysis results (confidence: ${analysisResult.confidence})")
            } else {
                logger.warn("Failed to update transaction ${transaction.id} with analysis results")
            }
            
            success
        } catch (e: Exception) {
            logger.error("Error updating transaction ${transaction.id} with analysis results", e)
            false
        }
    }
}

data class ProcessingResult(
    val totalTransactions: Int,
    val processedSuccessfully: Int,
    val processedWithErrors: Int,
    val skipped: Int,
    val errors: List<String>
)

data class BatchProcessingResult(
    val batchSize: Int,
    val processedSuccessfully: Int,
    val processedWithErrors: Int,
    val errors: List<String>
)