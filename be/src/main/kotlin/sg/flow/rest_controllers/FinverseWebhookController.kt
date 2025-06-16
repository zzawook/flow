package sg.flow.rest_controllers

import com.fasterxml.jackson.annotation.JsonAlias
import com.fasterxml.jackson.databind.ObjectMapper
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestHeader
import sg.flow.models.finverse.webhook_events.FetchCompletedEvent
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import sg.flow.models.finverse.webhook_events.LinkSucceededEvent
import sg.flow.models.finverse.webhook_events.StatementReadyEvent
import java.security.MessageDigest
import java.time.Instant
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

//@RestController
//@RequestMapping("/api/webhook/finverse")
class FinverseWebhookController(
    private val objectMapper: ObjectMapper,
    @Value("\${finverse.webhook.secret}") private val webhookSecret: String
) {

    @PostMapping
    suspend fun handle(
        @RequestHeader("X-Finverse-Signature") sig: String,
        @RequestHeader("X-Finverse-Event") eventType: String,
        @RequestBody payload: String
    ): ResponseEntity<Void> {
        // 1️⃣ Verify the HMAC‑SHA256 signature
        if (!verifySignature(payload, sig)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build()
        }

        // 2️⃣ Deserialize into a sealed data class
        val event = objectMapper.readValue(payload, FinverseWebhookEvent::class.java)
        when (eventType) {
            "link.succeeded"      -> handleLinkSucceeded(event as LinkSucceededEvent)
            "fetch.completed"     -> handleFetchCompleted(event as FetchCompletedEvent)
            "statement.ready"     -> handleStatementReady(event as StatementReadyEvent)
            else                  -> { /* ignore unknown events */ }
        }

        return ResponseEntity.ok().build()
    }

    private fun verifySignature(payload: String, sig: String): Boolean {
        val mac = Mac.getInstance("HmacSHA256").apply {
            init(SecretKeySpec(webhookSecret.toByteArray(), "HmacSHA256"))
        }
        val expected = mac.doFinal(payload.toByteArray()).joinToString("") {
            "%02x".format(it)
        }
        return MessageDigest.isEqual(expected.toByteArray(), sig.toByteArray())
    }

    private fun handleLinkSucceeded(linkSucceededEvent: LinkSucceededEvent) {}

    private fun handleFetchCompleted(linkFetchCompletedEvent: FetchCompletedEvent) {}

    private fun handleStatementReady(statementReadyEvent: StatementReadyEvent) {}
}


