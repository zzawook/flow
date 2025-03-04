package sg.flow.auth;

import java.io.IOException;
import java.util.Optional;

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

        String authorizationHeader = request.getHeader("Authorization");
        if (authorizationHeader == null || (!authorizationHeader.startsWith("Bearer "))) {
            filterChain.doFilter(request, response);
            return;
        }
        String token = authorizationHeader.substring(7); // remove "Bearer "
        this.handleAccessToken(request, response, token);
        filterChain.doFilter(request, response);
    }

    private void handleAccessToken(HttpServletRequest request, HttpServletResponse response, String accessToken) {
        Optional<FlowUserDetails> maybeUser = tokenService.getUserDetailByAccessToken(accessToken);
        if (!maybeUser.isPresent()) {
            // try {
            //     sendUnauthorizedResponse(response);
            // } catch (IOException e) {
            //     e.printStackTrace();
            // }
            return;
        }
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
    }

    private void sendUnauthorizedResponse(HttpServletResponse response) throws IOException {
        response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
    }
}
