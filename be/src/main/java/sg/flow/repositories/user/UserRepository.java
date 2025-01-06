package sg.flow.repositories.user;

import sg.flow.entities.User;
import sg.flow.models.user.UpdateUserProfile;
import sg.flow.models.user.UserProfile;
import sg.flow.repositories.Repository;

public interface UserRepository extends Repository<User, Long> {

    public UserProfile getUserProfile(Integer id);

    public String getUserPreferenceJson(Integer userId);

    public UserProfile updateUserProfile(Integer userId, UpdateUserProfile userProfile);
}
