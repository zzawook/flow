package sg.flow.services.UtilServices

import com.auth0.jwt.JWT
import com.auth0.jwt.JWTVerifier
import com.auth0.jwt.algorithms.Algorithm
import com.auth0.jwt.exceptions.JWTVerificationException
import com.auth0.jwt.interfaces.DecodedJWT
import java.security.interfaces.RSAPrivateKey
import java.security.interfaces.RSAPublicKey
import java.util.Date
import org.springframework.stereotype.Service
import sg.flow.configs.JwtProperties

@Service
open class JwtTokenProvider(jwtProperties: JwtProperties) {

    private val publicKey: RSAPublicKey
    private val privateKey: RSAPrivateKey
    private val accessTokenValidity: Long
    private val refreshTokenValidity: Long

    private val algorithm: Algorithm

    init {
        try {
            publicKey = RSAKeyUtil.loadPublicKey(jwtProperties.publicKey)
            privateKey = RSAKeyUtil.loadPrivateKey(jwtProperties.privateKey)
        } catch (e: Exception) {
            throw RuntimeException("Failed to load RSA keys", e)
        }
        accessTokenValidity = jwtProperties.accessTokenValidity
        refreshTokenValidity = jwtProperties.refreshTokenValidity
        algorithm = Algorithm.RSA512(publicKey, privateKey)
    }

    /**
     * Generate an Access Token containing user info. Typically valid for a short period (e.g. 15
     * minutes).
     */
    fun generateAccessToken(refreshToken: String): String {
        val now = System.currentTimeMillis()
        val expiry = now + accessTokenValidity * 1000
        return JWT.create()
                .withSubject(refreshToken)
                .withIssuedAt(Date(now))
                .withExpiresAt(Date(expiry))
                .sign(algorithm)
    }

    /** Generate a Refresh Token with a longer validity period (e.g. 30 days). */
    fun generateRefreshToken(userId: Int): String {
        val now = System.currentTimeMillis()
        val expiry = now + refreshTokenValidity * 1000
        return JWT.create()
                .withSubject(userId.toString())
                .withClaim("refresh", true)
                .withIssuedAt(Date(now))
                .withExpiresAt(Date(expiry))
                .sign(algorithm)
    }

    /** Validate and parse token. Return claims if valid. */
    @Throws(JWTVerificationException::class)
    fun verifyToken(token: String): DecodedJWT {
        val verifier: JWTVerifier = JWT.require(algorithm).build()
        return verifier.verify(token)
    }

    /** Convenience method to extract user ID from a validated token. */
    fun getUserIdFromToken(token: String): Int {
        val decoded = verifyToken(token)
        return decoded.subject.toInt()
    }
}
