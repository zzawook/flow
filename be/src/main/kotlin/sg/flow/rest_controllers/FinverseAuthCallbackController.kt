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
    private val finverseService: FinverseQueryService  // your service that exchanges the code
) {
    @GetMapping("/callback")
    suspend fun onCallback(
        @RequestParam("code") code: String,
        @RequestParam("state") state: String
    ): ResponseEntity<String> {
        println("CALLBACK RECEIVED")
        println(code)
        println(state)
        // 1️⃣ Exchange the code for login-identity
        val identity = finverseService.fetchLoginIdentity(code)

        // 2️⃣ Persist identity.loginIdentityId / token under your user,
        //    for example by looking up the user via `state` or via the session.

        // 3️⃣ Return something to the browser (you can redirect back to your app UI):
        return ResponseEntity
            .status(HttpStatus.OK)
            .build()
    }
}