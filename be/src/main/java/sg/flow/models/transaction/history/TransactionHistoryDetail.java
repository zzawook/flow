package sg.flow.models.transaction.history;

import java.time.LocalDate;
import java.time.LocalTime;


import lombok.Data;
import sg.flow.entities.Account;
import sg.flow.entities.Card;

@Data
public class TransactionHistoryDetail {
    
    private Long id;

    private Account toAccount;
    private Account fromAccount;

    private Card card;
    private LocalDate transactionDate;
    private LocalTime transactionTime;
    private String description;
    private Double amount;
    private String transactionType;
}
