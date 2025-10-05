package sg.flow.services.CardServices

import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionHistoryList

interface CardService {
    suspend fun getCards(userId: Int): List<Card>
    suspend fun getTransactionForCard(
        userId: Int,
        bankId: String,
        cardNumber: String,
        oldestTransactionId: String,
        limit: Int,
    ): TransactionHistoryList
}