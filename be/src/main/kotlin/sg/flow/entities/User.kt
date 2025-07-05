package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import org.springframework.data.annotation.Id

data class User(
        @field:Id val id: Int?,
        @field:NotNull val name: String,
        @field:NotNull val email: String,
        @field:NotNull val identificationNumber: String,
        @field:NotNull val phoneNumber: String,
        @field:NotNull val dateOfBirth: LocalDate,
        @field:NotNull val address: String,
        val settingJson: String = "{}"
)
