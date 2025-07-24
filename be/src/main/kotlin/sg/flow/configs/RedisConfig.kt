package sg.flow.configs

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.context.annotation.Profile
import org.springframework.data.redis.connection.ReactiveRedisConnectionFactory
import org.springframework.data.redis.core.ReactiveRedisTemplate
import org.springframework.data.redis.serializer.RedisSerializationContext
import org.springframework.data.redis.serializer.StringRedisSerializer

@Configuration
@Profile("prod")
class RedisConfig {

    @Bean
    fun reactiveRedisTemplate(
            factory: ReactiveRedisConnectionFactory
    ): ReactiveRedisTemplate<String, String> {
        val stringSerializer = StringRedisSerializer()
        val serializationContext =
                RedisSerializationContext.newSerializationContext<String, String>()
                        .key(stringSerializer)
                        .value(stringSerializer)
                        .hashKey(stringSerializer)
                        .hashValue(stringSerializer)
                        .build()

        return ReactiveRedisTemplate(factory, serializationContext)
    }
}
