package sg.flow.controllers

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.auth.AccessTokenRefreshRequest
import sg.flow.models.auth.AuthRequest
import sg.flow.models.auth.TokenSet
import sg.flow.services.AuthServices.AuthService

@RestController
class AuthController(private val authService: AuthService) {

        @PostMapping("/auth/signin")
        suspend fun signIn(@RequestBody request: AuthRequest): ResponseEntity<TokenSet> =
                ResponseEntity.ok(authService.authenticateUser(request))

        @PostMapping("/auth/getAccessToken")
        suspend fun getAccessToken(
                @RequestBody request: AccessTokenRefreshRequest
        ): ResponseEntity<TokenSet> {
                val tokenSet =
                        authService.getAccessTokenByRefreshToken(request)
                                ?: return ResponseEntity.notFound().build()
                return ResponseEntity.ok(tokenSet)
        }
}
