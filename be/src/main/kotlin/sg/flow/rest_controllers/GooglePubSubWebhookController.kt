package sg.flow.rest_controllers

import com.fasterxml.jackson.databind.ObjectMapper
import java.time.Instant
import java.util.Base64
import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import sg.flow.events.GooglePlayNotificationEvent
import sg.flow.events.SubscriptionNotification
import sg.flow.services.EventServices.KafkaEventProducerService

@RestController
@RequestMapping("/subscription")
class GooglePubSubWebhookController(
        private val kafkaProducer: KafkaEventProducerService,
        private val objectMapper: ObjectMapper
) {
    private val logger = LoggerFactory.getLogger(GooglePubSubWebhookController::class.java)

    @PostMapping("/google-pubsub")
    suspend fun handlePubSubPush(
            @RequestBody pushRequest: PubSubPushRequest
    ): ResponseEntity<Void> {
        logger.info("Received Google Pub/Sub push notification: ${pushRequest.message.messageId}")

        return try {
            // Decode base64 message data
            val notificationJson = String(Base64.getDecoder().decode(pushRequest.message.data))
            logger.debug("Decoded notification: $notificationJson")

            val notification =
                    objectMapper.readValue(
                            notificationJson,
                            GooglePlayDeveloperNotification::class.java
                    )

            // Create event
            val event =
                    GooglePlayNotificationEvent(
                            notificationType =
                                    notification.subscriptionNotification?.notificationType ?: 0,
                            subscriptionNotification =
                                    notification.subscriptionNotification?.let {
                                        SubscriptionNotification(
                                                version = it.version,
                                                notificationType = it.notificationType,
                                                purchaseToken = it.purchaseToken,
                                                subscriptionId = it.subscriptionId
                                        )
                                    },
                            rawPayload = notificationJson,
                            timestamp = Instant.now()
                    )

            // Publish to Kafka
            kafkaProducer.publishGooglePlayEvent(event)

            logger.info(
                    "Google Play notification published to Kafka: type=${event.notificationType}"
            )
            ResponseEntity.ok().build()
        } catch (e: Exception) {
            logger.error("Failed to process Google Pub/Sub notification", e)
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build()
        }
    }
}

data class PubSubPushRequest(val message: PubSubMessage, val subscription: String)

data class PubSubMessage(
        val data: String, // Base64-encoded
        val messageId: String,
        val publishTime: String,
        val attributes: Map<String, String>?
)

data class GooglePlayDeveloperNotification(
        val version: String?,
        val packageName: String?,
        val eventTimeMillis: String?,
        val subscriptionNotification: GooglePlaySubscriptionNotification?,
        val testNotification: GooglePlayTestNotification?
)

data class GooglePlaySubscriptionNotification(
        val version: String,
        val notificationType: Int,
        val purchaseToken: String,
        val subscriptionId: String
)

data class GooglePlayTestNotification(val version: String)
