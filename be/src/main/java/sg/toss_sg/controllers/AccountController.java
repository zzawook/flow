package sg.toss_sg.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.account.BriefAccount;
import sg.toss_sg.models.account.FullAccount;
import sg.toss_sg.services.AccountService;
import org.springframework.web.bind.annotation.GetMapping;


@RestController
@RequestMapping("accounts")
@RequiredArgsConstructor
public class AccountController {
    
    private final String ACCOUNTS = "/accounts";

    @Autowired
    private final AccountService accountService;

    @GetMapping(ACCOUNTS + "/getAccounts")
    public List<BriefAccount> getAccounts() {
        return accountService.getAccounts();
    }

    @GetMapping(ACCOUNTS + "/getFullAccounts")
    public List<FullAccount> getFullAccounts() {
        return accountService.getFullAccounts();
    }
}
