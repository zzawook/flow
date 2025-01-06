package sg.flow.services.UserServices;

import sg.flow.models.user.UpdateUserProfile;
import sg.flow.models.user.UserProfile;

public interface UserService {

    UserProfile getUserProfile(Integer userId);

    String getUserPreferenceJson(Integer userId);

    UserProfile updateUserProfile(Integer userId, UpdateUserProfile userProfile);
}
