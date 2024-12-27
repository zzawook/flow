package sg.toss_sg.bootstrap;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.entities.Account;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.Card;
import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.entities.User;
import sg.toss_sg.entities.utils.AccountType;
import sg.toss_sg.entities.utils.CardType;
import sg.toss_sg.repositories.AccountRepository;
import sg.toss_sg.repositories.BankRepository;
import sg.toss_sg.repositories.CardRepository;
import sg.toss_sg.repositories.TransactionHistoryRepository;
import sg.toss_sg.repositories.UserRepository;

@RequiredArgsConstructor
@Profile("dev")
public class InjectTestData implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AccountRepository accountRepository;

    @Autowired
    private CardRepository cardRepository;

    @Autowired
    private BankRepository bankRepository;

    @Autowired
    private TransactionHistoryRepository transactionRepository;

    @Override
    public void run(String... args) throws Exception {
        injectUserData();
        injectAccountData();
        injectCardData();
        injectBankData();
        injectTransactionData();
    }

    private BufferedReader readCSVFile(String csvFile) {
        BufferedReader br = null;
        try(BufferedReader bufferedReader = new BufferedReader(new FileReader(csvFile))) {
            br = bufferedReader;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return br;
    }

    private void injectUserData() {
        BufferedReader br = readCSVFile("testDataCsv/users.csv");
        if (br == null) {
            System.out.println("Error reading user data file");
            return;
        }
        String line;
        try (br) {
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                String name = data[1];
                String email = data[2];
                String identificationNumber = data[3];
                String phoneNumber = data[4];
                LocalDate dateOfBirth = LocalDate.parse(data[5]);
                String settingJson = data[6];

                User currentUser = User.builder()
                    .id(id)
                    .name(name)
                    .email(email)
                    .identificationNumber(identificationNumber)
                    .phoneNumber(phoneNumber)
                    .dateOfBirth(dateOfBirth)
                    .settingJson(settingJson)
                    .build();

                userRepository.save(currentUser);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectAccountData() {
        BufferedReader br = readCSVFile("testDataCsv/accounts.csv");
        if (br == null) {
            System.out.println("Error reading account data file");
            return;
        }
        String line;
        try (br) {
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                String accountNumber = data[1];
                Long bankId = Long.parseLong(data[2]);
                Long ownerId = Long.parseLong(data[3]);
                Double balance = Double.parseDouble(data[4]);
                String accountName = data[5];
                String accountType = data[6];
                LocalDateTime lastUpdated = LocalDateTime.parse(data[7]);

                Account currentAccount = Account.builder()
                    .id(id)
                    .accountNumber(accountNumber)
                    .bank(bankRepository.findById(bankId).get())
                    .owner(userRepository.findById(ownerId).get())
                    .balance(balance)
                    .accountName(accountName)
                    .accountType(AccountType.valueOf(accountType))
                    .lastUpdated(lastUpdated)
                    .build();

                accountRepository.save(currentAccount);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectCardData() {
        BufferedReader br = readCSVFile("testDataCsv/cards.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                Long ownerId = Long.parseLong(data[1]);
                String cardNumber = data[2];
                Long issuingBankId = Long.parseLong(data[3]);
                Long linkedAccountId = Long.parseLong(data[4]);
                String cardType = data[5];

                Card currentCard = Card.builder()
                    .id(id)
                    .owner(userRepository.findById(ownerId).get())
                    .card_number(cardNumber)
                    .issuing_bank(bankRepository.findById(issuingBankId).get())
                    .linked_account(accountRepository.findById(linkedAccountId).get())
                    .card_type(CardType.valueOf(cardType))
                    .build();

                cardRepository.save(currentCard);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectBankData() {
        BufferedReader br = readCSVFile("testDataCsv/cards.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                String name = data[1];
                String bankCode = data[2];

                Bank currentBank = Bank.builder()
                    .id(id)
                    .name(name)
                    .bank_code(bankCode)
                    .build();

                bankRepository.save(currentBank);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectTransactionData() {
        BufferedReader br = readCSVFile("testDataCsv/cards.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            while ((line = br.readLine()) != null) {
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                Long accountId = Long.parseLong(data[1]);
                Long toAccountId = Long.parseLong(data[2]);
                Long fromAccountId = Long.parseLong(data[3]);
                Long cardId = Long.parseLong(data[4]);
                LocalDate transactionDate = LocalDate.parse(data[5]);
                LocalTime transactionTime = LocalTime.parse(data[6]);
                String description = data[7];
                Double amount = Double.parseDouble(data[8]);
                String transactionType = data[9];

                TransactionHistory currentTransaction = TransactionHistory.builder()
                    .id(id)
                    .account(accountRepository.findById(accountId).get())
                    .toAccount(accountRepository.findById(toAccountId).get())
                    .fromAccount(accountRepository.findById(fromAccountId).get())
                    .card(cardRepository.findById(cardId).get())
                    .transactionDate(transactionDate)
                    .transactionTime(transactionTime)
                    .description(description)
                    .amount(amount)
                    .transactionType(transactionType)
                    .build();

                transactionRepository.save(currentTransaction);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
