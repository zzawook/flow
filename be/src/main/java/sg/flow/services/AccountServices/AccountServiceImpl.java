package sg.flow.services.AccountServices;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.flow.entities.Account;
import sg.flow.models.account.AccountWithTransactionHistory;
import sg.flow.models.account.BriefAccount;
import sg.flow.models.transaction.TransactionHistoryDetail;
import sg.flow.repositories.account.AccountRepository;
import sg.flow.repositories.transactionHistory.TransactionHistoryRepository;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;

    private final TransactionHistoryRepository transactionHistoryRepository;

    @Override
    public List<BriefAccount> getBriefAccounts(Integer userId) {
        return accountRepository.findBriefAccountsOfUser(userId);
    }

    @Override
    public List<AccountWithTransactionHistory> getAccountWithTransactionHistory(Integer userId) {
        return accountRepository.findAccountWithTransactionHistorysOfUser(userId);
    }

    @Override
    public BriefAccount getBriefAccount(Integer userId, Long accountId) throws IllegalArgumentException {
        Optional<Account> accountFound = accountRepository.findById(accountId);
        if (accountFound.isPresent()) {
            Account account = accountFound.get();
            if (account.getOwner().getId().equals(userId)) {
                return BriefAccount.builder()
                        .id(account.getId())
                        .bank(account.getBank())
                        .balance(account.getBalance())
                        .accountName(account.getAccountName())
                        .build();
            } else {
                throw new IllegalArgumentException("Account does not belong to user");
            }
        }
        return null;
    }

    @Override
    public AccountWithTransactionHistory getAccountWithTransactionHistory(Integer userId, Long accountId) throws IllegalArgumentException {
        Optional<Account> accountFound = accountRepository.findById(accountId);
        if (accountFound.isPresent()) {
            Account account = accountFound.get();
            if (account.getOwner().getId().equals(userId)) {
                AccountWithTransactionHistory accountWithTransactionHistory = AccountWithTransactionHistory.builder()
                        .id(account.getId())
                        .accountNumber(account.getAccountNumber())
                        .bank(account.getBank())
                        .balance(account.getBalance())
                        .accountName(account.getAccountName())
                        .accountType(account.getAccountType())
                        .interestRatePerAnnum(account.getInterestRatePerAnnum())
                        .build();
                
                List<TransactionHistoryDetail> recentTransactionDetails = transactionHistoryRepository.findRecentTransactionHistoryDetailOfAccount(accountId);
                System.out.println(recentTransactionDetails);
                accountWithTransactionHistory.setRecentTransactionHistoryDetails(recentTransactionDetails);

                return accountWithTransactionHistory;
            } else {
                throw new IllegalArgumentException("Account does not belong to user");
            }
        }
        return null;
    }

}
