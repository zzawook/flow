package sg.toss_sg.services;

import sg.toss_sg.models.user.UpdateUserProfile;

public interface UserService {

    String getUserProfile();

    String getUserSettingJson();

    String updateUserProfile(UpdateUserProfile userProfile);
    
}
