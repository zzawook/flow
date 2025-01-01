package sg.toss_sg.bootstrap;

import java.sql.Connection;

import org.springframework.boot.CommandLineRunner;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.init.ScriptUtils;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.configs.DatabaseConnectionPool;

@RequiredArgsConstructor
@Component
@Order(1)
public class Bootstrap implements CommandLineRunner {

    private final DatabaseConnectionPool databaseConnectionPool;

    @Override
    public void run(String... args) throws Exception {
        this.createTableIfNotExists();
    }

    private void createTableIfNotExists() {
        ClassPathResource resource = new ClassPathResource("sql/schema.sql");

        try (Connection connection = databaseConnectionPool.getConnection()) {
            ScriptUtils.executeSqlScript(connection, resource);
            System.out.println("SQL file executed successfully.");
        } catch (Exception e) {
            System.err.println("Failed to execute SQL file: " + e.getMessage());
        }
    }

}
