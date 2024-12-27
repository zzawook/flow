package sg.toss_sg.entities;

import java.time.LocalDate;
import java.time.LocalTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.annotation.Nullable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "transaction_history")
public class TransactionHistory {
    
    @Id
    private Long id;

    private Account account;

    @Nullable
    private Account toAccount;

    @Nullable
    private Account fromAccount;
    
    @Nullable
    private Card card;
    private LocalDate transactionDate;
    private LocalTime transactionTime;
    private String description;
    private Double amount;
    private String transactionType;

}
