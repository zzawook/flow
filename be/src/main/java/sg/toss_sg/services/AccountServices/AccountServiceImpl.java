package sg.toss_sg.services.AccountServices;

import java.util.List;
import java.util.Optional;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.entities.Account;
import sg.toss_sg.models.account.AccountWithTransactionHistory;
import sg.toss_sg.models.account.BriefAccount;
import sg.toss_sg.models.transaction.history.TransactionHistoryDetail;
import sg.toss_sg.repositories.account.AccountRepository;
import sg.toss_sg.repositories.transactionHistory.TransactionHistoryRepository;

@Service
@RequiredArgsConstructor
public class AccountServiceImpl implements AccountService {

    private final AccountRepository accountRepository;

    private final TransactionHistoryRepository transactionRepository;

    @Override
    public List<BriefAccount> getBriefAccounts(Integer userId) {
        return accountRepository.findBriefAccountsOfUser(userId);
    }

    @Override
    public List<AccountWithTransactionHistory> getAccountWithTransactionHistorys(Integer userId) {
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
                
                List<TransactionHistoryDetail> recentTransactionDetails = transactionRepository.findRecentTransactionHistoryDetailOfAccount(accountId);
                accountWithTransactionHistory.setRecentTransactionHistoryDetails(recentTransactionDetails);

                return accountWithTransactionHistory;
            } else {
                throw new IllegalArgumentException("Account does not belong to user");
            }
        }
        return null;
    }

}
