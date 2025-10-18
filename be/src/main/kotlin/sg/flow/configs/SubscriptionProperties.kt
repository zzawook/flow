package sg.flow.configs

import org.springframework.boot.context.properties.ConfigurationProperties

@ConfigurationProperties(prefix = "subscription")
data class SubscriptionProperties(
        val price: PriceConfig,
        val ios: IosConfig,
        val android: AndroidConfig,
        val trial: TrialConfig,
        val cache: CacheConfig
)

data class PriceConfig(val sgd: Double)

data class IosConfig(val productId: String, val verifyReceiptUrl: VerifyReceiptUrl)

data class VerifyReceiptUrl(val production: String, val sandbox: String)

data class AndroidConfig(val packageName: String, val productId: String)

data class TrialConfig(val durationDays: Long)

data class CacheConfig(val ttlSeconds: Long)
