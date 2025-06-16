package sg.flow.configs

import io.grpc.ServerInterceptor
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.annotation.Order
import org.springframework.grpc.server.GlobalServerInterceptor
import org.springframework.http.HttpMethod
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.web.SecurityFilterChain
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource
import org.springframework.web.reactive.config.CorsRegistry
import org.springframework.web.reactive.config.WebFluxConfigurer
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import sg.flow.auth.AccessTokenValidationInterceptor
import sg.flow.services.AuthServices.FlowTokenService

@Configuration
class FlowSecurityConfig {

    @Bean
    @Order(0)
    @GlobalServerInterceptor
    fun accessTokenValidationInterceptor(
        flowTokenService: FlowTokenService
    ): ServerInterceptor = AccessTokenValidationInterceptor(flowTokenService)

    @Bean
    fun filterChain(http: HttpSecurity): SecurityFilterChain {
        http
            .cors { cors -> /* no-op: picks up corsConfigurationSource() bean */ }
            .csrf { it.disable() }
            .authorizeHttpRequests { auth ->
                auth
                    .requestMatchers(HttpMethod.OPTIONS, "/finverse/**").permitAll()
                    .requestMatchers("/finverse/**").permitAll()
                    .anyRequest().authenticated()
            }
        // your JWT/session/etc. config here…
        return http.build()
    }

    @Bean
    fun corsConfigurationSource(): CorsConfigurationSource {
        val config = CorsConfiguration().apply {
            allowedOrigins = listOf(
                "http://localhost:8081",
                "https://link.prod.finverse.net"
            )
            allowedMethods = listOf("GET", "POST", "OPTIONS")
            allowedHeaders = listOf("*")
            allowCredentials = true
        }
        return UrlBasedCorsConfigurationSource().apply {
            registerCorsConfiguration("/finverse/**", config)
        }
    }


}
