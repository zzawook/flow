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
        val linkedAccount: Account? = null, // Made nullable for partial loading
        @field:NotNull val cardType: CardType,
        @field:NotNull val cvv: String = "",
        @field:NotNull val expiryDate: LocalDate = LocalDate.now(),
        @field:NotNull val cardHolderName: String = "",
        @field:NotNull val pin: String = "",
        @field:NotNull val cardStatus: String = "",
        @field:NotBlank val addressLine1: String,
        @field:NotNull val addressLine2: String,
        @field:NotBlank val city: String,
        @field:NotBlank val state: String,
        @field:NotBlank val country: String,
        @field:NotBlank val zipCode: String,
        @field:NotBlank val phone: String,
        @field:NotNull val dailyLimit: Double,
        @field:NotNull val monthlyLimit: Double
)
