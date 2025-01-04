package sg.toss_sg.repositories.account;

import java.util.List;

import sg.toss_sg.entities.Account;
import sg.toss_sg.models.account.AccountWithTransactionHistory;
import sg.toss_sg.models.account.BriefAccount;
import sg.toss_sg.repositories.Repository;

public interface AccountRepository extends Repository<Account, Long> {

    List<BriefAccount> findBriefAccountsOfUser(Integer userId);

    List<AccountWithTransactionHistory> findAccountWithTransactionHistorysOfUser(Integer userId);

}
