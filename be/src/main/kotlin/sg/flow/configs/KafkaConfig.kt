package sg.flow.configs

import org.apache.kafka.clients.consumer.ConsumerConfig
import org.apache.kafka.clients.producer.ProducerConfig
import org.apache.kafka.common.serialization.StringDeserializer
import org.apache.kafka.common.serialization.StringSerializer
import org.springframework.beans.factory.annotation.Value
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.kafka.config.ConcurrentKafkaListenerContainerFactory
import org.springframework.kafka.core.*
import org.springframework.kafka.listener.ContainerProperties
import org.springframework.kafka.support.serializer.JsonDeserializer
import org.springframework.kafka.support.serializer.JsonSerializer

@Configuration
class KafkaConfig(
        @Value("\${spring.kafka.bootstrap-servers}") private val bootstrapServers: String,
        @Value("\${spring.kafka.consumer.group-id}") private val groupId: String
) {

        @Bean
        fun producerFactory(): ProducerFactory<String, Any> {
                val configProps =
                        mapOf<String, Any>(
                                ProducerConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServers,
                                ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG to
                                        StringSerializer::class.java,
                                ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG to
                                        JsonSerializer::class.java,
                                ProducerConfig.ACKS_CONFIG to "all",
                                ProducerConfig.RETRIES_CONFIG to 3,
                                ProducerConfig.ENABLE_IDEMPOTENCE_CONFIG to true
                        )
                return DefaultKafkaProducerFactory(configProps)
        }

        @Bean
        fun kafkaTemplate(): KafkaTemplate<String, Any> {
                return KafkaTemplate(producerFactory())
        }

        @Bean
        fun consumerFactory(): ConsumerFactory<String, Any> {
                val configProps =
                        mapOf<String, Any>(
                                ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServers,
                                ConsumerConfig.GROUP_ID_CONFIG to groupId,
                                ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG to
                                        StringDeserializer::class.java,
                                ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG to
                                        JsonDeserializer::class.java,
                                ConsumerConfig.AUTO_OFFSET_RESET_CONFIG to "earliest",
                                JsonDeserializer.TRUSTED_PACKAGES to "sg.flow.events",
                                JsonDeserializer.USE_TYPE_INFO_HEADERS to false,
                                JsonDeserializer.REMOVE_TYPE_INFO_HEADERS to false
                        )
                return DefaultKafkaConsumerFactory(configProps)
        }

        @Bean
        fun webhookConsumerFactory(): ConsumerFactory<String, sg.flow.events.FinverseWebhookEvent> {
                val configProps =
                        mapOf<String, Any>(
                                ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServers,
                                ConsumerConfig.GROUP_ID_CONFIG to groupId,
                                ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG to
                                        StringDeserializer::class.java,
                                ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG to
                                        JsonDeserializer::class.java,
                                ConsumerConfig.AUTO_OFFSET_RESET_CONFIG to "earliest",
                                JsonDeserializer.TRUSTED_PACKAGES to "sg.flow.events",
                                JsonDeserializer.VALUE_DEFAULT_TYPE to
                                        "sg.flow.events.FinverseWebhookEvent",
                                JsonDeserializer.USE_TYPE_INFO_HEADERS to false
                        )
                return DefaultKafkaConsumerFactory(configProps)
        }

        @Bean
        fun authCallbackConsumerFactory():
                ConsumerFactory<String, sg.flow.events.FinverseAuthCallbackEvent> {
                val configProps =
                        mapOf<String, Any>(
                                ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServers,
                                ConsumerConfig.GROUP_ID_CONFIG to groupId,
                                ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG to
                                        StringDeserializer::class.java,
                                ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG to
                                        JsonDeserializer::class.java,
                                ConsumerConfig.AUTO_OFFSET_RESET_CONFIG to "earliest",
                                JsonDeserializer.TRUSTED_PACKAGES to "sg.flow.events",
                                JsonDeserializer.VALUE_DEFAULT_TYPE to
                                        "sg.flow.events.FinverseAuthCallbackEvent",
                                JsonDeserializer.USE_TYPE_INFO_HEADERS to false
                        )
                return DefaultKafkaConsumerFactory(configProps)
        }

        @Bean
        fun timeoutConsumerFactory(): ConsumerFactory<String, sg.flow.events.FinverseTimeoutEvent> {
                val configProps =
                        mapOf<String, Any>(
                                ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG to bootstrapServers,
                                ConsumerConfig.GROUP_ID_CONFIG to groupId,
                                ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG to
                                        StringDeserializer::class.java,
                                ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG to
                                        JsonDeserializer::class.java,
                                ConsumerConfig.AUTO_OFFSET_RESET_CONFIG to "earliest",
                                JsonDeserializer.TRUSTED_PACKAGES to "sg.flow.events",
                                JsonDeserializer.VALUE_DEFAULT_TYPE to
                                        "sg.flow.events.FinverseTimeoutEvent",
                                JsonDeserializer.USE_TYPE_INFO_HEADERS to false
                        )
                return DefaultKafkaConsumerFactory(configProps)
        }

        @Bean
        fun webhookKafkaListenerContainerFactory():
                ConcurrentKafkaListenerContainerFactory<
                        String, sg.flow.events.FinverseWebhookEvent> {
                val factory =
                        ConcurrentKafkaListenerContainerFactory<
                                String, sg.flow.events.FinverseWebhookEvent>()
                factory.consumerFactory = webhookConsumerFactory()
                // Use MANUAL_IMMEDIATE mode for suspend functions to properly handle async ack
                factory.containerProperties.ackMode = ContainerProperties.AckMode.MANUAL_IMMEDIATE
                return factory
        }

        @Bean
        fun authCallbackKafkaListenerContainerFactory():
                ConcurrentKafkaListenerContainerFactory<
                        String, sg.flow.events.FinverseAuthCallbackEvent> {
                val factory =
                        ConcurrentKafkaListenerContainerFactory<
                                String, sg.flow.events.FinverseAuthCallbackEvent>()
                factory.consumerFactory = authCallbackConsumerFactory()
                // Use MANUAL_IMMEDIATE mode for suspend functions to properly handle async ack
                factory.containerProperties.ackMode = ContainerProperties.AckMode.MANUAL_IMMEDIATE
                return factory
        }

        @Bean
        fun timeoutKafkaListenerContainerFactory():
                ConcurrentKafkaListenerContainerFactory<
                        String, sg.flow.events.FinverseTimeoutEvent> {
                val factory =
                        ConcurrentKafkaListenerContainerFactory<
                                String, sg.flow.events.FinverseTimeoutEvent>()
                factory.consumerFactory = timeoutConsumerFactory()
                // Use MANUAL_IMMEDIATE mode for suspend functions to properly handle async ack
                factory.containerProperties.ackMode = ContainerProperties.AckMode.MANUAL_IMMEDIATE
                return factory
        }

        @Bean
        fun kafkaListenerContainerFactory(): ConcurrentKafkaListenerContainerFactory<String, Any> {
                val factory = ConcurrentKafkaListenerContainerFactory<String, Any>()
                factory.consumerFactory = consumerFactory()
                // Use MANUAL_IMMEDIATE mode for suspend functions to properly handle async ack
                factory.containerProperties.ackMode = ContainerProperties.AckMode.MANUAL_IMMEDIATE
                return factory
        }
}
