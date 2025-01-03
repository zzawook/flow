package sg.toss_sg.repositories.user;

import sg.toss_sg.entities.User;
import sg.toss_sg.models.user.UpdateUserProfile;
import sg.toss_sg.models.user.UserProfile;
import sg.toss_sg.repositories.Repository;

public interface UserRepository extends Repository<User, Long> {

    public UserProfile getUserProfile(Integer id);

    public String getUserPreferenceJson(Integer userId);

    public UserProfile updateUserProfile(Integer userId, UpdateUserProfile userProfile);
}
