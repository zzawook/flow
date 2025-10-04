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
import org.springframework.stereotype.Component
import reactor.core.publisher.Mono
import sg.flow.models.finverse.FinverseAuthenticationStatus
import sg.flow.models.finverse.FinverseDataRetrievalRequest
import sg.flow.models.finverse.FinverseOverallRetrievalStatus
import sg.flow.services.UtilServices.CacheService.RedisCacheServiceImpl
import kotlin.time.Duration
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
        val key = cacheService.getPostAuthKey(userId, institutionId)

        // 1) build a Mono<FinverseAuthenticationStatus> that completes on the first SET event
        val statusMono: Mono<FinverseAuthenticationStatus> = container
            .receive(PatternTopic("__keyevent@0__:set"))
            .map { msg ->
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
                                FinverseAuthenticationStatus::class.java
                            )
                        } catch (_: Exception) {
                            FinverseAuthenticationStatus.FAILED
                        }
                    }
            }
            .timeout(timeout.toJavaDuration())             // if we never see it, time out
            .onErrorReturn(FinverseAuthenticationStatus.FAILED)

        // 2) await the single result
        return statusMono.awaitSingle()
    }

    suspend fun watchDataRetrievalCompletion(
        loginIdentityId: String,
        timeout: Duration
    ): FinverseOverallRetrievalStatus {
        val key = cacheService.getRefreshSessionPrefix(loginIdentityId)

        val topic = "__keyspace@0__:$key"

        val statusMono: Mono<FinverseOverallRetrievalStatus> = container
            .receive(PatternTopic(topic))
            .map { msg ->
                msg.message
            }
            .filter { it == "hset" || it == "del"}
            .flatMap { ev ->
                when (ev) {
                    "del" -> {
                        Mono.just(FinverseOverallRetrievalStatus(
                            loginIdentityId = loginIdentityId,
                            success = true,
                            message = "Success"
                        ))
                    }
                    else -> {
                        // On SET: fetch the JSON, parse, and only emit if complete
                        redis.opsForHash<String, String>().get(key, "value")
                            .flatMap { rawJson: String ->
                                try {
                                    val dto = objectMapper.readValue(
                                        rawJson,
                                        FinverseDataRetrievalRequest::class.java
                                    )
                                    if (dto.isComplete()) {
                                        Mono.just(dto.getOverallRetrievalStatus())
                                    } else {
                                        Mono.empty()
                                    }
                                } catch (_: Exception) {
                                    // parse‑error → emit failure
                                    Mono.just(FinverseOverallRetrievalStatus(
                                        loginIdentityId = loginIdentityId,
                                        success = false,
                                        message = "Failed to parse"
                                    ))
                                }
                            }
                    }
                }
            }
            .next() // take the first status we actually emitted
            .timeout(timeout.toJavaDuration())     // optional overall timeout
            .onErrorReturn(                       // fallback on timeout or error
                FinverseOverallRetrievalStatus(
                    loginIdentityId = loginIdentityId,
                    success = false,
                    message = "timeout"
                )
            )

        return statusMono.awaitSingle()
    }
}