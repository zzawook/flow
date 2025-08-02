package sg.flow.configs

import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Configuration

@Configuration
@EnableConfigurationProperties(BedrockProperties::class, TransactionAnalysisProperties::class)
class BedrockConfig(private val bedrockProperties: BedrockProperties) {

}
