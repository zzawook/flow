package sg.flow.configs

import jakarta.servlet.Filter
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.authentication.AuthenticationManager
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.web.SecurityFilterChain
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter
import sg.flow.auth.AccessTokenValidationFilter
import sg.flow.auth.FlowAccessTokenAuthenticationSuccessHandler
import sg.flow.auth.MockAuthenticationFilter
import sg.flow.auth.RefreshTokenAuthentcationFilter
import sg.flow.services.AuthServices.FlowTokenService

@Configuration
@EnableWebSecurity
class FlowSecurityConfig {

    @Bean
    @Throws(Exception::class)
    fun filterChain(
            http: HttpSecurity,
            flowTokenService: FlowTokenService,
            authManager: AuthenticationManager
    ): SecurityFilterChain {
        val refreshTokenFilter =
                tokenAuthenticationFilter(flowTokenService, authManager).apply {
                    setAuthenticationSuccessHandler(FlowAccessTokenAuthenticationSuccessHandler())
                }
        val accessTokenValidationFilter = accessTokenValidationFilter(flowTokenService)

        http
                .csrf { it.disable() }
                .sessionManagement { it.sessionCreationPolicy(SessionCreationPolicy.STATELESS) }
                .formLogin { it.disable() }
                .requestCache { it.disable() }
                .logout { it.disable() }
                .authorizeHttpRequests { auth ->
                    auth.requestMatchers("/auth/signin")
                            .permitAll()
                            .requestMatchers("/auth/signup")
                            .permitAll()
                            .anyRequest()
                            .authenticated()
                }
                .addFilterBefore(refreshTokenFilter, AnonymousAuthenticationFilter::class.java)
                .addFilterBefore(
                        accessTokenValidationFilter,
                        RefreshTokenAuthentcationFilter::class.java
                )

        return http.build()
    }

    @Bean
    @Throws(Exception::class)
    fun authenticationManager(http: HttpSecurity): AuthenticationManager =
            http.getSharedObject(AuthenticationManagerBuilder::class.java).build()

    @Bean fun mockAuthenticationFilter(): Filter = MockAuthenticationFilter()

    fun tokenAuthenticationFilter(
            flowTokenService: FlowTokenService,
            authManager: AuthenticationManager
    ) = RefreshTokenAuthentcationFilter(flowTokenService, authManager)

    fun accessTokenValidationFilter(flowTokenService: FlowTokenService) =
            AccessTokenValidationFilter(flowTokenService)
}
