package sg.flow.models.transfer

import java.time.LocalDateTime

data class TransferRequestBody(
        val senderAccountNumber: String,
        val recepient: TransferRecepient,
        val amount: Double,
        val note: String?,
        val scheduledAt: LocalDateTime? = null,
)
