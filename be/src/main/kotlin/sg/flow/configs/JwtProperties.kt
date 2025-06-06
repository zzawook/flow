package sg.flow.configs

import java.io.BufferedReader
import java.io.FileInputStream
import java.io.InputStreamReader
import java.util.Properties
import java.util.stream.Collectors
import org.springframework.context.annotation.Configuration
import org.springframework.core.io.ClassPathResource
import org.springframework.core.io.Resource

@Configuration
open class JwtProperties {

    var publicKeyResource: Resource = ClassPathResource("cert/public.pem")
    var privateKeyResource: Resource = ClassPathResource("cert/private.pem")

    var publicKey: String = loadPublicKey()
        protected set

    var privateKey: String = loadPrivateKey()
        protected set

    var accessTokenValidity: Long = 3_600 // seconds
        protected set

    var refreshTokenValidity: Long = 15_552_000 // seconds (6 months)
        protected set

    init {
        try {
            FileInputStream("path/to/your/file.properties").use { input ->
                val prop = Properties().apply { load(input) }
                accessTokenValidity =
                        prop.getProperty("accessTokenValidity")?.toLong() ?: accessTokenValidity
                refreshTokenValidity =
                        prop.getProperty("refreshTokenValidity")?.toLong() ?: refreshTokenValidity
            }
        } catch (_: Exception) {
            // ignore and use defaults
        }
    }

    private fun loadPublicKey(): String =
            try {
                BufferedReader(InputStreamReader(publicKeyResource.inputStream)).use { reader ->
                    reader.lines().collect(Collectors.joining("\n"))
                }
            } catch (e: Exception) {
                e.printStackTrace()
                "publicKey"
            }

    private fun loadPrivateKey(): String =
            try {
                BufferedReader(InputStreamReader(privateKeyResource.inputStream)).use { reader ->
                    reader.lines().collect(Collectors.joining("\n"))
                }
            } catch (e: Exception) {
                e.printStackTrace()
                "privateKey"
            }
}
