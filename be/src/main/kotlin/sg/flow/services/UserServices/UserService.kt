package sg.flow.services.UserServices

import sg.flow.entities.User
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import java.time.LocalDate
import java.util.Date

interface UserService {
    suspend fun getUserProfile(userId: Int): UserProfile
    suspend fun getUserPreferenceJson(userId: Int): String
    suspend fun updateUserProfile(userId: Int, userProfile: UpdateUserProfile): UserProfile
    suspend fun saveUser(name: String, email: String, passwordEncoded: String, dateOfBirth: LocalDate): User?
    suspend fun markUserEmailVerified(email: String)
    suspend fun isUserVerified(email: String): Boolean
}
