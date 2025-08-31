package sg.flow.services.UtilServices.CacheService

import com.fasterxml.jackson.databind.ObjectMapper
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.withContext
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.beans.factory.config.ConfigurableBeanFactory
import org.springframework.context.annotation.Scope
import org.springframework.data.redis.connection.DefaultStringRedisConnection
import org.springframework.data.redis.connection.RedisConnection
import org.springframework.data.redis.connection.RedisConnectionFactory
import org.springframework.data.redis.connection.StringRedisConnection
import org.springframework.stereotype.Component

/*
This class exists to implement and simplify Compare And Store operation on Redis.
Apart from RedisCacheServiceImpl, which serves cache operation based on asynchronous Reactive redis template,
this Operation class works on synchronous single connection to provide retry based on whether the value has been
modified since read.

This class is needed for a specific purpose: Handling webhooks and callbacks that are unordered and maybe simultaneous.
To gracefully handle them, so that they do not incur dirty write, some form of lock behavior is required, and this
CAS Operation class will handle it. In other cases that does not have such requirement can use RedisCacheServiceImpl
through general CacheService interface to take advantage of Reactive Redis Template.
 */

@Component
@Scope(ConfigurableBeanFactory.SCOPE_PROTOTYPE) // new instance per use
class RedisCompareAndStoreOperation {

    @Autowired lateinit var cf: RedisConnectionFactory
    @Autowired lateinit var objectMapper: ObjectMapper

    // runtime config per use
    private lateinit var key: String
    private var createTtlMs: Long? = null
    private var maxRetries: Int = 5
    private var backoffMs: Long = 15

    private val keyBytes: ByteArray get() = key.toByteArray(Charsets.UTF_8)

    fun configure(
        key: String,
        createTtlMs: Long? = null,         // apply only when creating the key
        maxRetries: Int = 5,
        backoffMs: Long = 15
    ): RedisCompareAndStoreOperation {
        this.key = key
        this.createTtlMs = createTtlMs
        this.maxRetries = maxRetries
        this.backoffMs = backoffMs
        return this
    }

    /**
     * JSON-mapper variant:
     * - mapper receives the current JSON (or null if missing) and must return the next JSON.
     * - returns true if committed, false if all retries conflicted.
     */
    suspend fun storeWithRetryOnCas(
        mapper: suspend (currentJson: String?) -> String
    ): Boolean = withContext(Dispatchers.IO) {
        require(::key.isInitialized) { "Call configure(key, ...) before storeWithRetryOnCas" }

        val raw: RedisConnection = cf.connection
        val str: StringRedisConnection = DefaultStringRedisConnection(raw)

        try {
            repeat(maxRetries) { attempt ->
                // Start optimistic watch for this attempt
                raw.watch(keyBytes)

                // Snapshot TTL/existence
                val keys = raw.keyCommands()
                val ttlAtReadMs: Long = keys.pTtl(keyBytes) ?: -2L  // -2: missing, -1: no TTL, >=0: ms left
                val existedAtRead: Boolean = ttlAtReadMs != -2L

                // Read current JSON (null if key/field missing)
                val currentJson: String? = str.hGet(key, "value")

                // Compute next JSON
                val nextJson: String = mapper(currentJson)

                if (nextJson.isEmpty()) {
                    return@repeat
                }

                // Queue mutations
                raw.multi()
                str.hSet(key, "value", nextJson) // HSET key value <nextJson>
                str.hIncrBy(key, "rev", 1)       // HINCRBY key rev 1

                // Preserve existing TTL or apply initial TTL on first create
                when {
                    ttlAtReadMs > 0 -> keys.pExpire(keyBytes, ttlAtReadMs)
                    !existedAtRead && createTtlMs != null && createTtlMs!! > 0 ->
                        keys.pExpire(keyBytes, createTtlMs!!)
                }

                // Try to commit
                val exec = raw.exec()            // null ⇒ conflict (someone changed after WATCH)
                if (exec != null) return@withContext true

                // Conflict → back off and retry with a *fresh* snapshot
                raw.unwatch()

                delay(backoffMs * (attempt + 1))
            }
            false
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
        finally {
            try { raw.unwatch() } catch (_: Exception) {}
            try { (str as AutoCloseable).close() } catch (_: Exception) {}
        }
    }

    /**
     * Typed mapper variant (uses Jackson):
     * - mapper receives T? and returns T
     * - we handle (de)serialization to the hash field "value".
     */
    suspend fun <T : Any> storeWithRetryOnCas(
        type: kotlin.reflect.KClass<T>,
        mapper: (T?) -> T
    ): Boolean {
        return storeWithRetryOnCas { currentJson ->
            val curObj: T? = currentJson?.let { objectMapper.readValue(it, type.java) }
            val nextObj: T = mapper(curObj)
            objectMapper.writeValueAsString(nextObj)
        }
    }

    suspend fun <T : Any> storeWithRetryOnCasReturning(
        type: kotlin.reflect.KClass<T>,
        mapper: suspend (T?) -> T
    ): CasResult<T> {
        var lastObj: T? = null
        val committed = storeWithRetryOnCas { currentJson ->
            val curObj: T? = currentJson?.let { objectMapper.readValue(it, type.java) }
            val nextObj: T = mapper(curObj)     // you can call suspend funcs here
            lastObj = nextObj                   // remember what we attempted to write
            objectMapper.writeValueAsString(nextObj)
        }
        return CasResult(committed, if (committed) lastObj else null)
    }
}
