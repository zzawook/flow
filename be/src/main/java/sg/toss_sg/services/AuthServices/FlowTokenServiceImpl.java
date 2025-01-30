package sg.toss_sg.services.AuthServices;

import java.util.List;
import java.util.Optional;

import org.springframework.security.core.authority.SimpleGrantedAuthority;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.auth.FlowUserDetails;
import sg.toss_sg.models.user.UserProfile;
import sg.toss_sg.services.UserServices.UserService;
import sg.toss_sg.services.UtilServices.CacheService;
import sg.toss_sg.services.UtilServices.VaultService;

@RequiredArgsConstructor
public class FlowTokenServiceImpl implements FlowTokenService {

    private final CacheService cacheService;
    private final VaultService VaultService;
    private final UserService userService;

    @Override
    public Optional<FlowUserDetails> getUserDetailByAccessToken(String token) {
        Optional<Integer> maybeUserId = cacheService.getUserIdByAccessToken(token);
        if (!maybeUserId.isPresent()) {
            maybeUserId = VaultService.getUserIdByAccessToken(token);
            if (!maybeUserId.isPresent()) {
                return Optional.empty();
            }
        }

        Integer userId = maybeUserId.get();
        UserProfile userProfile = userService.getUserProfile(userId);
        return Optional.of(FlowUserDetails.builder()
                .userId(userId)
                .name(userProfile.getName())
                .authorities(List.of(new SimpleGrantedAuthority("ROLE_USER")))
                .build());
    }

    @Override
    public Optional<String> getAccessTokenByRefreshToken(String token) {
        Optional<Integer> maybeUserId = VaultService.getUserIdByRefreshToken(token);
        if (!maybeUserId.isPresent()) {
            return Optional.empty();
        }
        Integer userId = maybeUserId.get();
        String newAccessToken = this.generateAndStoreAccessToken(userId);
        return Optional.of(newAccessToken);
    }

    @Override
    public String generateAndStoreAccessToken(int userId) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'generateAccessToken'");
    }

}
