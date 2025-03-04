package sg.flow.services.AuthServices;

import java.util.List;
import java.util.Optional;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.flow.models.auth.FlowUserDetails;
import sg.flow.models.auth.TokenSet;
import sg.flow.models.user.UserProfile;
import sg.flow.services.UserServices.UserService;
import sg.flow.services.UtilServices.CacheService;
import sg.flow.services.UtilServices.JwtTokenProvider;
import sg.flow.services.UtilServices.VaultService;

@RequiredArgsConstructor
@Service
public class FlowTokenServiceImpl implements FlowTokenService {

    private final CacheService cacheService;
    private final VaultService VaultService;
    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;

    @Override
    public Optional<FlowUserDetails> getUserDetailByAccessToken(String accessToken) {
        Optional<Integer> maybeUserId = cacheService.getUserIdByAccessToken(accessToken);
        if (!maybeUserId.isPresent()) {
            maybeUserId = VaultService.getUserIdByAccessToken(accessToken);
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
    public Optional<TokenSet> getAccessTokenByRefreshToken(String refreshToken) {
        Optional<Integer> maybeUserId = VaultService.getUserIdByRefreshToken(refreshToken);
        if (!maybeUserId.isPresent()) {
            return Optional.empty();
        }
        Integer userId = maybeUserId.get();
        Optional<TokenSet> maybeTokenSet = this.generateAndStoreRefreshToken(userId);
        if (!maybeTokenSet.isPresent()) {
            return Optional.empty();
        }
        return maybeTokenSet;
    }

    @Override
    public Optional<TokenSet> generateAndStoreAccessToken(String refreshToken) {
        Optional<Integer> maybeUserId = VaultService.getUserIdByRefreshToken(refreshToken);
        if (!maybeUserId.isPresent()) {
            return null;
        }
        Integer userId = maybeUserId.get();
        Optional<TokenSet> maybeTokenSet = this.generateAndStoreRefreshToken(userId);
        if (!maybeTokenSet.isPresent()) {
            return null;
        }
        return maybeTokenSet;
    }

    @Override
    public Optional<TokenSet> generateAndStoreRefreshToken(Integer userId) {
        String refreshToken = jwtTokenProvider.generateRefreshToken(userId);
        String accessToken = jwtTokenProvider.generateAccessToken(refreshToken);

        cacheService.storeAccessToken(userId, accessToken);
        VaultService.storeAccessToken(userId, accessToken);
        VaultService.storeRefreshToken(userId, refreshToken);

        return Optional.of(TokenSet.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .build());
    }

}
