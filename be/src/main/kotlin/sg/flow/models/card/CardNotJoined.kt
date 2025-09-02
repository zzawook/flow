

import java.time.LocalDate

data class CardNotJoined(
  val cardId: Long,
  val bankId: Long,
  val userId: Long,      // nullable if no linked account
  val cardNumber: String,
  val cardType: String,
)