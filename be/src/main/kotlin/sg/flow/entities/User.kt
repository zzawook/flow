package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

@Table(name = "users")
data class User(
        @Id val id: Int,
        @field:NotNull val name: String,
        @field:NotNull val email: String,
        @field:NotNull val identificationNumber: String, // NRIC or FIN or Singpass ID
        @field:NotNull val phoneNumber: String,
        @field:NotNull val dateOfBirth: LocalDate,
        @field:NotNull val address: String,
        val settingJson: String = "{}"
)
