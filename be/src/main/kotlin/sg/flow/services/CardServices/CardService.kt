package sg.flow.services.CardServices

import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory

interface CardService {
    suspend fun getCards(userId: Int): List<Card>
    suspend fun getTransactionForCard(userId: Int, cardNumber: String): List<TransactionHistory>
}