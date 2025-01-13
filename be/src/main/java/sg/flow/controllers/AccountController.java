package sg.flow.controllers;

import java.util.List;

import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import sg.flow.models.account.AccountWithTransactionHistory;
import sg.flow.models.account.BriefAccount;
import sg.flow.services.AccountServices.AccountService;

@Controller
@RequiredArgsConstructor
public class AccountController {

    private final String ACCOUNTS = "/accounts";

    private final AccountService accountService;

    @GetMapping(ACCOUNTS + "/getAccounts")
    public ResponseEntity<List<BriefAccount>> getAccounts(
            @AuthenticationPrincipal(expression = "userId") Integer userId) {
        return ResponseEntity.ok(accountService.getBriefAccounts(userId));
    }

    @GetMapping(ACCOUNTS + "/getAccountsWithTransactionHistory")
    public ResponseEntity<List<AccountWithTransactionHistory>> getAccountsWithTransactionHistory(
            @AuthenticationPrincipal(expression = "userId") Integer userId) {
        return ResponseEntity.ok(accountService.getAccountWithTransactionHistory(userId));
    }

    @GetMapping(ACCOUNTS + "/getAccount")
    public ResponseEntity<BriefAccount> getAccount(@AuthenticationPrincipal(expression = "userId") Integer userId,
            @RequestParam(name = "accountId") Long accountId) {
        BriefAccount briefAccount;

        try {
            briefAccount = accountService.getBriefAccount(userId, accountId);
        } catch (IllegalArgumentException e) {
            if (e.getMessage().equals("Account does not belong to user")) {
                return ResponseEntity.status(HttpStatusCode.valueOf(403)).build();
            }
            return ResponseEntity.status(HttpStatusCode.valueOf(500)).build();
        }

        if (briefAccount == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(briefAccount);
    }

    @GetMapping(ACCOUNTS + "/getAccountWithTransactionHistory")
    public ResponseEntity<AccountWithTransactionHistory> getAccountWithTransactionHistory(
            @AuthenticationPrincipal(expression = "userId") Integer userId,
            @RequestParam(name = "accountId") Long accountId) {
        AccountWithTransactionHistory accountWithTransactionHistory;

        try {
            accountWithTransactionHistory = accountService.getAccountWithTransactionHistory(userId, accountId);
        } catch (IllegalArgumentException e) {
            if (e.getMessage().equals("Account does not belong to user")) {
                return ResponseEntity.status(HttpStatusCode.valueOf(403)).build();
            }
            return ResponseEntity.status(HttpStatusCode.valueOf(500)).build();
        }

        if (accountWithTransactionHistory == null) {
            return ResponseEntity.notFound().build();
        }

        return ResponseEntity.ok(accountWithTransactionHistory);
    }

}
