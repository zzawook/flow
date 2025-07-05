package sg.flow.bootstrap

import java.io.BufferedReader
import java.io.IOException
import java.io.InputStreamReader
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.LocalTime
import kotlinx.coroutines.*
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.sync.Semaphore
import kotlinx.coroutines.sync.withPermit
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.CommandLineRunner
import org.springframework.context.annotation.Profile
import org.springframework.core.annotation.Order
import org.springframework.core.io.ClassPathResource
import org.springframework.stereotype.Component
import sg.flow.entities.Account
import sg.flow.entities.Bank
import sg.flow.entities.Card
import sg.flow.entities.TransactionHistory
import sg.flow.entities.User
import sg.flow.entities.utils.AccountType
import sg.flow.entities.utils.CardType
import sg.flow.models.card.BriefCard
import sg.flow.repositories.account.AccountRepository
import sg.flow.repositories.bank.BankRepository
import sg.flow.repositories.card.CardRepository
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository
import sg.flow.repositories.user.UserRepository

@Profile("!prod")
@Component
@Order(2)
class InjectTestData(
        @Autowired private val userRepository: UserRepository,
        @Autowired private val accountRepository: AccountRepository,
        @Autowired private val cardRepository: CardRepository,
        @Autowired private val bankRepository: BankRepository,
        @Autowired private val transactionRepository: TransactionHistoryRepository
) : CommandLineRunner {

    override fun run(vararg args: String) = runBlocking {
        println("Starting test data injection...")

        clearTestData()
        println("Cleared existing test data.")

        injectUserData()
        println("Injected user data.")

        injectBankData()
        println("Injected bank data.")

        injectAccountData()
        println("Injected account data.")

        injectCardData()
        println("Injected card data.")

        injectTransactionData()
        println("Injected transaction data.")

        println("Test data injection completed successfully.")
    }

    private suspend fun clearTestData() {
        transactionRepository.deleteAll()
        cardRepository.deleteAll()
        accountRepository.deleteAll()
        userRepository.deleteAll()
        bankRepository.deleteAll()
    }

    private fun readCSVFile(csvFile: String): BufferedReader? {
        return try {
            BufferedReader(InputStreamReader(ClassPathResource(csvFile).inputStream))
        } catch (e: IOException) {
            e.printStackTrace()
            null
        }
    }

    private suspend fun injectUserData() {
        val br = readCSVFile("testdata/users.csv")
        if (br == null) {
            println("Error reading user data file")
            return
        }

        br.use { reader ->
            var isFirstLine = true
            reader.lineSequence().forEach { line ->
                if (isFirstLine) {
                    isFirstLine = false
                    return@forEach
                }

                val data = line.split(",")
                val currentUser =
                        User(
                                id = data[0].toInt(),
                                name = data[1],
                                email = data[2],
                                identificationNumber = data[3],
                                phoneNumber = data[4],
                                dateOfBirth = LocalDate.parse(data[5]),
                                address = data[6],
                                settingJson = data[7]
                        )

                userRepository.save(currentUser)
            }
        }
    }

    private suspend fun injectAccountData() {
        val br = readCSVFile("testdata/accounts.csv")
        if (br == null) {
            println("Error reading account data file")
            return
        }

        br.use { reader ->
            var isFirstLine = true
            reader.lineSequence().forEach { line ->
                if (isFirstLine) {
                    isFirstLine = false
                    return@forEach
                }

                val data = line.split(",")
                val currentAccount =
                        Account(
                                id = data[0].toLong(),
                                accountNumber = data[1],
                                bank = bankRepository.findById(data[2].toLong())!!,
                                owner = userRepository.findById(data[3].toLong())!!,
                                balance = data[4].toDouble(),
                                accountName = data[5],
                                accountType = AccountType.valueOf(data[6]),
                                interestRatePerAnnum = data[7].toDouble(),
                                lastUpdated = LocalDateTime.parse(data[8]),
                                finverseId = null,
                        )

                accountRepository.save(currentAccount)
            }
        }
    }

    private suspend fun injectCardData() {
        val br = readCSVFile("testdata/cards.csv")
        if (br == null) {
            println("Error reading card data file")
            return
        }

        br.use { reader ->
            var isFirstLine = true
            reader.lineSequence().forEach { line ->
                if (isFirstLine) {
                    isFirstLine = false
                    return@forEach
                }

                val data = line.split(",")
                val currentCard =
                        Card(
                                id = data[0].toLong(),
                                owner = userRepository.findById(data[1].toLong())!!,
                                cardNumber = data[2],
                                issuingBank = bankRepository.findById(data[3].toLong())!!,
                                linkedAccount = accountRepository.findById(data[4].toLong())!!,
                                cardType = CardType.valueOf(data[5]),
                                expiryDate = LocalDate.parse(data[6]),
                                cvv = data[7],
                                pin = data[8],
                                cardStatus = data[9],
                                addressLine1 = data[10],
                                addressLine2 = data[11],
                                city = data[12],
                                state = data[13],
                                country = data[14],
                                zipCode = data[15],
                                phone = data[16],
                                dailyLimit = data[17].toDouble(),
                                monthlyLimit = data[18].toDouble(),
                                cardHolderName = data[19]
                        )

                cardRepository.save(currentCard)
            }
        }
    }

    private suspend fun injectBankData() {
        val br = readCSVFile("testdata/banks.csv")
        if (br == null) {
            println("Error reading bank data file")
            return
        }

        br.use { reader ->
            var isFirstLine = true
            reader.lineSequence().forEach { line ->
                if (isFirstLine) {
                    isFirstLine = false
                    return@forEach
                }

                val data = line.split(",")
                val currentBank = Bank(id = data[0].toInt(), name = data[1], bankCode = data[2])

                bankRepository.save(currentBank)
            }
        }
    }

    private suspend fun injectTransactionData(
        batchSize: Int = 500,
        parallelism: Int = 20               // active parseLine coroutines at once
    ) = coroutineScope {

        val br       = readCSVFile("testdata/transaction_history.csv") ?: return@coroutineScope
        val gate     = Semaphore(parallelism)                           // the global “traffic‑light”

        br.useLines { lines ->
            lines
                .drop(1)                           // skip header
                .chunked(batchSize)                // Sequence<List<String>>
                .forEach { chunk ->                // process batches sequentially
                    // ── parse every row concurrently, but capped by gate ──
                    val entities = chunk.map { row ->
                        async {
                            gate.withPermit {       // <= only `parallelism` concurrent connections
                                parseLine(row, accountRepository, cardRepository)
                            }
                        }
                    }.awaitAll()                    // wait for this batch to finish parsing

                    transactionRepository.saveAllWithId(entities)
                }
        }
    }


    /**
     * Convert one CSV row into a fully–populated TransactionHistory.
     * Uses AccountRepository and CardRepository to hydrate references.
     */
    private suspend fun parseLine(
        line: String,
        accountRepository: AccountRepository,
        cardRepository: CardRepository
    ): TransactionHistory {

        val data = line.split(',')

        val cardId  = data[3].takeIf { it.isNotBlank() }?.toLong()
        val account = accountRepository.findById(data[2].toLong())

        val briefCard = cardId?.let { id ->
            cardRepository.findById(id)?.let { full ->
                BriefCard(full.id ?: -1, full.cardNumber, full.cardType)
            }
        }

        return TransactionHistory(
            id                   = data[0].toLong(),
            transactionReference = data[1],
            account              = account,
            card                 = briefCard,
            transactionDate      = LocalDate.parse(data[4]),
            transactionTime      = data[5].takeIf { it.isNotBlank() }?.let { LocalTime.parse(it) },
            amount               = data[6].toDouble(),
            transactionType      = data[7],
            description          = data[8],
            transactionStatus    = data[9],
            friendlyDescription  = data[10]
        )
    }

}
