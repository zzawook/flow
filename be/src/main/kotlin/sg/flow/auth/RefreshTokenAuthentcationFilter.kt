package sg.flow.auth

import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import kotlinx.coroutines.runBlocking
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.authentication.BadCredentialsException
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.Authentication
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter
import org.springframework.security.web.util.matcher.AntPathRequestMatcher
import sg.flow.models.auth.TokenSet
import sg.flow.services.AuthServices.FlowTokenService

class RefreshTokenAuthentcationFilter(
        private val tokenService: FlowTokenService,
        authManager: AuthenticationManager,
) : AbstractAuthenticationProcessingFilter(AntPathRequestMatcher("/auth/getAccessToken", "POST")) {

    init {
        setAuthenticationManager(authManager)
    }

    override fun attemptAuthentication(
            request: HttpServletRequest,
            response: HttpServletResponse
    ): Authentication? {
        val header =
                request.getHeader("Authorization")
                        ?: throw BadCredentialsException("No Authorization header")
        if (!header.startsWith("Bearer ")) {
            throw BadCredentialsException("No Bearer token")
        }
        val refreshToken = header.substring(7)
        val auth =
                handleRefreshToken(refreshToken)
                        ?: throw BadCredentialsException("Invalid refresh token")
        return auth
    }

    private fun handleRefreshToken(refreshToken: String): Authentication? = runBlocking {
        val tokenSet =
                tokenService.getAccessTokenByRefreshToken(refreshToken) ?: return@runBlocking null
        val auth = UsernamePasswordAuthenticationToken(null, null, emptyList())
        auth.details = TokenSet(tokenSet.accessToken, tokenSet.refreshToken)
        auth
    }
}
