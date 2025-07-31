package sg.flow.services.EventServices

import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.configs.TransactionAnalysisProperties
import sg.flow.events.TransactionAnalysisTriggerEvent
import sg.flow.repositories.transactionHistory.TransactionAnalysisUpdate
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.services.TransactionHistoryServices.BedrockTransactionAnalysisService
import sg.flow.services.TransactionHistoryServices.TransactionHistoryProcessingService

@Service
class TransactionAnalysisConsumer(
        private val transactionHistoryRepository: TransactionHistoryRepository,
        private val transactionHistoryProcessingService: TransactionHistoryProcessingService,
        private val bedrockTransactionAnalysisService: BedrockTransactionAnalysisService,
        private val transactionAnalysisProperties: TransactionAnalysisProperties
) {

        private val logger = LoggerFactory.getLogger(TransactionAnalysisConsumer::class.java)

        @KafkaListener(
                topics = ["\${flow.kafka.topics.transaction-analysis-trigger}"],
                groupId = "\${spring.kafka.consumer.group-id}",
                containerFactory = "transactionAnalysisKafkaListenerContainerFactory"
        )
        suspend fun handleTransactionAnalysisTrigger(
                event: TransactionAnalysisTriggerEvent,
                acknowledgment: Acknowledgment
        ) {
                try {
                        logger.info(
                                "Processing transaction analysis trigger event: {} for userId: {}, institutionId: {}, loginIdentityId: {}",
                                event.eventId,
                                event.userId,
                                event.institutionId,
                                event.loginIdentityId
                        )

                        // Check if transaction analysis is enabled
                        if (!transactionAnalysisProperties.enabled) {
                                logger.info(
                                        "Transaction analysis is disabled, skipping processing for event: {}",
                                        event.eventId
                                )
                                acknowledgment.acknowledge()
                                return
                        }

                        // Fetch unprocessed transactions for the user
                        val unprocessedTransactions =
                                transactionHistoryRepository.findUnprocessedTransactionsByUserId(
                                        event.userId
                                )

                        if (unprocessedTransactions.isEmpty()) {
                                logger.info(
                                        "No unprocessed transactions found for userId: {} in event: {}",
                                        event.userId,
                                        event.eventId
                                )
                                acknowledgment.acknowledge()
                                return
                        }

                        logger.info(
                                "Found {} unprocessed transactions for userId: {} in event: {}",
                                unprocessedTransactions.size,
                                event.userId,
                                event.eventId
                        )

                        // Process transactions in configurable batches
                        val batchSize = transactionAnalysisProperties.batchSize
                        val batches = unprocessedTransactions.chunked(batchSize)
                        var totalProcessed = 0
                        var totalSuccessful = 0

                        for ((batchIndex, batch) in batches.withIndex()) {
                                try {
                                        logger.info(
                                                "Processing batch {} of {} (size: {}) for event: {}",
                                                batchIndex + 1,
                                                batches.size,
                                                batch.size,
                                                event.eventId
                                        )

                                        // Call Bedrock service for transaction analysis
                                        val analysisResults =
                                                bedrockTransactionAnalysisService
                                                        .analyzeTransactionBatch(batch)

                                        // Prepare updates for database
                                        val updates =
                                                analysisResults.map { result ->
                                                        TransactionAnalysisUpdate(
                                                                transactionId =
                                                                        result.transactionId,
                                                                category = result.category,
                                                                friendlyDescription =
                                                                        result.friendlyDescription,
                                                                extractedCardNumber =
                                                                        result.cardNumber,
                                                                revisedTransactionDate =
                                                                        result.revisedTransactionDate,
                                                                isProcessed = true
                                                        )
                                                }

                                        // Update database with analysis results
                                        val updatedCount =
                                                transactionHistoryRepository
                                                        .batchUpdateTransactionAnalysis(updates)
                                        totalProcessed += batch.size
                                        totalSuccessful += analysisResults.count { it.success }

                                        logger.info(
                                                "Batch {} completed: {} transactions updated, {} successful analyses for event: {}",
                                                batchIndex + 1,
                                                updatedCount,
                                                analysisResults.count { it.success },
                                                event.eventId
                                        )
                                } catch (e: Exception) {
                                        logger.error(
                                                "Failed to process batch {} for event: {}",
                                                batchIndex + 1,
                                                event.eventId,
                                                e
                                        )
                                        // Re-throw to prevent acknowledgment and trigger retry
                                        throw e
                                }
                        }

                        logger.info(
                                "Transaction analysis completed for event: {}. Total processed: {}, Total successful: {}",
                                event.eventId,
                                totalProcessed,
                                totalSuccessful
                        )

                        // Acknowledge the message only after successful processing of all batches
                        acknowledgment.acknowledge()
                        logger.info(
                                "Successfully processed transaction analysis trigger event: {}",
                                event.eventId
                        )
                } catch (e: Exception) {
                        logger.error(
                                "Error processing transaction analysis trigger event: {} for userId: {}, institutionId: {}, loginIdentityId: {}",
                                event.eventId,
                                event.userId,
                                event.institutionId,
                                event.loginIdentityId,
                                e
                        )
                        // Don't acknowledge on error - this will trigger retry mechanism
                        throw e
                }
        }
}
