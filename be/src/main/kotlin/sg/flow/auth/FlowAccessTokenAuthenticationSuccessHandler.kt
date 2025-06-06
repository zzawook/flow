package sg.flow.auth

import com.fasterxml.jackson.databind.ObjectMapper
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AuthenticationSuccessHandler
import sg.flow.models.auth.TokenSet
import java.io.IOException

class FlowAccessTokenAuthenticationSuccessHandler : AuthenticationSuccessHandler {

    @Throws(IOException::class)
    override fun onAuthenticationSuccess(
        request: HttpServletRequest,
        response: HttpServletResponse,
        authentication: Authentication,
    ) {
        val details = authentication.details
        if (details is TokenSet) {
            response.contentType = "application/json"
            response.characterEncoding = "UTF-8"
            val json = ObjectMapper().writeValueAsString(
                mapOf(
                    "accessToken" to details.accessToken,
                    "refreshToken" to details.refreshToken
                )
            )
            response.writer.write(json)
            response.writer.flush()
        }
    }
} 