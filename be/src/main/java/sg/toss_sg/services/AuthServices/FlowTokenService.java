package sg.toss_sg.services.AuthServices;

import java.util.Optional;

import sg.toss_sg.models.auth.FlowUserDetails;

public interface FlowTokenService {

    Optional<FlowUserDetails> getUserDetailByAccessToken(String token);

    Optional<String> getAccessTokenByRefreshToken(String token);

    String generateAndStoreAccessToken(int userId);

}
