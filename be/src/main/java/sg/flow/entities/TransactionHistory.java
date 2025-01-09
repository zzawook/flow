package sg.flow.entities;

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
    private String transactionReference;

    @Nullable
    private Account account;

    @Nullable
    private Card card;

    @NotNull
    private LocalDate transactionDate;

    @Nullable
    private LocalTime transactionTime;

    @NotNull
    private Double amount;

    @NotNull
    private String transactionType;

    @Default
    private String description = "";

    @NotNull
    private String transactionStatus;

    @Default
    private String friendlyDescription = "";
}
