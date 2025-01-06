package sg.toss_sg.entities;

import java.time.LocalDate;
import java.time.LocalTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;
import org.springframework.lang.Nullable;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "transaction_history")
public class TransactionHistory {

    @Id
    private Long id;

    @NotNull
    private Account toAccount;

    @NotNull
    private Account fromAccount;

    @Nullable // Nullable annotation is largely for notational purpose
    private Card card;

    @NotNull
    private LocalDate transactionDate;

    @NotNull
    private LocalTime transactionTime;

    @Default
    private String description = "";

    @NotNull
    private Double amount;

    @NotNull
    private String transactionType;

    @NotNull
    private String transactionStatus;
}
