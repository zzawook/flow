package sg.flow.services.UtilServices;

import java.util.Optional;

public interface CacheService {

    Optional<Integer> getUserIdByAccessToken(String token);

    void storeAccessToken(int userId, String accessToken);

}
