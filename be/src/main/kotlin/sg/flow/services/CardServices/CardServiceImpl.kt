package sg.flow.services.CardServices

import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.card.CardRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository

class CardServiceImpl(
    private val cardRepository: CardRepository,
    private val accountRepository: AccountRepository,
    private val transactionHistoryRepository: TransactionHistoryRepository
) : CardService{
    override suspend fun getCards(userId: Int): List<Card> {
        return accountRepository.findCardAccounts(userId)
    }

    override suspend fun getTransactionForCard(
        userId: Int,
        bankId: String,
        cardNumber: String,
        oldestTransactionId: String,
        limit: Int
    ): TransactionHistoryList {
        return transactionHistoryRepository.findTransactionForAccountOlderThan(
            userId,
            bankId,
            cardNumber,
            oldestTransactionId,
            limit
        )
    }
}