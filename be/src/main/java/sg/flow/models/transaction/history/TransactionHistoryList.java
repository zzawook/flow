package sg.flow.models.transaction.history;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import lombok.Data;

@Data
public class TransactionHistoryList {
    private final LocalDate from;
    private final LocalDate to;
    private final List<TransactionHistoryDetail> monthlyHistoryList;

    public TransactionHistoryList(LocalDate from, LocalDate to) {
        this.from = from;
        this.to = to;
        this.monthlyHistoryList = new ArrayList<>();
    }

    public void add(TransactionHistoryList additionalHistoryList) {
        this.monthlyHistoryList.addAll(additionalHistoryList.getMonthlyHistoryList());
    }

    public void add(TransactionHistoryDetail transactionHistoryDetail) {
        this.monthlyHistoryList.add(transactionHistoryDetail);
    }
}
