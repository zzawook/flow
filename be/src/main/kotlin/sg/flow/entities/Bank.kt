package sg.flow.entities

import jakarta.validation.constraints.NotNull
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table

@Table(name = "banks")
data class Bank(
    @Id
    val id: Int? = null,

    @field:NotNull
    val name: String,

    @field:NotNull
    val bankCode: String
) 