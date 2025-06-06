package sg.flow.repositories.user

import sg.flow.entities.User
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.Repository

interface UserRepository : Repository<User, Long> {
    suspend fun getUserProfile(id: Int): UserProfile
    suspend fun getUserPreferenceJson(userId: Int): String
    suspend fun updateUserProfile(userId: Int, userProfile: UpdateUserProfile): UserProfile
}
