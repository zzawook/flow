package sg.flow.configs

import io.grpc.ServerInterceptor
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.core.annotation.Order
import org.springframework.grpc.server.GlobalServerInterceptor
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

}
