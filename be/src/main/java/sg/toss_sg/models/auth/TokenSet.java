package sg.toss_sg.models.auth;

import lombok.Data;

@Data
public class TokenSet {

    private String accessToken;
    private String refreshToken;

    public TokenSet(String accessToken, String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }
}
