package sg.flow.controllers

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import sg.flow.services.AuthServices.AuthService

@RestController
@RequestMapping("/auth")
class AuthController(private val authService: AuthService) {

        @PostMapping("/signup")
        suspend fun signUp(@RequestBody request: AuthRequest): ResponseEntity<TokenSet> {
                return ResponseEntity.ok(authService.registerUser(request))
        }

        @PostMapping("/getAccessTokenByRefreshToken")
        suspend fun getAccessTokenByRefreshToken(
                @RequestBody request: AccessTokenRefreshRequest
        ): ResponseEntity<TokenSet> {
                val tokenSet =
                        authService.getAccessTokenByRefreshToken(request)
                                ?: return ResponseEntity.notFound().build()
                return ResponseEntity.ok(tokenSet)
        }
}
