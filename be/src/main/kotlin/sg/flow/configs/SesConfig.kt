package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import software.amazon.awssdk.regions.Region
import software.amazon.awssdk.services.sesv2.SesV2AsyncClient

@Configuration
@EnableConfigurationProperties(FlowEmailProps::class)
class SesConfig(private val props: FlowEmailProps) {

    @Bean
    fun sesClient(): SesV2AsyncClient =
        SesV2AsyncClient.builder()
            .region(Region.of(props.region))
            .build() // creds from DefaultCredentialsProvider (IRSA, EC2, env, profile)
}

@ConfigurationProperties(prefix = "flow.email")
data class FlowEmailProps(
    val region: String,
    val sender: String,
    val templates: Templates
) {
    data class Templates(val en: String)
}

@ConfigurationProperties(prefix = "flow.magiclink")
data class MagicLinkProps(
    val baseUrl: String,
    val issuer: String,
    val ttlMinutes: Long,
    val hmacSecret: String,
    val redirectUrl: String,
    val failRedirectUrl: String,
)