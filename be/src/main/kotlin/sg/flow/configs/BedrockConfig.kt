package sg.flow.configs

import java.time.Duration
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.auth.credentials.DefaultCredentialsProvider
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.bedrockruntime.BedrockRuntimeClient

@Configuration
@EnableConfigurationProperties(BedrockProperties::class, TransactionAnalysisProperties::class)
class BedrockConfig(private val bedrockProperties: BedrockProperties) {

    @Bean
    fun bedrockRuntimeClient(): BedrockRuntimeClient {
        return BedrockRuntimeClient.builder()
                .region(Region.of(bedrockProperties.region))
                .credentialsProvider(DefaultCredentialsProvider.create())
                .overrideConfiguration { builder ->
                    builder.apiCallTimeout(Duration.ofMillis(bedrockProperties.timeoutMs))
                            .apiCallAttemptTimeout(Duration.ofMillis(bedrockProperties.timeoutMs))
                }
                .build()
    }
}
