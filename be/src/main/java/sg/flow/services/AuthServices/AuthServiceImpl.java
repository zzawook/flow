package sg.flow.services.AuthServices;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import sg.flow.models.auth.AccessTokenRefreshRequest;
import sg.flow.models.auth.AuthRequest;
import sg.flow.models.auth.TokenSet;
import sg.flow.services.UtilServices.CacheService;
import sg.flow.services.UtilServices.VaultService;

@Service
public class AuthServiceImpl implements AuthService {

    @Autowired
    CacheService cacheService;

    @Autowired
    VaultService vaultService;

    @Autowired
    FlowTokenService tokenService;

    @Override
    public TokenSet authenticateUser(AuthRequest request) { // INCOMPLETE: Possible Singpass Authentication Logic in
                                                            // here
        TokenSet tokenSet = new TokenSet("accessToken", "refreshToken");
        cacheService.storeAccessToken(1, tokenSet.getAccessToken());
        vaultService.storeAccessToken(1, tokenSet.getAccessToken());
        vaultService.storeRefreshToken(1, tokenSet.getRefreshToken());
        return tokenSet;
    }

    @Override
    public TokenSet getAccessTokenByRefreshToken(AccessTokenRefreshRequest request) {
        String refreshToken = request.getRefreshToken();
        Optional<TokenSet> maybeTokenSet = tokenService.getAccessTokenByRefreshToken(refreshToken);
        if (!maybeTokenSet.isPresent()) {
            return null;
        }
        return maybeTokenSet.get();
    }

}
