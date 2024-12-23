package sg.toss_sg.models.transaction.history;

import java.time.LocalDate;
import java.time.LocalTime;


import lombok.Data;
import sg.toss_sg.entities.Account;
import sg.toss_sg.entities.Card;

@Data
public class HistoryDetail {
    
    private Long id;

    private Account account;
    private Account toAccount;
    private Account fromAccount;

    private Card card;
    private LocalDate transactionDate;
    private LocalTime transactionTime;
    private String description;
    private Double amount;
    private String transactionType;
}
