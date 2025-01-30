package sg.flow.auth;

import java.io.IOException;
import java.util.Optional;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import jakarta.servlet.FilterChain;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sg.flow.models.auth.FlowUserDetails;
import sg.flow.services.AuthServices.FlowTokenService;

public class AccessTokenValidationFilter extends OncePerRequestFilter {
    private final FlowTokenService tokenService;

    public AccessTokenValidationFilter(FlowTokenService tokenService) {
        this.tokenService = tokenService;
    }

    @SuppressWarnings("null")
    @Override
    protected void doFilterInternal(HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain)
            throws IOException, jakarta.servlet.ServletException {

        // 1. Extract token from Authorization header (Bearer ...)
        String authorizationHeader = request.getHeader("Authorization");
        if (authorizationHeader != null && authorizationHeader.startsWith("Bearer ")) {
            String token = authorizationHeader.substring(7); // remove "Bearer "

            // 2. Validate token: check if it exists in Cache or Vault
            try {
                Optional<FlowUserDetails> maybeUser = tokenService.getUserDetailByAccessToken(token);
                if (maybeUser.isPresent()) {
                    FlowUserDetails userDetails = maybeUser.get();

                    // 3. Create Authentication object and set in SecurityContext
                    UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities());
                    // optionally set details
                    authenticationToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request));

                    SecurityContextHolder.getContext().setAuthentication(authenticationToken);
                } else {
                    // Token not found or invalid in cache/vault
                    throw new BadCredentialsException("Invalid or expired access token");
                }
            } catch (Exception ex) {
                // If token check fails, you can either clear the context and continue
                // (anonymous)
                // or set an error status. Typically you'd reject the request with 401:

                SecurityContextHolder.clearContext();
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, ex.getMessage());
                return; // short-circuit the chain
            }
        }

        // 4. Proceed with the filter chain if token is valid or not present
        filterChain.doFilter(request, response);
    }
}
