package sg.toss_sg.services.UserServices;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.user.UpdateUserProfile;
import sg.toss_sg.models.user.UserProfile;
import sg.toss_sg.repositories.user.UserRepository;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;

    @Override
    public UserProfile getUserProfile(Integer userId) {
        UserProfile userProfile = userRepository.getUserProfile(userId);
        return userProfile;
    }

    @Override
    public String getUserPreferenceJson(Integer userId) {
        String userPreferenceJson = userRepository.getUserPreferenceJson(userId);
        return userPreferenceJson;
    }

    @Override
    public UserProfile updateUserProfile(Integer userId, UpdateUserProfile userProfile) {
        UserProfile updatedUserProfile = userRepository.updateUserProfile(userId, userProfile);
        return updatedUserProfile;
    }
    
}
