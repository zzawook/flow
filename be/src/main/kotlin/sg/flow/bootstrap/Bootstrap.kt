package sg.flow.bootstrap

import kotlinx.coroutines.runBlocking
import org.springframework.boot.CommandLineRunner
import org.springframework.core.annotation.Order
import org.springframework.core.io.ClassPathResource
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.stereotype.Component
import org.springframework.r2dbc.core.awaitRowsUpdated
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService

@Component
@Order(1)
class Bootstrap(private val databaseClient: DatabaseClient, private val finverseQueryService: FinverseQueryService) : CommandLineRunner {

    override fun run(vararg args: String) {
        println("R2DBC Bootstrap starting – applying schema.sql…")

        // 1. Load the entire SQL file as text
        val resource = ClassPathResource("sql/schema.sql")
        val ddl = resource.inputStream.bufferedReader().use { it.readText() }

        // 2. Split on semicolons, trim out blank statements
        val statements = ddl
            .split(";")
            .map { it.trim() }
            .filter { it.isNotEmpty() }

        // 3. Run each statement in a coroutine
        runBlocking {
            statements.forEach { sql ->
                databaseClient
                    .sql(sql)
                    .fetch()
                    .awaitRowsUpdated()   // suspend until the update completes
            }

            // RUNNING THIS FUNCTION HERE TO AVOID DB QUERY FOR THIS FUNCTION TO RUN BEFORE DB TABLE INITIALIZATION
            finverseQueryService.fetchInstitutionData()
        }



        println("R2DBC Bootstrap completed – schema applied.")
    }
}
