package sg.toss_sg.models.transaction.history;

import java.time.LocalDate;
import java.util.List;

import sg.toss_sg.entities.TransactionHistory;

public class DailyHistoryList {
    LocalDate date;
    List<TransactionHistory> historyList;
}
