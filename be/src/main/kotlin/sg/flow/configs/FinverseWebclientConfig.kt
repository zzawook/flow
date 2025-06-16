package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.reactive.function.client.WebClient

@ConfigurationProperties("finverse-webclient")
class FinverseWebclientProperties{
    lateinit var baseUrl: String
}

@Configuration
@EnableConfigurationProperties(FinverseWebclientProperties::class)
class FinverseWebclientConfig(private val props: FinverseWebclientProperties) {
    @Bean
    fun webClient(): WebClient {
        return WebClient.builder()
            .baseUrl(props.baseUrl)
            .build()
    }
}