package sg.flow.services.AuthServices

import kotlinx.coroutines.reactor.awaitSingle
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.data.redis.listener.PatternTopic
import org.springframework.data.redis.listener.ReactiveRedisMessageListenerContainer
import org.springframework.stereotype.Component
import reactor.core.publisher.Mono
import sg.flow.services.UtilServices.CacheService.RedisCacheServiceImpl
import kotlin.time.Duration
import kotlin.time.toJavaDuration

@Component
class AuthTimeoutWatcher(
    private val cacheService: RedisCacheServiceImpl,
    private val container: ReactiveRedisMessageListenerContainer,
    private val redis: ReactiveRedisTemplate<String, String>,
) {
    suspend fun watchEmailVerification(email: String, timeout: Duration): Boolean {
        val key = cacheService.getEmailVerificationSessionWildcardKey(email)

        val topic = "__keyspace@0__:$key"

        val statusMono: Mono<Boolean> = container
            .receive(PatternTopic(topic))
            .map { msg ->
                msg.message
            }
            .filter { it == "del" }
            .flatMap { ev ->
                when (ev) {
                    "del" -> {
                        Mono.just(true)
                    }
                    else -> {
                        Mono.just(false)
                    }
                }
            }
            .next()
            .timeout(timeout.toJavaDuration())
            .onErrorReturn(
                false
            )

        return statusMono.awaitSingle()
    }

}