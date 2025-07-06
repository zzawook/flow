package sg.flow.models.finverse.mappers

import sg.flow.entities.User
import sg.flow.models.finverse.responses.FinverseIdentityData

class FinverseIdentityMapper : Mapper<FinverseIdentityData, User> {

    fun map(input: FinverseIdentityData): User {
        val primaryAddress =
                input.addresses?.firstOrNull { it.type == "primary" }
                        ?: input.addresses?.firstOrNull()

        val fullAddress = buildString {
            primaryAddress?.street?.let { append(it) }
            primaryAddress?.city?.let {
                if (isNotEmpty()) append(", ")
                append(it)
            }
            primaryAddress?.state?.let {
                if (isNotEmpty()) append(", ")
                append(it)
            }
            primaryAddress?.postalCode?.let {
                if (isNotEmpty()) append(" ")
                append(it)
            }
            primaryAddress?.country?.let {
                if (isNotEmpty()) append(", ")
                append(it)
            }
        }

        return User(
                id = 0, // Will be set by database
                name = input.names?.firstOrNull() ?: "",
                email = input.emails?.firstOrNull() ?: "",
                identificationNumber = input.nationalId ?: input.taxId ?: "",
                phoneNumber = input.phoneNumbers?.firstOrNull() ?: "",
                dateOfBirth = input.dateOfBirth
                                ?: throw IllegalArgumentException("Date of birth is required"),
                address = fullAddress,
                settingJson = "{}"
        )
    }
}
