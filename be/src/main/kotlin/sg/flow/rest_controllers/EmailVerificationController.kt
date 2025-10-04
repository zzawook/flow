package sg.flow.rest_controllers

import org.slf4j.LoggerFactory
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.configs.MagicLinkProps
import sg.flow.services.AuthServices.AuthService
import java.net.URI

@RestController
@RequestMapping("/auth/email")
class EmailVerificationController(
    private val linkProps: MagicLinkProps,
    private val authService: AuthService
) {
    private val logger = LoggerFactory.getLogger(EmailVerificationController::class.java)
    @GetMapping("/verify")
    suspend fun verifyEmail(
        @RequestParam("token") token: String
    ): ResponseEntity<Void> {
        val success = authService.verifyEmail(token)
        var redirect: String = ""
        if (! success) {
            redirect = linkProps.failRedirectUrl
            val uri = URI.create(redirect)
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).location(uri).build()
        }
        redirect = linkProps.redirectUrl
        val uri = URI.create(redirect)
        return ResponseEntity.status(HttpStatus.FOUND).location(uri).build()
    }
}