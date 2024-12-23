package sg.toss_sg.models.account;

import lombok.Data;
import sg.toss_sg.entities.Bank;

@Data
public class BriefAccount {

    private Long id;
    private Bank bank;
    private String accountNumber;
    private String accountName;
    private Double balance;
    
}
