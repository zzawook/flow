package sg.toss_sg.services.UtilServices;

import java.util.Optional;

public interface CacheService {

    Optional<Integer> getUserIdByAccessToken(String token);
    
}
