package sg.toss_sg.models.account;

import lombok.Builder;
import lombok.Data;
import sg.toss_sg.entities.Bank;

@Data
@Builder
public class BriefAccount {

    private Long id;
    private Bank bank;
    private String accountName;
    private Double balance;
    
}
