package sg.flow.bootstrap

import org.springframework.boot.CommandLineRunner
import org.springframework.core.annotation.Order
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.stereotype.Component

@Component
@Order(1)
class Bootstrap(private val databaseClient: DatabaseClient) : CommandLineRunner {

    override fun run(vararg args: String) {
        // R2DBC bootstrap - simplified for now
        // Real implementation would use R2DBC to execute schema scripts
        println("R2DBC Bootstrap completed - schema should be managed via migration tools")
    }
}
