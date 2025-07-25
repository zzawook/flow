package sg.flow.rest_controllers

import org.springframework.beans.factory.annotation.Value
import org.springframework.stereotype.Component
import java.math.BigInteger
import java.security.KeyFactory
import java.security.MessageDigest
import java.security.PublicKey
import java.security.Signature
import java.security.interfaces.ECPublicKey
import java.security.spec.X509EncodedKeySpec
import java.util.Base64

@Component
class FinverseSignatureVerifier(
    @Value("\${finverse.webhook.publicKey}") private val publicKeyPem: String
) {
    
    private val publicKey: ECPublicKey by lazy {
        loadPublicKey(publicKeyPem)
    }
    
    /**
     * Verify the ECDSA signature of the payload.
     *
     * @param sigBase64   the Base64-encoded ASN.1 (DER) ECDSA signature
     * @param body        the raw request body bytes
     */
    suspend fun verify(sigBase64: String, body: ByteArray) {
        try {
            // Decode the base64 signature
            val signatureBytes = Base64.getDecoder().decode(sigBase64)
            
            // Parse the ASN.1 DER encoded signature to extract R and S values
            val (r, s) = parseECDSASignature(signatureBytes)
            
            // Note: SHA-256 hashing is handled internally by SHA256withECDSA signature algorithm
            
            // Verify the signature using ECDSA
            val signature = Signature.getInstance("SHA256withECDSA")
            signature.initVerify(publicKey)
            signature.update(body)
            
            // For ECDSA, we need to reconstruct the signature in the correct format
            val derSignature = createDERSignature(r, s)
            
            if (!signature.verify(derSignature)) {
                throw IllegalArgumentException("Finverse signature verification failed")
            }
        } catch (e: Exception) {
            throw IllegalArgumentException("Finverse signature verification failed: ${e.message}", e)
        }
    }
    
    /**
     * Parse a PEM-encoded ECDSA public key into an ECPublicKey instance
     */
    internal fun loadPublicKey(pem: String): ECPublicKey {
        try {
            // Clean up the PEM format - remove headers/footers and unescape newlines
            val cleaned = pem
                .replace("-----BEGIN PUBLIC KEY-----", "")
                .replace("-----END PUBLIC KEY-----", "")
                .replace("\\n", "\n")
                .replace("\\s".toRegex(), "")
            
            // Decode the base64 content
            val der = Base64.getDecoder().decode(cleaned)
            val spec = X509EncodedKeySpec(der)
            val keyFactory = KeyFactory.getInstance("EC")
            val publicKey = keyFactory.generatePublic(spec)
            
            return publicKey as ECPublicKey
        } catch (e: Exception) {
            throw IllegalStateException("Failed to load Finverse public key: ${e.message}", e)
        }
    }
    
    /**
     * Parse ASN.1 DER encoded ECDSA signature to extract R and S values
     */
    private fun parseECDSASignature(signatureBytes: ByteArray): Pair<BigInteger, BigInteger> {
        try {
            // Simple ASN.1 DER parser for ECDSA signature
            // ECDSA signature format: SEQUENCE { r INTEGER, s INTEGER }
            var offset = 0
            
            // Check SEQUENCE tag (0x30)
            if (signatureBytes[offset++] != 0x30.toByte()) {
                throw IllegalArgumentException("Invalid ASN.1 sequence tag")
            }
            
            // Skip sequence length
            offset++ // Skip sequence length byte
            
            // Parse R value
            if (signatureBytes[offset++] != 0x02.toByte()) {
                throw IllegalArgumentException("Invalid ASN.1 integer tag for R")
            }
            val rLength = signatureBytes[offset++].toInt() and 0xFF
            val rBytes = signatureBytes.sliceArray(offset until offset + rLength)
            val r = BigInteger(1, rBytes)
            offset += rLength
            
            // Parse S value
            if (signatureBytes[offset++] != 0x02.toByte()) {
                throw IllegalArgumentException("Invalid ASN.1 integer tag for S")
            }
            val sLength = signatureBytes[offset++].toInt() and 0xFF
            val sBytes = signatureBytes.sliceArray(offset until offset + sLength)
            val s = BigInteger(1, sBytes)
            
            return Pair(r, s)
        } catch (e: Exception) {
            throw IllegalArgumentException("Failed to parse ECDSA signature: ${e.message}", e)
        }
    }
    
    /**
     * Create DER-encoded signature from R and S values
     */
    private fun createDERSignature(r: BigInteger, s: BigInteger): ByteArray {
        try {
            val rBytes = r.toByteArray()
            val sBytes = s.toByteArray()
            
            val rLength = rBytes.size
            val sLength = sBytes.size
            val totalLength = 2 + 2 + rLength + 2 + sLength
            
            val result = ByteArray(2 + totalLength)
            var offset = 0
            
            // SEQUENCE tag and length
            result[offset++] = 0x30.toByte()
            result[offset++] = (totalLength - 2).toByte()
            
            // R INTEGER
            result[offset++] = 0x02.toByte()
            result[offset++] = rLength.toByte()
            System.arraycopy(rBytes, 0, result, offset, rLength)
            offset += rLength
            
            // S INTEGER  
            result[offset++] = 0x02.toByte()
            result[offset++] = sLength.toByte()
            System.arraycopy(sBytes, 0, result, offset, sLength)
            
            return result
        } catch (e: Exception) {
            throw IllegalArgumentException("Failed to create DER signature: ${e.message}", e)
        }
    }
}
