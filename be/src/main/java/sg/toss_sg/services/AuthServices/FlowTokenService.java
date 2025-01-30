package sg.toss_sg.services.AuthServices;

import java.util.Optional;

import sg.toss_sg.models.auth.FlowUserDetails;
import sg.toss_sg.models.auth.TokenSet;

public interface FlowTokenService {

    Optional<FlowUserDetails> getUserDetailByAccessToken(String token);

    Optional<TokenSet> getAccessTokenByRefreshToken(String token);

    String generateAndStoreAccessToken(Integer userId);

    String generateAndStoreRefreshToken(Integer userId);

}
