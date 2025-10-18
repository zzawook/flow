package sg.flow.services.UserServices

import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import sg.flow.entities.User
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.repositories.user.UserRepository
import java.time.LocalDate
import java.util.Date

@Service
class UserServiceImpl(
        private val userRepository: UserRepository,
) : UserService {
    val logger = LoggerFactory.getLogger(UserServiceImpl::class.java)
    override suspend fun getAllUserIds(): List<Int> {
        return userRepository.getAllUserIds()
    }

    override suspend fun getUserProfile(userId: Int): UserProfile =
            userRepository.getUserProfile(userId)

    override suspend fun getUserPreferenceJson(userId: Int): String =
            userRepository.getUserPreferenceJson(userId)

    override suspend fun updateUserProfile(
            userId: Int,
            userProfile: UpdateUserProfile
    ): UserProfile = userRepository.updateUserProfile(userId, userProfile)

    override suspend fun saveUser(name: String, email: String, passwordEncoded: String): User? {
        try {
            val user = User(
                name = name,
                email = email,
                id = null,
                identificationNumber = "",
                phoneNumber = "",
                dateOfBirth = null,
                address = "",
                passwordHash = passwordEncoded,
                gender_is_male = null,
                settingJson = createInitialSettingJson()
            )
            userRepository.save(user)
            return user
        } catch (e: Exception) {
            e.printStackTrace()
            logger.error("Failed to save user: $email, $name")
            return null;
        }
    }

    private suspend fun createInitialSettingJson(): String {
        return """
            {
                "language": "en",
                "theme": "light",
                "fontScale": 1.0,
                "notification": ${createInitialNotificationSettingJson()},
                "displayBalanceOnHome": true
            }
        """.trimIndent()
    }

    private suspend fun createInitialNotificationSettingJson(): String {
        return """
            {
                "masterEnabled": true,
                "insightNotificationEnabled": true,
                "periodicNotificationEnabled": true,
                "periodicNotificationAutoEnabled": true,
                "periodicNotificationCron": ["0 0 0 0 * *"]
            }
        """.trimIndent()
    }

    override suspend fun markUserEmailVerified(email: String) {
        userRepository.markUserEmailVerified(email)
    }

    override suspend fun isUserVerified(email: String): Boolean {
        return userRepository.fetchIsUserEmailVerified(email)
    }

    override suspend fun canLinkBank(userId: Int): Boolean {
        return userRepository.canLinkBank(userId);
    }

    override suspend fun setConstantUserFields(userId: Int, dateOfBirth: LocalDate, genderIsMale: Boolean): Boolean {
        return userRepository.setConstantUserFields(userId, dateOfBirth, genderIsMale)
    }
}
