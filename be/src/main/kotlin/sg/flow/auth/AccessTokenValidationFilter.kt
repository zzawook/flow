package sg.flow.auth

import jakarta.servlet.FilterChain
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import kotlinx.coroutines.runBlocking
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource
import org.springframework.web.filter.OncePerRequestFilter
import sg.flow.services.AuthServices.FlowTokenService

class AccessTokenValidationFilter(private val tokenService: FlowTokenService) :
        OncePerRequestFilter() {

    override fun shouldNotFilterAsyncDispatch() = false

    override fun doFilterInternal(
            request: HttpServletRequest,
            response: HttpServletResponse,
            filterChain: FilterChain,
    ) {
        if (SecurityContextHolder.getContext().authentication != null) {
            filterChain.doFilter(request, response)
            return
        }
        val authorizationHeader = request.getHeader("Authorization")
        if (authorizationHeader == null || !authorizationHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response)
            return
        }
        val token = authorizationHeader.substring(7)
        handleAccessToken(request, token)
        filterChain.doFilter(request, response)
    }

    private fun handleAccessToken(request: HttpServletRequest, accessToken: String) = runBlocking {
        val userDetails = tokenService.getUserDetailByAccessToken(accessToken) ?: return@runBlocking

        val authenticationToken =
                UsernamePasswordAuthenticationToken(
                                userDetails,
                                null,
                                userDetails.authorities,
                        )
                        .apply { details = WebAuthenticationDetailsSource().buildDetails(request) }
        SecurityContextHolder.getContext().authentication = authenticationToken
    }
}
