package sg.toss_sg.configs;

import java.sql.Connection;
import java.sql.SQLException;

import javax.sql.DataSource;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

@Configuration
public class DatabaseConnectionPool {

    private static DatabaseConnectionPool databaseConnectionPool = new DatabaseConnectionPool();
    private DataSource dataSource;

    private DatabaseConnectionPool() {
        HikariConfig config = new HikariConfig();

        // Database settings
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/zen_dev"); // Database URL
        config.setUsername("zen_developer"); // Database username
        config.setPassword("airbusa380861"); // Database password

        // HikariCP settings
        config.setMaximumPoolSize(100); // Maximum number of connections
        config.setMinimumIdle(2); // Minimum number of idle connections
        config.setIdleTimeout(30000); // Idle timeout in ms
        config.setMaxLifetime(1800000); // Max lifetime of a connection in ms
        config.setConnectionTimeout(20000); // Connection timeout in ms

        // Create the DataSource

        this.dataSource = new HikariDataSource(config);
        DatabaseConnectionPool.databaseConnectionPool = this;
    }

    public static DatabaseConnectionPool getInstance() {
        return databaseConnectionPool;
    }

    @Bean
    public static DatabaseConnectionPool databaseConnectionPool() {
        return databaseConnectionPool;
    }

    public Connection getConnection() {
        try {
            return this.dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }
}
