package sg.flow.models.auth;

import lombok.Data;

@Data
public class AccessTokenRefreshRequest {
    
    private String refreshToken;

    public String getRefreshToken() {
        return refreshToken;
    }

    public void setRefreshToken(String refreshToken) {
        this.refreshToken = refreshToken;
    }
}
