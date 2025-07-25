package sg.flow.rest_controllers

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.services.EventServices.KafkaEventProducerService
import sg.flow.events.FinverseAuthCallbackEvent
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@RestController
@RequestMapping("/finverse")
class FinverseAuthCallbackController(
    private val kafkaEventProducerService: KafkaEventProducerService,
    private val finverseQueryService: FinverseQueryService
) {
    @GetMapping("/callback")
    suspend fun onCallback(
        @RequestParam("code") code: String,
        @RequestParam("state") state: String
    ): ResponseEntity<String> {
        
        // Create and publish event to Kafka
        val kafkaEvent = FinverseAuthCallbackEvent(
            userId = 1, // TODO: Extract from state parameter
            code = code,
            state = state
        )
        
        kafkaEventProducerService.publishAuthCallbackEvent(kafkaEvent)

        return ResponseEntity
            .status(HttpStatus.OK)
            .build()
    }
}