package sg.flow.services.UtilServices;

import java.util.HashMap;
import java.util.Optional;

import org.springframework.stereotype.Service;

@Service
public class MockVaultServiceImpl implements VaultService {

    private HashMap<String, Object> vaultMap = new HashMap<>();

    @Override
    public Optional<Integer> getUserIdByAccessToken(String token) {
        if (!vaultMap.containsKey("access_tokens")) {
            return Optional.empty();
        }
        @SuppressWarnings("unchecked")
        HashMap<String, Integer> tokenMap = (HashMap<String, Integer>) vaultMap.get("access_tokens");
        return Optional.ofNullable((Integer) tokenMap.get(token));
    }

    @Override
    public Optional<Integer> getUserIdByRefreshToken(String token) {
        if (!vaultMap.containsKey("refresh_tokens")) {
            return Optional.empty();
        }
        @SuppressWarnings("unchecked")
        HashMap<String, Integer> tokenMap = (HashMap<String, Integer>) vaultMap.get("refresh_tokens");
        return Optional.ofNullable((Integer) tokenMap.get(token));
    }

    @Override
    public void storeAccessToken(int userId, String accessToken) {
        @SuppressWarnings("unchecked")
        HashMap<String, Integer> tokenMap = (HashMap<String, Integer>) vaultMap.getOrDefault("access_tokens",
                new HashMap<String, Integer>());
        tokenMap.put(accessToken, userId);
        vaultMap.put("access_tokens", tokenMap);
    }

    @Override
    public void storeRefreshToken(Integer userId, String refreshToken) {
        @SuppressWarnings("unchecked")
        HashMap<String, Integer> tokenMap = (HashMap<String, Integer>) vaultMap.getOrDefault("refresh_tokens",
                new HashMap<String, Integer>());
        tokenMap.put(refreshToken, userId);
        vaultMap.put("refresh_tokens", tokenMap);
    }

}
