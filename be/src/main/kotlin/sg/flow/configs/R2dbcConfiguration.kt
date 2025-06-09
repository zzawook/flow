package sg.flow.configs

import io.r2dbc.pool.ConnectionPool
import io.r2dbc.pool.ConnectionPoolConfiguration
import io.r2dbc.spi.ConnectionFactories
import io.r2dbc.spi.ConnectionFactoryOptions.*
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.r2dbc.config.AbstractR2dbcConfiguration
import org.springframework.r2dbc.connection.R2dbcTransactionManager
import org.springframework.transaction.ReactiveTransactionManager
import java.time.Duration

@Configuration
class R2dbcConfiguration : AbstractR2dbcConfiguration() {

        // ── 1. build the base (non‑pooled) factory ───────────────────────
        private val baseFactory = ConnectionFactories.get(
                builder()
                        .option(DRIVER, "postgresql")
                        .option(HOST, "localhost")
                        .option(PORT, 5432)
                        .option(USER, "flow_developer")
                        .option(PASSWORD, "flowdev123")
                        .option(DATABASE, "flow_dev")
                        .build()
        )

        // ── 2. wrap it in a ConnectionPool with limits ───────────────────
        @Bean
        override fun connectionFactory() = ConnectionPool(
                ConnectionPoolConfiguration.builder(baseFactory)
                        .initialSize(5)                     // open at startup
                        .maxSize(25)                        // hard cap
                        .maxIdleTime(Duration.ofMinutes(30))
                        .build()
        )

        @Bean
        fun transactionManager(): ReactiveTransactionManager =
                R2dbcTransactionManager(connectionFactory())
}
