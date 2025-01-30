package sg.toss_sg.services.UtilServices;

import java.util.Optional;

public interface VaultService {

	Optional<Integer> getUserIdByAccessToken(String token);

	Optional<Integer> getUserIdByRefreshToken(String token);

	void storeAccessToken(int userId, String accessToken);

    void storeRefreshToken(Integer userId, String refreshToken);
    
}
