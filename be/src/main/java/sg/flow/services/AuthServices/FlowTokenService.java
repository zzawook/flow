package sg.flow.services.AuthServices;

import java.util.Optional;

import sg.flow.models.auth.FlowUserDetails;
import sg.flow.models.auth.TokenSet;

public interface FlowTokenService {

    Optional<FlowUserDetails> getUserDetailByAccessToken(String accessToken);

    Optional<TokenSet> getAccessTokenByRefreshToken(String refreshToken);

    Optional<TokenSet> generateAndStoreAccessToken(String refreshToken);

    Optional<TokenSet> generateAndStoreRefreshToken(Integer userId);

}
