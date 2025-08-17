package sg.flow.entities

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import org.springframework.data.annotation.Id

data class User(
        @field:Id val id: Int?,
        @field:NotBlank val name: String,
        @field:NotBlank val email: String,
        @field:NotBlank val identificationNumber: String,
        @field:NotBlank val phoneNumber: String,
        val dateOfBirth: LocalDate?,
        @field:NotBlank val address: String,
        val settingJson: String = "{}",
        val passwordHash: String = ""
)
