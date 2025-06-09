

import java.time.LocalDate

data class CardNotJoined(
  val cardId: Long,
  val bankId: Long,
  val userId: Long,
  val accountId: Long?,      // nullable if no linked account
  val cardNumber: String,
  val cardType: String,
  val cvv: String,
  val expiryDate: LocalDate,
  val holderName: String,
  val pin: String,
  val status: String,
  val addr1: String,
  val addr2: String,
  val city: String,
  val state: String,
  val country: String,
  val zip: String,
  val phone: String,
  val daily: Double,
  val monthly: Double
)