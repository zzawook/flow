package sg.toss_sg.services.UserServices;

import sg.toss_sg.models.user.UpdateUserProfile;
import sg.toss_sg.models.user.UserProfile;

public interface UserService {

    UserProfile getUserProfile(Integer userId);

    String getUserPreferenceJson(Integer userId);

    UserProfile updateUserProfile(Integer userId, UpdateUserProfile userProfile);
}
