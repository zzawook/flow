package sg.flow.services.AuthServices;

import org.springframework.stereotype.Service;

import sg.flow.models.auth.SignInRequest;
import sg.flow.models.auth.TokenSet;

@Service
public class AuthServiceImpl implements AuthService {

    @Override
    public TokenSet authenticateUser(SignInRequest request) {
        return new TokenSet("accessToken", "refreshToken");
    }

}
