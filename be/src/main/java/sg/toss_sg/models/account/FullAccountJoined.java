package sg.toss_sg.models.account;

import java.util.List;

import org.springframework.data.annotation.Id;

import lombok.Data;
import sg.toss_sg.entities.Bank;
import sg.toss_sg.entities.Card;
import sg.toss_sg.entities.TransactionHistory;
import sg.toss_sg.entities.utils.AccountType;

@Data
public class FullAccountJoined {

    @Id
    private Long id;

    private String accountNumber;
    private Bank bank;
    private Double balance;
    private String accountName;
    private AccountType accountType;

    private List<Card> cards;
    private List<TransactionHistory> recentTransactionHistories;
}
