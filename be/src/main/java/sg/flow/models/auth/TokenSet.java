package sg.flow.models.auth;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class TokenSet {

    private String accessToken;
    private String refreshToken;

    public TokenSet(String accessToken, String refreshToken) {
        this.accessToken = accessToken;
        this.refreshToken = refreshToken;
    }
}
