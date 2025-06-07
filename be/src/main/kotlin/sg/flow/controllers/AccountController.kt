package sg.flow.controllers

import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.account.AccountWithTransactionHistory
import sg.flow.models.account.BriefAccount
import sg.flow.services.AccountServices.AccountService

@RestController
@RequestMapping("/account")
class AccountController(private val accountService: AccountService) {

    @GetMapping("/getAccounts")
    suspend fun getAccounts(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<List<BriefAccount>> {
        var briefAccounts: List<BriefAccount> = accountService.getBriefAccounts(userId)
        return ResponseEntity.ok(briefAccounts)
    }

    @GetMapping("/getAccountsWithTransactionHistory")
    suspend fun getAccountsWithTransactionHistory(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<List<AccountWithTransactionHistory>> =
            ResponseEntity.ok(accountService.getAccountWithTransactionHistory(userId))

    @GetMapping("/getAccount")
    suspend fun getAccount(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "accountId") accountId: Long
    ): ResponseEntity<BriefAccount> {
        return try {
            val briefAccount = accountService.getBriefAccount(userId, accountId)
            ResponseEntity.ok(briefAccount)
        } catch (e: IllegalArgumentException) {
            when (e.message) {
                "Account does not belong to user" ->
                        ResponseEntity.status(HttpStatus.FORBIDDEN).build()
                "Account not found" -> ResponseEntity.notFound().build()
                else -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build()
            }
        }
    }

    @GetMapping("/getAccountWithTransactionHistory")
    suspend fun getAccountWithTransactionHistory(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "accountId") accountId: Long
    ): ResponseEntity<AccountWithTransactionHistory> {
        return try {
            val accountWithTransactionHistory =
                    accountService.getAccountWithTransactionHistory(userId, accountId)
            ResponseEntity.ok(accountWithTransactionHistory)
        } catch (e: IllegalArgumentException) {
            when (e.message) {
                "Account does not belong to user" ->
                        ResponseEntity.status(HttpStatus.FORBIDDEN).build()
                "Account not found" -> ResponseEntity.notFound().build()
                else -> ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build()
            }
        }
    }
}
