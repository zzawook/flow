package sg.toss_sg.services.AccountServices;

import java.util.List;

import sg.toss_sg.models.account.BriefAccount;
import sg.toss_sg.models.account.FullAccount;

public interface AccountService {

    List<BriefAccount> getAccounts();

    List<FullAccount> getFullAccounts();

    BriefAccount getAccount(String accountId);

    FullAccount getFullAccount(String accountId);
    
}
