package sg.flow.models.card
import sg.flow.entities.utils.CardType

data class BriefCard(
    val id: Long,
    val cardNumber: String,
    val cardType: CardType
)