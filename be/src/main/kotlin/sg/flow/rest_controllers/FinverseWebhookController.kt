package sg.flow.rest_controllers

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import sg.flow.services.EventServices.KafkaEventProducerService
import sg.flow.events.FinverseWebhookEvent as FlowFinverseWebhookEvent

@RestController
@RequestMapping("/finverse/webhooks")
class FinverseWebhookController(
    private val objectMapper: ObjectMapper,
    private val verifier: FinverseSignatureVerifier,
    private val kafkaEventProducerService: KafkaEventProducerService
) {

    @PostMapping
    suspend fun handleWebhook(
//        @RequestHeader("FV-Signature") signature: String,
        @RequestBody rawBody: ByteArray
    ): ResponseEntity<Void> {

        // Verify the webhook signature first
        // Commented out for now as Finverse Data API does not have FV-Signature header as documented
//        try {
//            verifier.verify(signature, rawBody)
//            println("Webhook signature verified successfully")
//        } catch (e: Exception) {
//            println("Webhook signature verification failed: ${e.message}")
//            return ResponseEntity.badRequest().build()
//        }

        val event = objectMapper.readValue(rawBody, FinverseWebhookEvent::class.java)
        println("webhookReceived: $event")

        // Create and publish event to Kafka
        val kafkaEvent = FlowFinverseWebhookEvent(
            eventType = event.event_type,
            loginIdentityId = event.login_identity_id,
            rawWebhookPayload = event
        )
        
        kafkaEventProducerService.publishWebhookEvent(kafkaEvent)

        return ResponseEntity.ok().build()
    }
}
