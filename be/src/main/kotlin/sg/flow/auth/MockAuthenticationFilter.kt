package sg.flow.auth

import jakarta.servlet.FilterChain
import jakarta.servlet.ServletRequest
import jakarta.servlet.ServletResponse
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken
import org.springframework.security.core.authority.SimpleGrantedAuthority
import org.springframework.security.core.context.SecurityContextHolder
import org.springframework.web.filter.GenericFilterBean
import sg.flow.models.auth.FlowUserDetails

class MockAuthenticationFilter : GenericFilterBean() {

    override fun doFilter(
            request: ServletRequest,
            response: ServletResponse,
            filterChain: FilterChain
    ) {
        val user =
                FlowUserDetails(
                        userId = 1,
                        name = "mockUser",
                        authoritiesSet = listOf(SimpleGrantedAuthority("ROLE_USER"))
                )

        val authentication =
                UsernamePasswordAuthenticationToken(user, "somepassword", user.authorities)
        SecurityContextHolder.getContext().authentication = authentication

        try {
            filterChain.doFilter(request, response)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
}
