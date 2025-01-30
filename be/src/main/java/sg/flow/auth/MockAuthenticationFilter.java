package sg.flow.auth;

import java.util.Collections;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.filter.GenericFilterBean;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import sg.flow.models.auth.FlowUserDetails;
import sg.flow.services.AuthServices.FlowTokenService;

public class MockAuthenticationFilter extends GenericFilterBean {

    FlowTokenService tokenService;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) {
        UserDetails user = FlowUserDetails.builder()
                .name("mockUser")
                .userId(1)
                .authorities(Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER")))
                .build();

        UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(user,
                "somepassword",
                user.getAuthorities());
        SecurityContextHolder.getContext().setAuthentication(authentication);
        try {
            filterChain.doFilter(request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
