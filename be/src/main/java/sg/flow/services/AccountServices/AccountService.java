package sg.flow.services.AccountServices;

import java.util.List;

import sg.flow.models.account.AccountWithTransactionHistory;
import sg.flow.models.account.BriefAccount;

public interface AccountService {

    List<BriefAccount> getBriefAccounts(Integer userId);

    List<AccountWithTransactionHistory> getAccountWithTransactionHistorys(Integer userId);

    BriefAccount getBriefAccount(Integer userId, Long accountId);

    AccountWithTransactionHistory getAccountWithTransactionHistory(Integer userId, Long accountId);

}
