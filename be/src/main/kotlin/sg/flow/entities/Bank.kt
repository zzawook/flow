package sg.flow.entities

import jakarta.validation.constraints.NotNull
import jakarta.validation.constraints.NotBlank
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

data class Bank(
    @field:Id
    val id: Int?,

    @field:NotBlank
    val name: String,

    @field:NotBlank
    val bankCode: String,

    val finverseId: String? = null,

    val countries: String = "SGP"
) 