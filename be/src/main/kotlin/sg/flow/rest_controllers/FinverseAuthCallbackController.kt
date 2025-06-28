package sg.flow.rest_controllers

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@RestController
@RequestMapping("/finverse")
class FinverseAuthCallbackController(
    private val finverseService: FinverseQueryService,
) {
    @GetMapping("/callback")
    suspend fun onCallback(
        @RequestParam("code") code: String,
        @RequestParam("state") state: String
    ): ResponseEntity<String> {
        println("Received Callback: $code")
        finverseService.fetchLoginIdentity(1, code, "testbank")

        return ResponseEntity
            .status(HttpStatus.OK)
            .build()
    }
}