package sg.toss_sg.services.UserServices;

import sg.toss_sg.models.user.UpdateUserProfile;

public interface UserService {

    String getUserProfile();

    String getUserPreferenceJson();

    String updateUserProfile(UpdateUserProfile userProfile);
    
}
