package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import aws.sdk.kotlin.runtime.auth.credentials.DefaultChainCredentialsProvider
import aws.sdk.kotlin.services.bedrockagentruntime.BedrockAgentRuntimeClient

@Configuration
class AWSCredentialConfig {

    @Bean
    fun bedrockAgentRuntimeClient(awsProperties: AWSProperties): BedrockAgentRuntimeClient {
        return BedrockAgentRuntimeClient {
            region = awsProperties.region
            credentialsProvider = DefaultChainCredentialsProvider()
        }
    }
}

@ConfigurationProperties(prefix = "aws")
data class AWSProperties(
    val region: String = "us-east-1"
)