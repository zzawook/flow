package sg.flow.services.EventServices

import kotlinx.coroutines.async
import kotlinx.coroutines.awaitAll
import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Service
import sg.flow.configs.TransactionAnalysisProperties
import sg.flow.events.TransactionAnalysisTriggerEvent
import sg.flow.repositories.transactionHistory.TransactionAnalysisUpdate
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.services.TransactionHistoryServices.BedrockTransactionAnalysisService

@Service
class TransactionAnalysisConsumer(
        private val transactionHistoryRepository: TransactionHistoryRepository,
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

                        // Process transactions concurrently with a maximum of 5 simultaneous invocations
                        val maxConcurrent = 5
                        val semaphore = Semaphore(maxConcurrent)
                        var totalProcessed = 0
                        var totalSuccessful = 0

                        logger.info(
                                "Starting concurrent processing of {} transactions with max {} concurrent invocations for event: {}",
                                unprocessedTransactions.size,
                                maxConcurrent,
                                event.eventId
                        )

                        // Process all transactions concurrently with semaphore limiting concurrency
                        val analysisResults = coroutineScope {
                                unprocessedTransactions.map { transaction ->
                                        async {
                                                semaphore.withPermit {
                                                        logger.debug(
                                                                "Processing transaction {} for event: {}",
                                                                transaction.id,
                                                                event.eventId
                                                        )
                                                        try {
                                                                bedrockTransactionAnalysisService
                                                                        .analyzeSingleTransaction(transaction)
                                                        } catch (e: Exception) {
                                                                logger.error(
                                                                        "Failed to process transaction {} for event: {}",
                                                                        transaction.id,
                                                                        event.eventId,
                                                                        e
                                                                )
                                                                // Return a failed result instead of throwing
                                                                // This allows other transactions to continue processing
                                                                null
                                                        }
                                                }
                                        }
                                }.awaitAll().filterNotNull()
                        }

                        // Prepare updates for database
                        val updates = analysisResults.map { result ->
                                TransactionAnalysisUpdate(
                                        transactionId = result.transactionId,
                                        category = result.category,
                                        friendlyDescription = result.friendlyDescription,
                                        extractedCardNumber = result.cardNumber,
                                        brandName = result.brandName,
                                        brandDomain = result.brandDomain,
                                        revisedTransactionDate = result.revisedTransactionDate,
                                        isProcessed = true
                                )
                        }

                        // Update database with analysis results
                        if (updates.isNotEmpty()) {
                                val updatedCount =
                                        transactionHistoryRepository
                                                .batchUpdateTransactionAnalysis(updates)
                                totalProcessed = updates.size
                                totalSuccessful = analysisResults.count { it.success }

                                logger.info(
                                        "Completed concurrent processing: {} transactions updated, {} successful analyses for event: {}",
                                        updatedCount,
                                        totalSuccessful,
                                        event.eventId
                                )
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
