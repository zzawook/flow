package sg.flow.repositories.account;

import java.util.List;

import sg.flow.entities.Account;
import sg.flow.models.account.AccountWithTransactionHistory;
import sg.flow.models.account.BriefAccount;
import sg.flow.repositories.Repository;

public interface AccountRepository extends Repository<Account, Long> {

    List<BriefAccount> findBriefAccountsOfUser(Integer userId);

    List<AccountWithTransactionHistory> findAccountWithTransactionHistorysOfUser(Integer userId);

}
