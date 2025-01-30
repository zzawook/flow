package sg.toss_sg.services.UtilServices;

import java.security.KeyFactory;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class RSAKeyUtil {
    /**
     * Load and convert RSA Public Key from PEM file to RSAPublicKey
     */
    public static RSAPublicKey loadPublicKey(String publicKeyString) throws Exception {
        String keyPEM = publicKeyString.replace("-----BEGIN PUBLIC KEY-----", "")
                       .replace("-----END PUBLIC KEY-----", "")
                       .replaceAll("\\s", ""); // Remove any whitespace or new lines

        byte[] decodedKey = Base64.getDecoder().decode(keyPEM);
        X509EncodedKeySpec keySpec = new X509EncodedKeySpec(decodedKey);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");

        return (RSAPublicKey) keyFactory.generatePublic(keySpec);
    }

    /**
     * Load and convert RSA Private Key from PEM file to RSAPrivateKey
     */
    public static RSAPrivateKey loadPrivateKey(String privateKeyString) throws Exception {
        String keyPEM = privateKeyString.replace("-----BEGIN PRIVATE KEY-----", "")
                       .replace("-----END PRIVATE KEY-----", "")
                       .replaceAll("\\s", ""); // Remove any whitespace or new lines

        byte[] decodedKey = Base64.getDecoder().decode(keyPEM);
        PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(decodedKey);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");

        return (RSAPrivateKey) keyFactory.generatePrivate(keySpec);
    }
}
