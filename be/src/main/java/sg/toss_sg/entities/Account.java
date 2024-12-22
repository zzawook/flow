package sg.toss_sg.entities;

import java.time.LocalDateTime;

import org.springframework.data.annotation.Id;

import jakarta.persistence.Table;
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
    private Bank bank;
    private User owner;
    private Double balance;
    private String accountName;
    private AccountType accountType;

    private LocalDateTime lastUpdated;
}
