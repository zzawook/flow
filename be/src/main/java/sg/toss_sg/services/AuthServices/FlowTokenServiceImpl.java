package sg.toss_sg.services.AuthServices;

import java.util.List;
import java.util.Optional;

import org.springframework.security.core.authority.SimpleGrantedAuthority;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.auth.FlowUserDetails;
import sg.toss_sg.models.auth.TokenSet;
import sg.toss_sg.models.user.UserProfile;
import sg.toss_sg.services.UserServices.UserService;
import sg.toss_sg.services.UtilServices.CacheService;
import sg.toss_sg.services.UtilServices.JwtTokenProvider;
import sg.toss_sg.services.UtilServices.VaultService;

@RequiredArgsConstructor
public class FlowTokenServiceImpl implements FlowTokenService {

    private final CacheService cacheService;
    private final VaultService VaultService;
    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

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
    public Optional<TokenSet> getAccessTokenByRefreshToken(String token) {
        Optional<Integer> maybeUserId = VaultService.getUserIdByRefreshToken(token);
        if (!maybeUserId.isPresent()) {
            return Optional.empty();
        }
        Integer userId = maybeUserId.get();
        String newAccessToken = this.generateAndStoreAccessToken(userId);
        String newRefreshToken = this.generateAndStoreRefreshToken(userId);
        return Optional.of(new TokenSet(newAccessToken, newRefreshToken));
    }

    @Override
    public String generateAndStoreAccessToken(Integer userId) {
        String accessToken = jwtTokenProvider.generateAccessToken(userId);
        VaultService.storeAccessToken(userId, accessToken);
        cacheService.storeAccessToken(userId, accessToken);
        return accessToken;
    }

    @Override
    public String generateAndStoreRefreshToken(Integer userId) {
        String refreshToken = jwtTokenProvider.generateRefreshToken(userId);
        VaultService.storeRefreshToken(userId, refreshToken);
        return refreshToken;
    }

}
