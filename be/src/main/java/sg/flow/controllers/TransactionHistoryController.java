package sg.flow.controllers;

import java.time.LocalDate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import lombok.RequiredArgsConstructor;
import sg.flow.models.transaction.TransactionHistoryDetail;
import sg.flow.models.transaction.TransactionHistoryList;
import sg.flow.services.TransactionHistoryServices.TransactionHistoryService;

@Controller
@RequiredArgsConstructor
public class TransactionHistoryController {

    private final String TRANSACTION_HISTORY = "/transaction_history";

    @Autowired
    private final TransactionHistoryService transactionService;

    @GetMapping(TRANSACTION_HISTORY + "/lastMonthTransaction")
    public ResponseEntity<TransactionHistoryList> getLast30DaysHistoryList(
            @AuthenticationPrincipal(expression = "userId") int userId) {
        return ResponseEntity.ok(transactionService.getLast30DaysHistoryList(userId));
    }

    @GetMapping(TRANSACTION_HISTORY + "/monthlyTransaction")
    public ResponseEntity<TransactionHistoryList> getMonthlyTransaction(
            @AuthenticationPrincipal(expression = "userId") int userId, @RequestParam(name = "year") int year,
            @RequestParam(name = "month") int month) {
        return ResponseEntity.ok(transactionService.getMonthlyTransaction(userId, year, month));
    }

    @GetMapping(TRANSACTION_HISTORY + "/dailyTransaction")
    public ResponseEntity<TransactionHistoryList> getDailyTransaction(
            @AuthenticationPrincipal(expression = "userId") int userId, @RequestParam(name = "year") int year,
            @RequestParam(name = "month") int month, @RequestParam(name = "day") int day) {
        return ResponseEntity.ok(transactionService.getDailyTransaction(userId, LocalDate.of(year, month, day)));
    }

    @GetMapping(TRANSACTION_HISTORY + "/transactionDetails")
    public ResponseEntity<TransactionHistoryDetail> getTransactionDetails(
            @AuthenticationPrincipal(expression = "userId") int userId,
            @RequestParam(name = "transaction_id") String transaction_id) {
        System.out.println("transaction_id: " + transaction_id);
        return ResponseEntity.ok(transactionService.getTransactionDetails(userId, transaction_id));
    }

    @GetMapping(TRANSACTION_HISTORY + "/transactionWithinRange")
    public ResponseEntity<TransactionHistoryList> getTransactionWithinRange(
            @AuthenticationPrincipal(expression = "userId") int userId, @RequestParam(name = "startYear") int startYear,
            @RequestParam(name = "startMonth") int startMonth, @RequestParam(name = "startDay") int startDay,
            @RequestParam(name = "endYear") int endYear,
            @RequestParam(name = "endMonth") int endMonth, @RequestParam(name = "endDay") int endDay) {
        return ResponseEntity.ok(transactionService.getTransactionWithinRange(userId,
                LocalDate.of(startYear, startMonth, startDay), LocalDate.of(endYear, endMonth, endDay)));
    }

}
