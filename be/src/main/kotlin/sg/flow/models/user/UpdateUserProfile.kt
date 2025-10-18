package sg.flow.models.user

data class UpdateUserProfile(
        val name: String?,
        val email: String?,
        val identificationNumber: String?,
        val phoneNumber: String?,
        val settingsJson: String?,
)
