package sg.flow.configs

import io.grpc.ServerInterceptor
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.annotation.Order
import org.springframework.grpc.server.GlobalServerInterceptor
import org.springframework.http.HttpMethod
import org.springframework.security.config.annotation.web.reactive.EnableWebFluxSecurity
import org.springframework.security.config.web.server.ServerHttpSecurity
import org.springframework.security.web.server.SecurityWebFilterChain
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.reactive.CorsWebFilter
import org.springframework.web.cors.reactive.UrlBasedCorsConfigurationSource
import sg.flow.auth.AccessTokenValidationInterceptor
import sg.flow.services.AuthServices.FlowTokenService
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.beans.factory.annotation.Autowired

@EnableWebFluxSecurity
@Configuration
class FlowSecurityConfig {

    @Bean
    @Order(0)
    @GlobalServerInterceptor
    fun accessTokenValidationInterceptor(
        flowTokenService: FlowTokenService,
        @Autowired(required = false) subscriptionEntitlementService: sg.flow.services.SubscriptionServices.SubscriptionEntitlementService?
    ): ServerInterceptor = AccessTokenValidationInterceptor(flowTokenService, subscriptionEntitlementService)

    @Bean
    fun springSecurityFilterChain(http: ServerHttpSecurity): SecurityWebFilterChain {
        return http
            .csrf { it.disable() }
            .cors { cors ->
                cors.configurationSource(corsConfigSource())
            }
            .authorizeExchange { exchanges ->
                exchanges
                    .pathMatchers(HttpMethod.OPTIONS, "/finverse/webhooks/**").permitAll()
                    .pathMatchers(HttpMethod.OPTIONS, "/finverse/callback").permitAll()
                    .pathMatchers(HttpMethod.POST, "/finverse/webhooks/**").permitAll()
                    .pathMatchers(HttpMethod.GET, "/finverse/callback").permitAll()
                    .pathMatchers(HttpMethod.POST, "/finverse/callback").permitAll()
                    .pathMatchers(HttpMethod.GET, "/auth/email/verify").permitAll()
                    .pathMatchers(HttpMethod.POST, "/subscription/apple").permitAll()
                    .pathMatchers(HttpMethod.POST, "/subscription/apple-sandbox").permitAll()
                    .pathMatchers(HttpMethod.POST, "/subscription/google-pubsub").permitAll()
                    .anyExchange().authenticated()
            }
            .build()
    }

    @Bean
    fun corsConfigSource(): UrlBasedCorsConfigurationSource {
        val config = CorsConfiguration().apply {
            allowedOrigins = listOf("http://localhost:8081", "https://link.prod.finverse.net")
            allowedMethods = listOf("GET", "POST", "OPTIONS")
            allowedHeaders = listOf("*")
            allowCredentials = true
        }
        return UrlBasedCorsConfigurationSource().apply {
            registerCorsConfiguration("/finverse/**", config)
        }
    }

    @Bean
    fun corsWebFilter(source: UrlBasedCorsConfigurationSource): CorsWebFilter {
        return CorsWebFilter(source)
    }

    @Bean
    fun passwordEncoder(): PasswordEncoder =
        Argon2PasswordEncoder(
            16,     // salt length (bytes)
            32,     // hash length (bytes)
            1,      // parallelism
            64_000, // memory (KB) → 64 MB
            3       // iterations
        )
}
