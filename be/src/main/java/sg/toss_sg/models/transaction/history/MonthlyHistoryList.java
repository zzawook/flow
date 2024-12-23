package sg.toss_sg.models.transaction.history;

import java.time.Month;
import java.util.List;

import lombok.Data;

@Data
public class MonthlyHistoryList {
    Month month;
    List<DailyHistoryList> monthlyHistoryList;

    public MonthlyHistoryList(Month month, List<DailyHistoryList> monthlyHistoryList) {
        this.month = month;
        this.monthlyHistoryList = monthlyHistoryList;
    }

    public void add(MonthlyHistoryList additionalHistoryList) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'add'");
    }
}
