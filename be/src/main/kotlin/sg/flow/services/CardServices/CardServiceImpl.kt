package sg.flow.services.CardServices

import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.card.CardRepository

class CardServiceImpl(
    private val cardRepository: CardRepository,
    private val accountRepository: AccountRepository
) : CardService{
    override suspend fun getCards(userId: Int): List<Card> {
        return accountRepository.findCardAccounts(userId)
    }

    override suspend fun getTransactionForCard(
        userId: Int,
        cardNumber: String
    ): List<TransactionHistory> {
        TODO("Not yet implemented")
    }
}