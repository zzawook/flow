package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "flow.daily-asset")
data class DailyAssetProperties(val enabled: Boolean = true)
