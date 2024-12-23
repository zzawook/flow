package sg.toss_sg.services.AccountServices;

import java.util.List;

import org.springframework.stereotype.Service;

import sg.toss_sg.models.account.BriefAccount;
import sg.toss_sg.models.account.FullAccount;

@Service
public class AccountServiceImpl implements AccountService {

    @Override
    public List<BriefAccount> getAccounts() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getAccounts'");
    }

    @Override
    public List<FullAccount> getFullAccounts() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getFullAccounts'");
    }

    @Override
    public BriefAccount getAccount(String accountId) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getAccount'");
    }

    @Override
    public FullAccount getFullAccount(String accountId) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getFullAccount'");
    }
    
}
