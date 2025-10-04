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
import sg.flow.configs.MagicLinkProps
import java.time.Instant

@Service
open class JwtTokenProvider(
    jwtProperties: JwtProperties,
    private val linkProps: MagicLinkProps,
) {

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

    fun generateEmailVerificationToken(email: String, sessionId: String, jti: String): String {
        // 2) Sign token (JWT)
        val now = Instant.now()
        val token = JWT.create()
            .withIssuer(linkProps.issuer)
            .withSubject("verify-email")
            .withAudience("flow-users")
            .withClaim("sid", sessionId)
            .withClaim("email", email)
            .withJWTId(jti)
            .withIssuedAt(Date.from(now))
            .withExpiresAt(Date.from(now.plusSeconds(linkProps.ttlMinutes * 60)))
            .sign(algorithm)

        return token
    }

    fun validateEmailVerificationToken(token: String): Map<String, String> {
        val verifier = JWT.require(algorithm)
            .withIssuer(linkProps.issuer)
            .withSubject("verify-email")
            .build()
        val jwt: DecodedJWT = verifier.verify(token)

        val sid = jwt.getClaim("sid").asString()
        val email = jwt.getClaim("email").asString()
        val jti  = jwt.id

        val ans = HashMap<String, String>()
        ans.put("sid", sid)
        ans.put("email", email)
        ans.put("jti", jti)

        return ans
    }
}
