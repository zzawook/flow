package sg.flow.repositories.user

import sg.flow.entities.User
import sg.flow.grpc.UserIdAndPasswordHash
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.Repository
import java.time.LocalDate

interface UserRepository : Repository<User, Long> {
    fun getAllUserIds(): List<Int>

    suspend fun getUserProfile(id: Int): UserProfile
    suspend fun getUserPreferenceJson(userId: Int): String
    suspend fun updateUserProfile(userId: Int, userProfile: UpdateUserProfile): UserProfile
    suspend fun checkUserExists(email: String): Boolean
    suspend fun getUserIdByEmail(email: String): Int
    suspend fun getUserIdAndPasswordHashWithEmail(email: String): UserIdAndPasswordHash
    suspend fun markUserEmailVerified(email: String): Boolean
    suspend fun fetchIsUserEmailVerified(email: String): Boolean
    suspend fun canLinkBank(userId: Int): Boolean
    suspend fun setConstantUserFields(userId: Int, dateOfBirth: LocalDate, genderIsMale: Boolean): Boolean
}
