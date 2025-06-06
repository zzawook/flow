package sg.flow.services.UtilServices

import java.security.KeyFactory
import java.security.interfaces.RSAPrivateKey
import java.security.interfaces.RSAPublicKey
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import java.util.Base64

object RSAKeyUtil {
    /** Load and convert RSA Public Key from PEM file to RSAPublicKey */
    @JvmStatic
    @Throws(Exception::class)
    fun loadPublicKey(publicKeyString: String): RSAPublicKey {
        val keyPEM =
                publicKeyString
                        .replace("-----BEGIN PUBLIC KEY-----", "")
                        .replace("-----END PUBLIC KEY-----", "")
                        .replace("\\s".toRegex(), "") // Remove any whitespace or new lines

        val decodedKey = Base64.getDecoder().decode(keyPEM)
        val keySpec = X509EncodedKeySpec(decodedKey)
        val keyFactory = KeyFactory.getInstance("RSA")
        return keyFactory.generatePublic(keySpec) as RSAPublicKey
    }

    /** Load and convert RSA Private Key from PEM file to RSAPrivateKey */
    @JvmStatic
    @Throws(Exception::class)
    fun loadPrivateKey(privateKeyString: String): RSAPrivateKey {
        val keyPEM =
                privateKeyString
                        .replace("-----BEGIN PRIVATE KEY-----", "")
                        .replace("-----END PRIVATE KEY-----", "")
                        .replace("\\s".toRegex(), "")

        val decodedKey = Base64.getDecoder().decode(keyPEM)
        val keySpec = PKCS8EncodedKeySpec(decodedKey)
        val keyFactory = KeyFactory.getInstance("RSA")
        return keyFactory.generatePrivate(keySpec) as RSAPrivateKey
    }
}
