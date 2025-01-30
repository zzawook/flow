package sg.flow.services.AuthServices;

import java.util.Optional;

import sg.flow.models.auth.FlowUserDetails;
import sg.flow.models.auth.TokenSet;

public interface FlowTokenService {

    Optional<FlowUserDetails> getUserDetailByAccessToken(String token);

    Optional<TokenSet> getAccessTokenByRefreshToken(String token);

    String generateAndStoreAccessToken(Integer userId);

    String generateAndStoreRefreshToken(Integer userId);

}
