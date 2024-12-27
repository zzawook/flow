package sg.toss_sg.entities;

import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.persistence.JoinColumn;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import sg.toss_sg.entities.utils.AccountType;

@Data
@AllArgsConstructor
@Builder
@Table(name = "accounts")
public class Account {

    @Id
    private Long id;

    private String accountNumber;

    @JoinColumn(name = "bank_id")
    private Bank bank;

    @JoinColumn(name = "owner_id")
    private User owner;
    private Double balance;
    private String accountName;
    private AccountType accountType;

    private LocalDateTime lastUpdated;
}
