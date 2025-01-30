package sg.toss_sg.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;

import jakarta.servlet.Filter;
import sg.toss_sg.auth.MockAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class FlowSecurityConfig {

    @Bean
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
                .addFilterBefore(mockAuthenticationFilter(), AnonymousAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    Filter mockAuthenticationFilter() {
        return new MockAuthenticationFilter();
    }
}
