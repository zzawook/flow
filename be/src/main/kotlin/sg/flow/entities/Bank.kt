package sg.flow.entities

import jakarta.validation.constraints.NotNull
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

data class Bank(
    @field:Id
    val id: Int?,

    @field:NotNull
    val name: String,

    @field:NotNull
    val bankCode: String
) 