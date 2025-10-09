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
import org.slf4j.LoggerFactory

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

    private val logger = LoggerFactory.getLogger(InjectTestData::class.java)

    override fun run(vararg args: String) = runBlocking {
        logger.info("Starting test data injection...")

//        clearTestData()
//        logger.info("Cleared existing test data.")

//        injectUserData()
        logger.info("Injected user data.")

//        injectBankData()
//        logger.info("Injected bank data.")

//        injectAccountData()
//        logger.info("Injected account data.")
//
//        injectCardData()
//        logger.info("Injected card data.")
//
//        injectTransactionData()
//        logger.info("Injected transaction data.")

        logger.info("Test data injection completed successfully.")
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
            logger.error("Error reading user data file")
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
                                gender_is_male = null,
                                settingJson = data[7]
                        )

                userRepository.save(currentUser)
            }
        }
    }

    private suspend fun injectAccountData() {
        val br = readCSVFile("testdata/accounts.csv")
        if (br == null) {
            logger.error("Error reading account data file")
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
            logger.error("Error reading card data file")
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
                                cardType = CardType.valueOf(data[5]),
                        )

                cardRepository.save(currentCard)
            }
        }
    }

    private suspend fun injectBankData() {
        val br = readCSVFile("testdata/banks.csv")
        if (br == null) {
            logger.error("Error reading bank data file")
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
            friendlyDescription  = data[10],
            finverseId = generateRandomString(255)
        )
    }

    private fun generateRandomString(length: Int = 255): String {
        val allowedChars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        return (1..length)
            .map { allowedChars.random() }
            .joinToString("")
    }

}
