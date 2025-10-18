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
import sg.flow.events.AppStoreNotificationData
import sg.flow.events.AppStoreNotificationEvent
import sg.flow.services.EventServices.KafkaEventProducerService

@RestController
@RequestMapping("/subscription")
class AppStoreWebhookController(
        private val kafkaProducer: KafkaEventProducerService,
        private val objectMapper: ObjectMapper
) {
    private val logger = LoggerFactory.getLogger(AppStoreWebhookController::class.java)

    @PostMapping("/apple")
    suspend fun handleAppleNotification(@RequestBody rawBody: String): ResponseEntity<Void> {
        logger.info("Received App Store Server Notification")

        return try {
            // Parse JWS (JSON Web Signature) from Apple
            val notification = parseJWS(rawBody)

            // Create event
            val event =
                    AppStoreNotificationEvent(
                            notificationType = notification["notificationType"] as? String
                                            ?: "UNKNOWN",
                            subtype = notification["subtype"] as? String,
                            data = extractNotificationData(notification),
                            rawPayload = rawBody,
                            timestamp = Instant.now()
                    )

            // Publish to Kafka
            kafkaProducer.publishAppStoreEvent(event)

            logger.info("App Store notification published to Kafka: ${event.notificationType}")
            ResponseEntity.ok().build()
        } catch (e: Exception) {
            logger.error("Failed to process App Store notification", e)
            ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build()
        }
    }

    @PostMapping("/apple-sandbox")
    suspend fun handleAppleSandboxNotification(@RequestBody rawBody: String): ResponseEntity<Void> {
        // Same logic but for sandbox environment
        logger.info("Received App Store Sandbox Server Notification")
        return handleAppleNotification(rawBody)
    }

    private fun parseJWS(jws: String): Map<String, Any> {
        // JWS format: header.payload.signature
        val parts = jws.split(".")
        if (parts.size != 3) {
            logger.warn("Invalid JWS format")
            return mapOf("notificationType" to "UNKNOWN")
        }

        return try {
            val payload = String(Base64.getUrlDecoder().decode(parts[1]))
            objectMapper.readValue(payload, Map::class.java) as Map<String, Any>
        } catch (e: Exception) {
            logger.error("Failed to parse JWS payload", e)
            mapOf("notificationType" to "UNKNOWN")
        }
    }

    private fun extractNotificationData(notification: Map<String, Any>): AppStoreNotificationData {
        val data = notification["data"] as? Map<String, Any> ?: emptyMap()

        return AppStoreNotificationData(
                signedTransactionInfo = data["signedTransactionInfo"] as? String ?: "",
                signedRenewalInfo = data["signedRenewalInfo"] as? String
        )
    }
}
