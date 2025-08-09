package sg.flow.bootstrap

import kotlinx.coroutines.runBlocking
import org.springframework.boot.CommandLineRunner
import org.springframework.core.annotation.Order
import org.springframework.core.io.ClassPathResource
import org.springframework.r2dbc.core.DatabaseClient
import org.springframework.stereotype.Component
import org.springframework.r2dbc.core.awaitRowsUpdated
import sg.flow.services.BankQueryServices.FinverseQueryService.FinverseQueryService
import org.slf4j.LoggerFactory

@Component
@Order(1)
class Bootstrap(private val databaseClient: DatabaseClient, private val finverseQueryService: FinverseQueryService) : CommandLineRunner {

    private val logger = LoggerFactory.getLogger(Bootstrap::class.java)

    override fun run(vararg args: String) {
        logger.info("R2DBC Bootstrap starting – applying schema.sql…")

        // 1. Load the entire SQL file as text
        val resource = ClassPathResource("sql/schema.sql")
        // 1) Load your schema.sql as before
        val ddl = ClassPathResource("sql/schema.sql")
            .inputStream
            .bufferedReader()
            .use { it.readText() }

// 2) Split respecting $$ blocks
        val statements = mutableListOf<String>()
        var buffer = StringBuilder()
        var inDollar = false

        ddl.lineSequence().forEach { line ->
            // Toggle whenever you see the $$ delimiter
            if (line.contains("$$")) inDollar = !inDollar

            buffer.append(line).append('\n')

            // If we're not inside $$ and this line ends with ';', that's a statement boundary
            if (!inDollar && line.trimEnd().endsWith(";")) {
                statements += buffer.toString().trim()
                buffer = StringBuilder()
            }
        }

// 3) statements now contains whole CREATE TABLE, whole FUNCTION, etc.
        runBlocking {
            statements.forEach { sql ->
                databaseClient
                    .sql(sql)
                    .fetch()
                    .awaitRowsUpdated()
            }
            finverseQueryService.fetchInstitutionData()
        }

        logger.info("R2DBC Bootstrap completed – schema applied.")
    }
}
