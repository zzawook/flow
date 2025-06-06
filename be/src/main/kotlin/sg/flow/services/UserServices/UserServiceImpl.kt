package sg.flow.services.UserServices

import org.springframework.stereotype.Service
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.user.UserRepository

@Service
class UserServiceImpl(
        private val userRepository: UserRepository,
) : UserService {

    override suspend fun getUserProfile(userId: Int): UserProfile =
            userRepository.getUserProfile(userId)

    override suspend fun getUserPreferenceJson(userId: Int): String =
            userRepository.getUserPreferenceJson(userId)

    override suspend fun updateUserProfile(
            userId: Int,
            userProfile: UpdateUserProfile
    ): UserProfile = userRepository.updateUserProfile(userId, userProfile)
}
