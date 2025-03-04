package sg.flow.services.UtilServices;

import java.util.Optional;

import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Service;

@Service
@Profile("prod")
public class CacheServiceImpl implements CacheService {

    @Override
    public Optional<Integer> getUserIdByAccessToken(String token) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getUserIdByAccessToken'");
    }

    @Override
    public void storeAccessToken(int userId, String accessToken) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'storeAccessToken'");
    }

}
