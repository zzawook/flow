package sg.flow.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import sg.flow.models.transaction.history.DailyTransactionHistoryList;
import sg.flow.models.transaction.history.MonthlyTransactionHistoryList;
import sg.flow.models.transaction.history.TransactionHistoryDetail;
import sg.flow.services.TransactionServices.TransactionService;

@RestController
@RequiredArgsConstructor
@RequestMapping("transaction/history")
public class TransactionHistoryController extends TransactionController {

    private final String HISTORY = "/history";

    @Autowired
    private final TransactionService transactionService;

    @GetMapping(TRANSACTION + HISTORY + "/lastMonthHistoryList")
    public String getMethodName(@RequestParam String param) {
        return new String();
    }

    public ResponseEntity<MonthlyTransactionHistoryList> getLast30DaysHistoryList() {
        return ResponseEntity.ok(transactionService.getLast30DaysHistoryList());
    }

    @GetMapping(TRANSACTION + HISTORY + "/monthlyTransaction")
    public ResponseEntity<MonthlyTransactionHistoryList> getMonthlyTransaction(@RequestParam int year,
            @RequestParam int month) {
        return ResponseEntity.ok(transactionService.getMonthlyTransaction(year, month));
    }

    @GetMapping(TRANSACTION + HISTORY + "/dailyTransaction")
    public ResponseEntity<DailyTransactionHistoryList> getDailyTransaction(@RequestParam int year,
            @RequestParam int day, @RequestParam int month) {
        return ResponseEntity.ok(transactionService.getDailyTransaction(year, month, day));
    }

    @GetMapping(TRANSACTION + HISTORY + "/transactionDetails")
    public ResponseEntity<TransactionHistoryDetail> getTransactionDetails(@RequestParam String bank_code,
            @RequestParam String transaction_id) {
        return ResponseEntity.ok(transactionService.getTransactionDetails(bank_code, transaction_id));
    }

    @GetMapping(TRANSACTION + HISTORY + "/transactionWithinRange")
    public ResponseEntity<MonthlyTransactionHistoryList> getTransactionWithinRange(@RequestParam int startYear,
            @RequestParam int startMonth, @RequestParam int startDay, @RequestParam int endYear,
            @RequestParam int endMonth, @RequestParam int endDay) {
        return ResponseEntity.ok(transactionService.getTransactionWithinRange(startYear, startMonth, startDay, endYear,
                endMonth, endDay));
    }

}
