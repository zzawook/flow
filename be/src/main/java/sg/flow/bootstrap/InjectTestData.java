package sg.flow.bootstrap;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Profile;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import sg.flow.entities.Account;
import sg.flow.entities.Bank;
import sg.flow.entities.Card;
import sg.flow.entities.TransactionHistory;
import sg.flow.entities.User;
import sg.flow.entities.utils.AccountType;
import sg.flow.entities.utils.CardType;
import sg.flow.repositories.account.AccountRepository;
import sg.flow.repositories.bank.BankRepository;
import sg.flow.repositories.card.CardRepository;
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository;
import sg.flow.repositories.user.UserRepository;

@RequiredArgsConstructor
@Profile("!prod")
@Component
@Order(2)
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
        clearTestData();
        injectUserData();
        injectBankData();
        injectAccountData();
        injectCardData();
        injectTransactionData();
    }

    private void clearTestData() {
        transactionRepository.deleteAll();
        cardRepository.deleteAll();
        accountRepository.deleteAll();
        userRepository.deleteAll();
        bankRepository.deleteAll();
    }

    private BufferedReader readCSVFile(String csvFile) {
        BufferedReader br = null;
        try {
            BufferedReader bufferedReader = new BufferedReader(
                    new InputStreamReader(new ClassPathResource(csvFile).getInputStream()));
            br = bufferedReader;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return br;
    }

    private void injectUserData() {
        BufferedReader br = readCSVFile("testdata/users.csv");
        if (br == null) {
            System.out.println("Error reading user data file");
            return;
        }
        String line;
        try (br) {
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }
                String[] data = line.split(",");
                Integer id = Integer.parseInt(data[0]);
                String name = data[1];
                String email = data[2];
                String identificationNumber = data[3];
                String phoneNumber = data[4];
                LocalDate dateOfBirth = LocalDate.parse(data[5]);
                String address = data[6];
                String settingJson = data[7];

                User currentUser = User.builder()
                        .id(id)
                        .name(name)
                        .email(email)
                        .identificationNumber(identificationNumber)
                        .phoneNumber(phoneNumber)
                        .dateOfBirth(dateOfBirth)
                        .address(address)
                        .settingJson(settingJson)
                        .build();

                userRepository.save(currentUser);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectAccountData() {
        BufferedReader br = readCSVFile("testdata/accounts.csv");
        if (br == null) {
            System.out.println("Error reading account data file");
            return;
        }
        String line;
        try (br) {
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                String accountNumber = data[1];
                Long bankId = Long.parseLong(data[2]);
                Long ownerId = Long.parseLong(data[3]);
                Double balance = Double.parseDouble(data[4]);
                String accountName = data[5];
                String accountType = data[6];
                Double interestRatePerAnnum = Double.parseDouble(data[7]);
                LocalDateTime lastUpdated = LocalDateTime.parse(data[8]);

                Account currentAccount = Account.builder()
                        .id(id)
                        .accountNumber(accountNumber)
                        .bank(bankRepository.findById(bankId).get())
                        .owner(userRepository.findById(ownerId).get())
                        .balance(balance)
                        .accountName(accountName)
                        .accountType(AccountType.valueOf(accountType))
                        .interestRatePerAnnum(interestRatePerAnnum)
                        .lastUpdated(lastUpdated)
                        .build();

                accountRepository.save(currentAccount);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectCardData() {
        BufferedReader br = readCSVFile("testdata/cards.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                Long ownerId = Long.parseLong(data[1]);
                String cardNumber = data[2];
                Long issuingBankId = Long.parseLong(data[3]);
                Long linkedAccountId = Long.parseLong(data[4]);
                String cardType = data[5];
                LocalDate cardExpiryDate = LocalDate.parse(data[6]);
                String cardCvc = data[7];
                String cardPin = data[8];
                String cardStatus = data[9];
                String addressLine1 = data[10];
                String addressLine2 = data[11];
                String city = data[12];
                String state = data[13];
                String country = data[14];
                String zipCode = data[15];
                String phone = data[16];
                Double dailyLimit = Double.parseDouble(data[17]);
                Double monthlyLimit = Double.parseDouble(data[18]);
                String cardHolderName = data[19];

                Card currentCard = Card.builder()
                        .id(id)
                        .owner(userRepository.findById(ownerId).get())
                        .cardNumber(cardNumber)
                        .issuingBank(bankRepository.findById(issuingBankId).get())
                        .linkedAccount(accountRepository.findById(linkedAccountId).get())
                        .cardType(CardType.valueOf(cardType))
                        .cardHolderName(cardHolderName)
                        .expiryDate(cardExpiryDate)
                        .cvv(cardCvc)
                        .pin(cardPin)
                        .cardStatus(cardStatus)
                        .addressLine1(addressLine1)
                        .addressLine2(addressLine2)
                        .city(city)
                        .state(state)
                        .country(country)
                        .zipCode(zipCode)
                        .phone(phone)
                        .dailyLimit(dailyLimit)
                        .monthlyLimit(monthlyLimit)
                        .build();

                cardRepository.save(currentCard);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectBankData() {
        BufferedReader br = readCSVFile("testdata/banks.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }
                String[] data = line.split(",");
                Integer id = Integer.parseInt(data[0]);
                String name = data[1];
                String bankCode = data[2];

                Bank currentBank = Bank.builder()
                        .id(id)
                        .name(name)
                        .bankCode(bankCode)
                        .build();

                bankRepository.save(currentBank);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void injectTransactionData() {
        BufferedReader br = readCSVFile("testdata/transaction_history.csv");
        if (br == null) {
            System.out.println("Error reading card data file");
            return;
        }
        String line;
        try (br) {
            boolean isFirstLine = true;
            while ((line = br.readLine()) != null) {
                if (isFirstLine) {
                    isFirstLine = false;
                    continue;
                }
                String[] data = line.split(",");
                Long id = Long.parseLong(data[0]);
                Long toAccountId = Long.parseLong(data[1]);
                Long fromAccountId = Long.parseLong(data[2]);

                Long cardId;

                if (data[3].length() == 0) {
                    cardId = null;
                } else {
                    cardId = Long.parseLong(data[3]);
                }

                LocalDate transactionDate = LocalDate.parse(data[4]);
                LocalTime transactionTime = LocalTime.parse(data[5]);
                String description = data[6];
                Double amount = Double.parseDouble(data[7]);
                String transactionType = data[8];
                String transactionStatus = data[9];

                TransactionHistory currentTransaction = TransactionHistory.builder()
                        .id(id)
                        .toAccount(accountRepository.findById(toAccountId).orElse(null))
                        .fromAccount(accountRepository.findById(fromAccountId).orElse(null))
                        .card(cardRepository.findById(cardId).orElse(null))
                        .transactionDate(transactionDate)
                        .transactionTime(transactionTime)
                        .description(description)
                        .amount(amount)
                        .transactionType(transactionType)
                        .transactionStatus(transactionStatus)
                        .build();

                transactionRepository.save(currentTransaction);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
