package sg.flow.services.UtilServices;

import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.util.Date;

import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;

import sg.flow.configs.JwtProperties;

@Service
public class JwtTokenProvider {

    private final RSAPublicKey publicKey;
    private final RSAPrivateKey privateKey;
    private final long accessTokenValidity;
    private final long refreshTokenValidity;

    private final Algorithm algorithm;

    public JwtTokenProvider(JwtProperties jwtProperties) {
        try {
            String publicKeyString = jwtProperties.getPublicKey();
            String privateKeyString = jwtProperties.getPrivateKey();

            System.out.println(publicKeyString);
            System.out.println(privateKeyString);
            this.publicKey = RSAKeyUtil.loadPublicKey(jwtProperties.getPublicKey());
            this.privateKey = RSAKeyUtil.loadPrivateKey(jwtProperties.getPrivateKey());
        } catch (Exception e) {
            throw new RuntimeException("Failed to load RSA keys", e);
        }
        this.accessTokenValidity = jwtProperties.getAccessTokenValidity();
        this.refreshTokenValidity = jwtProperties.getRefreshTokenValidity();

        this.algorithm = Algorithm.RSA512(publicKey, privateKey);
    }

    /**
     * Generate an Access Token containing user info.
     * Typically valid for a short period (e.g. 15 minutes).
     */
    public String generateAccessToken(String refreshToken) {
        long now = System.currentTimeMillis();
        long expiry = now + accessTokenValidity;

        return JWT.create()
                .withSubject(refreshToken)
                .withIssuedAt(new Date(now))
                .withExpiresAt(new Date(expiry))
                .sign(algorithm);
    }

    /**
     * Generate a Refresh Token with a longer validity period (e.g. 30 days).
     * Typically minimal claims or just user ID.
     */
    public String generateRefreshToken(Integer userId) {
        long now = System.currentTimeMillis();
        long expiry = now + refreshTokenValidity;

        return JWT.create()
                .withSubject(String.valueOf(userId))
                .withClaim("refresh", true)
                .withIssuedAt(new Date(now))
                .withExpiresAt(new Date(expiry))
                .sign(algorithm);
    }

    /**
     * Validate and parse token. Return claims if valid, throw exception if
     * invalid/expired.
     */
    public DecodedJWT verifyToken(String token) throws JWTVerificationException {
        JWTVerifier verifier = JWT.require(algorithm).build();
        return verifier.verify(token);
    }

    /**
     * A convenience method to extract user ID if you trust the token is already
     * validated.
     * Otherwise, parse & validate first.
     */
    public int getUserIdFromToken(String token) {
        DecodedJWT decoded = verifyToken(token);
        return Integer.parseInt(decoded.getSubject());
    }
}
