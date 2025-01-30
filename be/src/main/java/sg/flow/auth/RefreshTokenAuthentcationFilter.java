package sg.flow.auth;

import java.io.IOException;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AbstractAuthenticationProcessingFilter;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sg.flow.models.auth.TokenSet;
import sg.flow.services.AuthServices.FlowTokenService;

public class RefreshTokenAuthentcationFilter extends AbstractAuthenticationProcessingFilter {

    @Autowired
    private final FlowTokenService tokenService;

    public RefreshTokenAuthentcationFilter(FlowTokenService tokenService, AuthenticationManager authManager) {
        super(new AntPathRequestMatcher("/auth/getAccessToken", "POST"));
        setAuthenticationManager(authManager);
        this.tokenService = tokenService;
    }

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException, IOException, ServletException {
        String header = request.getHeader("Authorization");
        if (header == null || !header.startsWith("Bearer ")) {
            throw new BadCredentialsException("No Bearer token found in request headers");
        }
        String refreshToken = header.substring(7);
        Authentication auth = handleRefreshToken(refreshToken);

        return auth;
    }

    private Authentication handleRefreshToken(String refreshToken) {
        Optional<TokenSet> maybeNewTokenSet = tokenService.getAccessTokenByRefreshToken(refreshToken);
        if (!maybeNewTokenSet.isPresent()) {
            throw new BadCredentialsException("Refresh token invalid");
        }
        TokenSet newtokenSet = maybeNewTokenSet.get();
        String newAccessToken = newtokenSet.getAccessToken();
        String newRefreshToken = newtokenSet.getRefreshToken();

        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(null, null, null);

        authentication.setDetails(new TokenSet(newAccessToken, newRefreshToken));

        return authentication;
    }
}
