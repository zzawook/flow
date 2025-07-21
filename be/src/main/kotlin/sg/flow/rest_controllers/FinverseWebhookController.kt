package sg.flow.rest_controllers

import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.finverse.FinverseAuthenticationEventTypeParser
import sg.flow.models.finverse.FinverseEventTypeParser
import sg.flow.models.finverse.FinverseProduct
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseAuthEventPublisher
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseDataRetrievalRequestsManager

@RestController
@RequestMapping("/finverse/webhooks")
class FinverseWebhookController(
    private val objectMapper: ObjectMapper,
    private val verifier: FinverseSignatureVerifier,
    private val finverseDataRetrievalRequestsManager: FinverseDataRetrievalRequestsManager,
    private val authPublisher: FinverseAuthEventPublisher
) {

    @PostMapping
    suspend fun handleWebhook(
        @RequestBody rawBody: ByteArray
    ): ResponseEntity<Void> {

        val event = objectMapper.readValue(rawBody, FinverseWebhookEvent::class.java)
        println("webhookReceived: $event")

        if (isAuthenticationEvent(event.event_type)) {
            FinverseAuthenticationEventTypeParser.parse(event.event_type)?.let { _ ->
                authPublisher.publish(event)
            }

        } else {
            FinverseEventTypeParser.parse(event.event_type).let { ps ->
                if (ps.product in FinverseProduct.supported) {
                    finverseDataRetrievalRequestsManager.updateAndFetchIfSuccess(event.loginIdentityId, ps.product, ps.status)
                }
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
