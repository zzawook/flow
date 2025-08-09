package sg.flow.rest_controllers

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.services.EventServices.KafkaEventProducerService
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseLoginIdentityService

@RestController
@RequestMapping("/finverse")
class FinverseAuthCallbackController(
    private val kafkaEventProducerService: KafkaEventProducerService,
    private val finverseLoginIdentityService: FinverseLoginIdentityService
) {
    @GetMapping("/callback")
    suspend fun onSuccessfulCallback(
        @RequestParam("code") code: String,
        @RequestParam("state") state: String
    ): ResponseEntity<String> {
        // ONLY HANDLES SUCCESSFUL CALLBACKS
        // UNSUCCESSFUL CALLBACKS ARE NOT RECEIVED AT ALL IN THIS ENDPOINT DUE TO DIFFERENT REQUEST PARAMS SENT FROM FINVERSE IN CASE OF ERROR

        // Create and publish event to Kafka
        val kafkaEvent = FinverseAuthCallbackEvent(
            code = code,
            state = state
        )

        kafkaEventProducerService.publishAuthCallbackEvent(kafkaEvent)

        return ResponseEntity
            .status(HttpStatus.OK)
            .build()
    }
}