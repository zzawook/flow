package sg.flow.services.UtilServices;

import java.util.HashMap;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class MockCacheServiceImpl implements CacheService {

    private HashMap<String, Integer> tokenToUserId = new HashMap<>();

    @Override
    public Optional<Integer> getUserIdByAccessToken(String token) {
        return Optional.ofNullable(tokenToUserId.get(token));
    }

    @Override
    public void storeAccessToken(int userId, String accessToken) {
        tokenToUserId.put(accessToken, userId);
    }

}
