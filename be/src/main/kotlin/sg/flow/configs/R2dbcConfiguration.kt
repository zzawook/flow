package sg.flow.configs

import io.r2dbc.spi.ConnectionFactories
import io.r2dbc.spi.ConnectionFactory
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration
import org.springframework.r2dbc.connection.R2dbcTransactionManager
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.transaction.ReactiveTransactionManager

@Configuration
class R2dbcConfiguration : AbstractR2dbcConfiguration() {

        @Bean
        override fun connectionFactory(): ConnectionFactory {
                return ConnectionFactories.get(
                        "r2dbc:postgresql://flow_developer:flowdev123@localhost:5432/flow_dev"
                )
        }

        @Bean
        override fun databaseClient(): DatabaseClient = DatabaseClient.create(connectionFactory())

        @Bean
        fun transactionManager(): ReactiveTransactionManager =
                R2dbcTransactionManager(connectionFactory())
}
