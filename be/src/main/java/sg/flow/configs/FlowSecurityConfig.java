package sg.flow.configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;

import jakarta.servlet.Filter;
import sg.flow.auth.MockAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class FlowSecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .authorizeHttpRequests(auth -> auth.anyRequest().authenticated())
                .addFilterBefore(mockAuthenticationFilter(), AnonymousAuthenticationFilter.class); // 필터 추가

        return http.build();
    }

    @Bean
    public Filter mockAuthenticationFilter() {
        return new MockAuthenticationFilter();
    }
}
