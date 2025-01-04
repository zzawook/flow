package sg.toss_sg.services.AccountServices;

import java.util.List;

import sg.toss_sg.models.account.AccountWithTransactionHistory;
import sg.toss_sg.models.account.BriefAccount;

public interface AccountService {

    List<BriefAccount> getBriefAccounts(Integer userId);

    List<AccountWithTransactionHistory> getAccountWithTransactionHistorys(Integer userId);

    BriefAccount getBriefAccount(Integer userId, Long accountId);

    AccountWithTransactionHistory getAccountWithTransactionHistory(Integer userId, Long accountId);

}
