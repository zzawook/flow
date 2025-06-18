package sg.flow.rest_controllers

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.finverse.FinverseAuthenticationEventTypeParser
import sg.flow.models.finverse.FinverseEventTypeParser
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseAuthEventPublisher
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataRetrievalEventsManager

@RestController
@RequestMapping("/webhooks/finverse")
class FinverseWebhookController(
    private val objectMapper: ObjectMapper,
    private val verifier: FinverseSignatureVerifier,
    private val finverseDataRetrievalEventsManager: FinverseDataRetrievalEventsManager,
    private val authPublisher: FinverseAuthEventPublisher
) {

    @PostMapping
    suspend fun handleWebhook(
        @RequestHeader("FV_SIGNATURE") signature: String,
        @RequestHeader("X-Finverse-Timestamp") timestamp: String,
        @RequestBody rawBody: ByteArray
    ): ResponseEntity<Void> {
        println("webhookReceived")
        verifier.verify(signature, timestamp, rawBody)

        val event = objectMapper.readValue(rawBody, FinverseWebhookEvent::class.java)

        if (isAuthenticationEvent(event.event_type)) {
            FinverseAuthenticationEventTypeParser.parse(event.event_type)?.let { _ ->
                authPublisher.publish(event)
            }
        } else {
            FinverseEventTypeParser.parse(event.event_type)?.let { ps ->
                finverseDataRetrievalEventsManager.update(event.loginIdentityId, ps.product, ps.status)
            }
        }



        return ResponseEntity.ok().build()
    }

    private fun isAuthenticationEvent(eventType: String) : Boolean {
        val authenticationEventTypes = listOf(
            "AUTHENTICATED",
            "AUTHENTICATION_FAILED",
            "AUTHENTICATION_TEMPORARILY_UNAVAILABLE_FOR_INSTITUTION",
            "AUTHENTICATION_TOO_MANY_ATTEMPTS"
        )

        return authenticationEventTypes.contains(eventType)
    }
}
