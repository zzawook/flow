package sg.flow.services.AuthServices;

import sg.flow.models.auth.AccessTokenRefreshRequest;
import sg.flow.models.auth.AuthRequest;
import sg.flow.models.auth.TokenSet;

public interface AuthService {

    TokenSet authenticateUser(AuthRequest request);

    TokenSet getAccessTokenByRefreshToken(AccessTokenRefreshRequest request);
    
}
