package sg.toss_sg.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import sg.toss_sg.models.transaction.history.DailyHistoryList;
import sg.toss_sg.models.transaction.history.HistoryDetail;
import sg.toss_sg.models.transaction.history.MonthlyHistoryList;
import sg.toss_sg.services.TransactionServices.TransactionService;

@RestController
@RequiredArgsConstructor
@RequestMapping("transaction/history")
public class TransactionHistoryController extends TransactionController{
    
    private final String HISTORY = "/history";

    @Autowired
    private final TransactionService transactionService;

    @GetMapping(TRANSACTION + HISTORY + "/lastMonthHistoryList")
    public String getMethodName(@RequestParam String param) {
        return new String();
    }
    
    public MonthlyHistoryList getLast30DaysHistoryList() {
        return transactionService.getLast30DaysHistoryList();
    }

    @GetMapping(TRANSACTION + HISTORY + "/monthlyTransaction")
    public MonthlyHistoryList getMonthlyTransaction(@RequestParam int year, @RequestParam int month) {
        return transactionService.getMonthlyTransaction(year, month);
    }
    
    @GetMapping(TRANSACTION + HISTORY + "/dailyTransaction")
    public DailyHistoryList getDailyTransaction(@RequestParam int year, @RequestParam int day, @RequestParam int month) {
        return transactionService.getDailyTransaction(year, month, day);
    }

    @GetMapping(TRANSACTION + HISTORY + "/transactionDetails")
    public HistoryDetail getTransactionDetails(@RequestParam String bank_code, @RequestParam String transaction_id) {
        return transactionService.getTransactionDetails(bank_code, transaction_id);
    }

    @GetMapping(TRANSACTION + HISTORY + "/transactionWithinRange")
    public MonthlyHistoryList getTransactionWithinRange(@RequestParam int startYear, @RequestParam int startMonth, @RequestParam int startDay, @RequestParam int endYear, @RequestParam int endMonth, @RequestParam int endDay) {
        return transactionService.getTransactionWithinRange(startYear, startMonth, startDay, endYear, endMonth, endDay);
    }
    
}
