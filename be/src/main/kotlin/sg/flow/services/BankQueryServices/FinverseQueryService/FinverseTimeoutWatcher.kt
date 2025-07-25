package sg.flow.services.BankQueryServices.FinverseQueryService

import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.withTimeout
import org.slf4j.LoggerFactory
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Component
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import kotlin.time.Duration
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CompletableFuture

@Component
class FinverseTimeoutWatcher {
    
    private val logger = LoggerFactory.getLogger(FinverseTimeoutWatcher::class.java)
    
    // Storage for results - these will be populated by Kafka listeners
    private val authResults = ConcurrentHashMap<String, FinverseAuthenticationStatus>()
    private val dataRetrievalResults = ConcurrentHashMap<String, FinverseOverallRetrievalStatus>()
    
    // Futures for waiting operations
    private val authWaiters = ConcurrentHashMap<String, CompletableFuture<FinverseAuthenticationStatus>>()
    private val dataRetrievalWaiters = ConcurrentHashMap<String, CompletableFuture<FinverseOverallRetrievalStatus>>()

    @KafkaListener(
        topics = ["\${flow.kafka.topics.finverse-auth-complete}"],
        groupId = "\${spring.kafka.consumer.group-id}",
        containerFactory = "webhookKafkaListenerContainerFactory"
    )
    suspend fun handleAuthCompleteEvent(event: FinverseWebhookEvent, acknowledgment: Acknowledgment) {
        try {
            val loginIdentityId = event.login_identity_id
            val status = when (event.event_type) {
                "AUTHENTICATED" -> FinverseAuthenticationStatus.AUTHENTICATED
                "AUTHENTICATION_FAILED" -> FinverseAuthenticationStatus.AUTHENTICATION_FAILED
                else -> FinverseAuthenticationStatus.AUTHENTICATION_FAILED
            }
            
            logger.info("Received auth complete event for loginIdentityId: {} with status: {}", loginIdentityId, status)
            
            // Store result and notify waiters
            authResults[loginIdentityId] = status
            authWaiters[loginIdentityId]?.complete(status)
            
            acknowledgment.acknowledge()
        } catch (e: Exception) {
            logger.error("Error processing auth complete event", e)
            throw e
        }
    }

    @KafkaListener(
        topics = ["\${flow.kafka.topics.finverse-product-complete}"],
        groupId = "\${spring.kafka.consumer.group-id}",
        containerFactory = "kafkaListenerContainerFactory"
    )
    suspend fun handleProductCompleteEvent(event: FinverseOverallRetrievalStatus, acknowledgment: Acknowledgment) {
        try {
            val loginIdentityId = event.loginIdentityId
            
            logger.info("Received product complete event for loginIdentityId: {} with success: {}", loginIdentityId, event.success)
            
            // Store result and notify waiters
            dataRetrievalResults[loginIdentityId] = event
            dataRetrievalWaiters[loginIdentityId]?.complete(event)
            
            acknowledgment.acknowledge()
        } catch (e: Exception) {
            logger.error("Error processing product complete event", e)
            throw e
        }
    }

    suspend fun watchAuthentication(
        loginIdentityId: String,
        timeout: Duration
    ): FinverseAuthenticationStatus {
        return try {
            // Check if result already exists
            authResults[loginIdentityId]?.let { return it }
            
            // Create a future to wait for the result
            val future = CompletableFuture<FinverseAuthenticationStatus>()
            authWaiters[loginIdentityId] = future
            
            val result = withTimeout(timeout) {
                future.get()
            }
            
            // Cleanup
            authResults.remove(loginIdentityId)
            authWaiters.remove(loginIdentityId)
            
            result
        } catch (e: TimeoutCancellationException) {
            // Cleanup on timeout
            authWaiters.remove(loginIdentityId)
            FinverseAuthenticationStatus.AUTHENTICATION_TIMEOUT
        }
    }

    suspend fun watchDataRetrievalCompletion(
        loginIdentityId: String,
        timeout: Duration
    ): FinverseOverallRetrievalStatus {
        return try {
            // Check if result already exists
            dataRetrievalResults[loginIdentityId]?.let { return it }
            
            // Create a future to wait for the result
            val future = CompletableFuture<FinverseOverallRetrievalStatus>()
            dataRetrievalWaiters[loginIdentityId] = future
            
            val result = withTimeout(timeout) {
                future.get()
            }
            
            // Cleanup
            dataRetrievalResults.remove(loginIdentityId)
            dataRetrievalWaiters.remove(loginIdentityId)
            
            result
        } catch (e: TimeoutCancellationException) {
            // Cleanup on timeout
            dataRetrievalWaiters.remove(loginIdentityId)
            FinverseOverallRetrievalStatus(
                success = false,
                message = "TIME OUT: $timeout",
                loginIdentityId = loginIdentityId,
            )
        }
    }
}