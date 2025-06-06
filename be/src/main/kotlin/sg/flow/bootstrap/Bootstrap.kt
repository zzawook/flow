package sg.flow.bootstrap

import org.springframework.boot.CommandLineRunner
import org.springframework.core.annotation.Order
import org.springframework.core.io.ClassPathResource
import org.springframework.jdbc.datasource.init.ScriptUtils
import org.springframework.stereotype.Component
import sg.flow.configs.DatabaseConnectionPool

@Component
@Order(1)
class Bootstrap(private val databaseConnectionPool: DatabaseConnectionPool) : CommandLineRunner {

    override fun run(vararg args: String) {
        createTableIfNotExists()
    }

    private fun createTableIfNotExists() {
        val resource = ClassPathResource("sql/schema.sql")

        try {
            databaseConnectionPool.getConnection()?.use { connection ->
                ScriptUtils.executeSqlScript(connection, resource)
                println("SQL file executed successfully.")
            }
        } catch (e: Exception) {
            System.err.println("Failed to execute SQL file: ${e.message}")
        }
    }
}
