package sg.flow.models.auth;

import lombok.Data;

@Data
public class TokenLoginRequest {
    private String tokenType;
    private String tokenValue;

}