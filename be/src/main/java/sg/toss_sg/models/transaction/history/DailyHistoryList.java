package sg.toss_sg.models.transaction.history;

import java.time.LocalDate;
import java.util.List;

import sg.toss_sg.entities.History;

public class DailyHistoryList {
    LocalDate date;
    List<History> historyList;
}
