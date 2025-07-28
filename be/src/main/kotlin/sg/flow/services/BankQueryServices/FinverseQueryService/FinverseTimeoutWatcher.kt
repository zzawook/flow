package sg.flow.services.BankQueryServices.FinverseQueryService

import com.fasterxml.jackson.databind.ObjectMapper
import com.nimbusds.jose.util.StandardCharset
import kotlinx.coroutines.TimeoutCancellationException
import kotlinx.coroutines.reactive.awaitSingle
import kotlinx.coroutines.reactor.awaitSingle
import kotlinx.coroutines.withTimeout
import org.slf4j.LoggerFactory
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.data.redis.listener.PatternTopic
import org.springframework.data.redis.listener.ReactiveRedisMessageListenerContainer
import org.springframework.kafka.annotation.KafkaListener
import org.springframework.kafka.support.Acknowledgment
import org.springframework.stereotype.Component
import reactor.core.publisher.Mono
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.models.finverse.webhook_events.FinverseWebhookEvent
import sg.flow.services.UtilServices.CacheService
import sg.flow.services.UtilServices.RedisCacheServiceImpl
import java.nio.charset.StandardCharsets
import kotlin.time.Duration
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.CompletableFuture
import kotlin.time.toJavaDuration

@Component
class FinverseTimeoutWatcher(
    private val cacheService: RedisCacheServiceImpl,
    private val container: ReactiveRedisMessageListenerContainer,
    private val redis: ReactiveRedisTemplate<String, String>,
    private val objectMapper: ObjectMapper
) {

    private val logger = LoggerFactory.getLogger(FinverseTimeoutWatcher::class.java)


    suspend fun watchAuthentication(
        userId: Int,
        institutionId: String,
        timeout: Duration
    ): FinverseAuthenticationStatus {
        val key = cacheService.getRefreshSessionPrefix(userId, institutionId)

        // 1) build a Mono<FinverseAuthenticationStatus> that completes on the first SET event
        val statusMono: Mono<FinverseAuthenticationStatus> = container
            .receive(PatternTopic("__keyevent@0__:set"))
            .map { msg ->
                println(msg)
                msg.message
            }
            .filter { it == key }       // only our key
            .next()                     // take the first matching element, convert Flux→Mono
            .flatMap {
                // once we see the SET, grab the current value and map to a status
                redis.opsForValue().get(key)
                    .map { newVal ->
                        try {
                            objectMapper.readValue(
                                newVal,
                                FinverseDataRetrievalRequest::class.java
                            )
                            FinverseAuthenticationStatus.AUTHENTICATED
                        } catch (_: Exception) {
                            FinverseAuthenticationStatus.AUTHENTICATION_FAILED
                        }
                    }
            }
            .timeout(timeout.toJavaDuration())             // if we never see it, time out
            .onErrorReturn(FinverseAuthenticationStatus.AUTHENTICATION_FAILED)

        // 2) await the single result
        return statusMono.awaitSingle()
    }

    suspend fun watchDataRetrievalCompletion(
        userId: Int,
        institutionId: String,
        timeout: Duration
    ): FinverseOverallRetrievalStatus {
        val key = cacheService.getRefreshSessionPrefix(userId, institutionId)
        val loginIdentity = cacheService
            .getLoginIdentityCredential(userId, institutionId)
            ?: throw IllegalStateException("No loginIdentity")

        val topic = "__keyspace@0__:$key"

        val statusMono: Mono<FinverseOverallRetrievalStatus> = container
            .receive(PatternTopic(topic))
            .map { msg ->
                println(msg)
                msg.message
            }
            .filter { it == "set" || it == "expire" }
            .flatMap { ev ->
                if (ev == "expire") {
                    println("EXPIRED")
                    Mono.just(FinverseOverallRetrievalStatus(
                        loginIdentityId = loginIdentity.loginIdentityId,
                        success = true,
                        message = ""
                    ))
                } else {
                    // On SET: fetch the JSON, parse, and only emit if complete
                    redis.opsForValue().get(key)
                        .flatMap { rawJson ->
                            try {
                                val dto = objectMapper.readValue(
                                    rawJson,
                                    FinverseDataRetrievalRequest::class.java
                                )
                                if (dto.isComplete()) {
                                    println("COMPLETED")
                                    Mono.just(dto.getOverallRetrievalStatus())
                                } else {
                                    Mono.empty()
                                }
                            } catch (_: Exception) {
                                // parse‑error → emit failure
                                Mono.just(FinverseOverallRetrievalStatus(
                                    loginIdentityId = loginIdentity.loginIdentityId,
                                    success = false,
                                    message = "Failed to parse"
                                ))
                            }
                        }
                }
            }
            .next() // take the first status we actually emitted
            .timeout(timeout.toJavaDuration())     // optional overall timeout
            .onErrorReturn(                       // fallback on timeout or error
                FinverseOverallRetrievalStatus(
                    loginIdentityId = loginIdentity.loginIdentityId,
                    success = false,
                    message = "timeout"
                )
            )

        return statusMono.awaitSingle()
    }
}