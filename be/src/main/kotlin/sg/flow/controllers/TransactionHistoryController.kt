package sg.flow.controllers

import java.time.LocalDate
import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.transaction.TransactionHistoryDetail
import sg.flow.models.transaction.TransactionHistoryList
import sg.flow.services.TransactionHistoryServices.TransactionHistoryService

@RestController
class TransactionHistoryController(private val transactionService: TransactionHistoryService) {

    @GetMapping("/transaction_history/lastMonthTransaction")
    suspend fun getLast30DaysHistoryList(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<TransactionHistoryList> =
            ResponseEntity.ok(transactionService.getLast30DaysHistoryList(userId))

    @GetMapping("/transaction_history/monthlyTransaction")
    suspend fun getMonthlyTransaction(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "year") year: Int,
            @RequestParam(name = "month") month: Int
    ): ResponseEntity<TransactionHistoryList> =
            ResponseEntity.ok(transactionService.getMonthlyTransaction(userId, year, month))

    @GetMapping("/transaction_history/dailyTransaction")
    suspend fun getDailyTransaction(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "year") year: Int,
            @RequestParam(name = "month") month: Int,
            @RequestParam(name = "day") day: Int
    ): ResponseEntity<TransactionHistoryList> =
            ResponseEntity.ok(
                    transactionService.getDailyTransaction(userId, LocalDate.of(year, month, day))
            )

    @GetMapping("/transaction_history/transactionDetails")
    suspend fun getTransactionDetails(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "transaction_id") transactionId: String
    ): ResponseEntity<TransactionHistoryDetail> {
        println("transaction_id: $transactionId")
        return ResponseEntity.ok(transactionService.getTransactionDetails(userId, transactionId))
    }

    @GetMapping("/transaction_history/transactionWithinRange")
    suspend fun getTransactionWithinRange(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "startYear") startYear: Int,
            @RequestParam(name = "startMonth") startMonth: Int,
            @RequestParam(name = "startDay") startDay: Int,
            @RequestParam(name = "endYear") endYear: Int,
            @RequestParam(name = "endMonth") endMonth: Int,
            @RequestParam(name = "endDay") endDay: Int
    ): ResponseEntity<TransactionHistoryList> =
            ResponseEntity.ok(
                    transactionService.getTransactionWithinRange(
                            userId,
                            LocalDate.of(startYear, startMonth, startDay),
                            LocalDate.of(endYear, endMonth, endDay)
                    )
            )
}
