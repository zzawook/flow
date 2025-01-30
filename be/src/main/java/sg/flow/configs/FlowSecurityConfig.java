package sg.flow.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;

import jakarta.servlet.Filter;
import sg.flow.auth.AccessTokenValidationFilter;
import sg.flow.auth.FlowAccessTokenAuthenticationSuccessHandler;
import sg.flow.auth.MockAuthenticationFilter;
import sg.flow.auth.RefreshTokenAuthentcationFilter;
import sg.flow.services.AuthServices.FlowTokenService;

@Configuration
@EnableWebSecurity
public class FlowSecurityConfig {

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http, FlowTokenService flowTokenService) throws Exception {
        AuthenticationManagerBuilder authBuilder = http.getSharedObject(AuthenticationManagerBuilder.class);
        AuthenticationManager authManager = authBuilder.build();

        RefreshTokenAuthentcationFilter refreshTokenFilter = tokenAuthenticationFilter(flowTokenService, authManager);
        refreshTokenFilter.setAuthenticationSuccessHandler(new FlowAccessTokenAuthenticationSuccessHandler());

        AccessTokenValidationFilter accessTokenValidationFilter = accessTokenValidationFilter(flowTokenService);

        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/getAccessToken").permitAll()
                        .requestMatchers("/auth/register").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(accessTokenValidationFilter, RefreshTokenAuthentcationFilter.class)
                .addFilterBefore(refreshTokenFilter, AnonymousAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    Filter mockAuthenticationFilter() {
        return new MockAuthenticationFilter();
    }

    @Bean
    RefreshTokenAuthentcationFilter tokenAuthenticationFilter(FlowTokenService flowTokenService,
            AuthenticationManager authManager) {
        return new RefreshTokenAuthentcationFilter(flowTokenService, authManager);
    }

    @Bean
    AccessTokenValidationFilter accessTokenValidationFilter(FlowTokenService flowTokenService) {
        return new AccessTokenValidationFilter(flowTokenService);
    }
}
