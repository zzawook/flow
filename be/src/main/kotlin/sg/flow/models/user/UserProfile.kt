package sg.flow.models.user

import java.time.LocalDate

data class UserProfile(
        val id: Int,
        val name: String,
        val email: String,
        val identificationNumber: String,
        val phoneNumber: String,
        val dateOfBirth: LocalDate,
        val settingJson: String?
)
