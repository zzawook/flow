package sg.flow.configs;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

import lombok.Data;

@Configuration
@Data
@ConfigurationProperties(prefix = "jwt")
public class JwtProperties {
    private String publicKey;
    private String privateKey;
    private long accessTokenValidity; // 3600 seconds = 1 hour
    private long refreshTokenValidity; // 15552000 seconds = 6 months

    public JwtProperties() {
        try (InputStream input = new FileInputStream("path/to/your/file.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            this.publicKey = prop.getProperty("publicKey");
            this.privateKey = prop.getProperty("privateKey");
            this.accessTokenValidity = Long.parseLong(prop.getProperty("accessTokenValidity"));
            this.refreshTokenValidity = Long.parseLong(prop.getProperty("refreshTokenValidity"));
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
}