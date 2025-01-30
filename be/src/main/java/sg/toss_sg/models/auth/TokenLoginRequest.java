package sg.toss_sg.models.auth;

import lombok.Data;

@Data
public class TokenLoginRequest {
    private String tokenType;
    private String tokenValue;

}