package sg.flow.rest_controllers

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import java.security.KeyFactory
import java.security.PublicKey
import java.security.Signature
import java.security.spec.X509EncodedKeySpec
import java.util.Base64

@Component
class FinverseSignatureVerifier(
    @Value("\${finverse.webhook.publicKey}") private val publicKeyPem: String
) {

    private val verifier: Signature = Signature.getInstance("SHA256withECDSA").apply {
        initVerify(loadPublicKey(publicKeyPem))
    }

    /**
     * Verify the ECDSA signature of the payload.
     *
     * @param sigBase64   the Base64‐encoded ASN.1 (DER) ECDSA signature from the header
     * @param ts          the timestamp header value
     * @param body        the raw request body bytes
     */
    fun verify(sigBase64: String, ts: String, body: ByteArray) {
        // Construct the signed payload exactly as Finverse does: "<timestamp>.<rawBody>"
        val payload = "$ts.${String(body, Charsets.UTF_8)}".toByteArray(Charsets.UTF_8)
        val signatureBytes = Base64.getDecoder().decode(sigBase64)

        verifier.update(payload)
        if (!verifier.verify(signatureBytes)) {
            throw IllegalArgumentException("Finverse signature mismatch")
        }
    }

    /** Parse a PEM‐encoded ECDSA public key into a PublicKey instance */
    private fun loadPublicKey(pem: String): PublicKey {
        // Strip header/footer and whitespace
        val cleaned = pem
            .replace("-----BEGIN PUBLIC KEY-----", "")
            .replace("-----END PUBLIC KEY-----", "")
            .replace("\\s".toRegex(), "")
        val der = Base64.getDecoder().decode(cleaned)
        val spec = X509EncodedKeySpec(der)
        return KeyFactory.getInstance("EC").generatePublic(spec)
    }
}
