package sg.toss_sg.models.account;

import java.util.List;

import org.springframework.data.annotation.Id;

import lombok.Builder;
import lombok.Data;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.utils.AccountType;
import sg.toss_sg.models.transaction.history.TransactionHistoryDetail;

@Data
@Builder
public class AccountWithTransactionHistory {

    @Id
    private Long id;

    private String accountNumber;
    private Bank bank;
    private Double balance;
    private String accountName;
    private AccountType accountType;
    private Double interestRatePerAnnum;
    private List<TransactionHistoryDetail> recentTransactionHistoryDetails;

}
