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
    SecurityFilterChain filterChain(HttpSecurity http, FlowTokenService flowTokenService,
            AuthenticationManager authManager) throws Exception {
        RefreshTokenAuthentcationFilter refreshTokenFilter = tokenAuthenticationFilter(flowTokenService, authManager);
        refreshTokenFilter.setAuthenticationSuccessHandler(new FlowAccessTokenAuthenticationSuccessHandler());

        AccessTokenValidationFilter accessTokenValidationFilter = accessTokenValidationFilter(flowTokenService);

        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/auth/signin").permitAll()
                        .requestMatchers("/auth/signup").permitAll()
                        .anyRequest().authenticated())
                .addFilterBefore(refreshTokenFilter, AnonymousAuthenticationFilter.class)
                .addFilterBefore(accessTokenValidationFilter, RefreshTokenAuthentcationFilter.class);

        return http.build();
    }

    @Bean
    AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        return http.getSharedObject(AuthenticationManagerBuilder.class).build();
    }

    @Bean
    Filter mockAuthenticationFilter() {
        return new MockAuthenticationFilter();
    }

    RefreshTokenAuthentcationFilter tokenAuthenticationFilter(FlowTokenService flowTokenService,
            AuthenticationManager authManager) {
        return new RefreshTokenAuthentcationFilter(flowTokenService, authManager);
    }

    AccessTokenValidationFilter accessTokenValidationFilter(FlowTokenService flowTokenService) {
        return new AccessTokenValidationFilter(flowTokenService);
    }
}
