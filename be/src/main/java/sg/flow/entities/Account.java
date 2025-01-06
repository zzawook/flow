package sg.flow.entities;

import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import sg.flow.entities.utils.AccountType;

@Data
@AllArgsConstructor
@Builder
@Table(name = "accounts")
public class Account {

    @Id
    private Long id;

    @NotNull
    private String accountNumber;

    @NotNull
    private Bank bank;

    @NotNull
    private User owner;

    @NotNull
    private Double balance;

    @NotNull
    private String accountName;

    @NotNull
    private AccountType accountType;

    @NotNull
    private Double interestRatePerAnnum;

    @NotNull
    private LocalDateTime lastUpdated;
}
