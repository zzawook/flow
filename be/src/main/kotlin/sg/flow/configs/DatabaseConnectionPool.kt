package sg.flow.configs

import com.zaxxer.hikari.HikariConfig
import com.zaxxer.hikari.HikariDataSource
import java.sql.Connection
import java.sql.SQLException
import javax.sql.DataSource
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration

@Configuration
class DatabaseConnectionPool private constructor() {

    private val dataSource: DataSource

    init {
        val config =
                HikariConfig().apply {
                    jdbcUrl = "jdbc:postgresql://localhost:5432/flow_dev"
                    username = "flow_developer"
                    password = "flowdev123"

                    // HikariCP settings
                    maximumPoolSize = 100
                    minimumIdle = 2
                    idleTimeout = 30_000
                    maxLifetime = 1_800_000
                    connectionTimeout = 20_000
                }

        dataSource = HikariDataSource(config)
        instance = this
    }

    fun getConnection(): Connection? =
            try {
                dataSource.connection
            } catch (e: SQLException) {
                e.printStackTrace()
                null
            }

    companion object {
        @Volatile private var instance: DatabaseConnectionPool? = null

        @JvmStatic
        fun getInstance(): DatabaseConnectionPool =
                instance
                        ?: synchronized(this) {
                            instance ?: DatabaseConnectionPool().also { instance = it }
                        }

        @Bean @JvmStatic fun databaseConnectionPool(): DatabaseConnectionPool = getInstance()
    }
}
