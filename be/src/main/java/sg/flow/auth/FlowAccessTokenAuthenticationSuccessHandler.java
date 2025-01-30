package sg.flow.auth;

import java.io.IOException;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import sg.flow.models.auth.TokenSet;

public class FlowAccessTokenAuthenticationSuccessHandler implements AuthenticationSuccessHandler {

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
            Authentication authentication) throws IOException, ServletException {
        Object details = authentication.getDetails();
        if (details instanceof TokenSet) {
            String newAccessToken = ((TokenSet) details).getAccessToken();
            String newRefreshToken = ((TokenSet) details).getRefreshToken();

            // Build JSON or any response format
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            String json = new ObjectMapper().writeValueAsString(Map.of(
                    "accessToken", newAccessToken,
                    "refreshToken", newRefreshToken));
            response.getWriter().write(json);
            response.getWriter().flush();
        }
    }

}
