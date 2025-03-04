package sg.flow.configs;

import java.beans.JavaBean;
import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Properties;
import java.util.stream.Collectors;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;

import lombok.Data;

@Configuration
@Data
@JavaBean
public class JwtProperties {
    private Resource publicKeyResource;
    private Resource privateKeyResource;

    private String publicKey = "publicKey";
    private String privateKey = "privateKey";
    private long accessTokenValidity = 3600; // 3600 seconds = 1 hour
    private long refreshTokenValidity = 15552000; // 15552000 seconds = 6 months

    public JwtProperties() {
        publicKeyResource = new ClassPathResource("cert/public.pem");
        privateKeyResource = new ClassPathResource("cert/private.pem");

        this.publicKey = this.loadPublicKey();
        this.privateKey = this.loadPrivateKey();

        try (InputStream input = new FileInputStream("path/to/your/file.properties")) {
            Properties prop = new Properties();
            prop.load(input);
            this.accessTokenValidity = prop.getProperty("accessTokenValidity") != null
                    ? Long.parseLong(prop.getProperty("accessTokenValidity"))
                    : this.accessTokenValidity;
            this.refreshTokenValidity = prop.getProperty("refreshTokenValidity") != null
                    ? Long.parseLong(prop.getProperty("refreshTokenValidity"))
                    : this.refreshTokenValidity;
        } catch (IOException ex) {
            
        }
    }

    private String loadPublicKey() {
        InputStreamReader inputStream = null;
        try {
            inputStream = new InputStreamReader(publicKeyResource.getInputStream());
        }
        catch (Exception e) {
            e.printStackTrace();
            return this.publicKey;
        }
        
        try (BufferedReader reader = new BufferedReader(inputStream)) {
            return reader.lines().collect(Collectors.joining("\n"));
        } catch (Exception e) {
            e.printStackTrace();
            return this.publicKey;
        }
    }

    private String loadPrivateKey() {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(privateKeyResource.getInputStream()))) {
            return reader.lines().collect(Collectors.joining("\n"));
        } catch (Exception e) {
            e.printStackTrace();
            return this.privateKey;
        }
    }
}