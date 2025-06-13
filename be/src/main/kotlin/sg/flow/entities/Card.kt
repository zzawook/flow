package sg.flow.entities

import jakarta.validation.constraints.NotNull
import java.time.LocalDate
import org.springframework.data.annotation.Id
import org.springframework.data.relational.core.mapping.Table
import sg.flow.entities.utils.CardType

data class Card(
        @field:Id val id: Long,
        val owner: User? = null, // Made nullable for partial loading
        @field:NotNull val cardNumber: String,
        val issuingBank: Bank? = null, // Made nullable for partial loading
        val linkedAccount: Account? = null, // Made nullable for partial loading
        @field:NotNull val cardType: CardType,
        @field:NotNull val cvv: String = "",
        @field:NotNull val expiryDate: LocalDate = LocalDate.now(),
        @field:NotNull val cardHolderName: String = "",
        @field:NotNull val pin: String = "",
        @field:NotNull val cardStatus: String = "",
        @field:NotNull val addressLine1: String,
        @field:NotNull val addressLine2: String,
        @field:NotNull val city: String,
        @field:NotNull val state: String,
        @field:NotNull val country: String,
        @field:NotNull val zipCode: String,
        @field:NotNull val phone: String,
        @field:NotNull val dailyLimit: Double,
        @field:NotNull val monthlyLimit: Double
)
