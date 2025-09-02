package sg.flow.entities

import jakarta.validation.constraints.NotBlank
import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import sg.flow.entities.utils.CardType

data class Card(
        @field:Id val id: Long?,
        val owner: User? = null, // Made nullable for partial loading
        @field:NotBlank val cardNumber: String,
        val issuingBank: Bank? = null, // Made nullable for partial loading
        @field:NotNull val cardType: CardType
)
