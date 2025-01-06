package sg.flow.models.transaction.history;

import java.time.Month;
import java.util.List;

import lombok.Data;

@Data
public class MonthlyTransactionHistoryList {
    Month month;
    List<DailyTransactionHistoryList> monthlyHistoryList;

    public MonthlyTransactionHistoryList(Month month, List<DailyTransactionHistoryList> monthlyHistoryList) {
        this.month = month;
        this.monthlyHistoryList = monthlyHistoryList;
    }

    public void add(MonthlyTransactionHistoryList additionalHistoryList) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'add'");
    }
}
