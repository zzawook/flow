package sg.flow.services.UserServices

import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile

interface UserService {
    suspend fun getUserProfile(userId: Int): UserProfile
    suspend fun getUserPreferenceJson(userId: Int): String
    suspend fun updateUserProfile(userId: Int, userProfile: UpdateUserProfile): UserProfile
}
