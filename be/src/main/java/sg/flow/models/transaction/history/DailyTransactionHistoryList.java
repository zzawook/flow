package sg.flow.models.transaction.history;

import java.time.LocalDate;
import java.util.List;

import sg.flow.entities.TransactionHistory;

public class DailyTransactionHistoryList {
    LocalDate date;
    List<TransactionHistory> historyList;
}
