package sg.toss_sg.auth;

import java.io.IOException;
import java.util.Optional;

import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sg.toss_sg.models.auth.FlowUserDetails;
import sg.toss_sg.models.auth.TokenLoginRequest;
import sg.toss_sg.services.AuthServices.FlowTokenService;

public class TokenAuthentcationFilter extends AbstractAuthenticationProcessingFilter {
    private final FlowTokenService tokenService;

    public TokenAuthentcationFilter(FlowTokenService tokenService) {
        super(new AntPathRequestMatcher("/auth/login", "POST"));
        this.tokenService = tokenService;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException, IOException, ServletException {
        ObjectMapper objectMapper = new ObjectMapper();
        TokenLoginRequest loginRequest = objectMapper.readValue(
                request.getInputStream(), 
                TokenLoginRequest.class
        );

        String tokenType = loginRequest.getTokenType();
        String tokenValue = loginRequest.getTokenValue();

        if ("access".equalsIgnoreCase(tokenType)) {
            return handleAccessToken(tokenValue);
        } else if ("refresh".equalsIgnoreCase(tokenType)) {
            return handleRefreshToken(tokenValue);
        }

        throw new BadCredentialsException("Invalid token type");
    }   
    
    private Authentication handleAccessToken(String token) {
        Optional<FlowUserDetails> maybeUserDetail = tokenService.getUserDetailByAccessToken(token);
        if (!maybeUserDetail.isPresent()) {
            throw new BadCredentialsException("Access token invalid");
        }
        FlowUserDetails user = maybeUserDetail.get();
        // create authentication
        UsernamePasswordAuthenticationToken authToken =
                new UsernamePasswordAuthenticationToken(
                        user,
                        null,
                        user.getAuthorities()
                );
        return authToken;
    }

    private Authentication handleRefreshToken(String refreshToken) {
        Optional<String> newAccessToken = tokenService.getAccessTokenByRefreshToken(refreshToken);
        if (!newAccessToken.isPresent()) {
            throw new BadCredentialsException("Refresh token invalid");
        }
        String accessToken = newAccessToken.get();
        return this.handleAccessToken(accessToken);
    }
}
