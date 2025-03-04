package sg.flow.services.AuthServices;

import sg.flow.models.auth.SignInRequest;
import sg.flow.models.auth.TokenSet;

public interface AuthService {

    TokenSet authenticateUser(SignInRequest request);
    
}
