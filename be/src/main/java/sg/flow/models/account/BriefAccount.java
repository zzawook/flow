package sg.flow.models.account;

import lombok.Builder;
import lombok.Data;
import sg.flow.entities.Bank;

@Data
@Builder
public class BriefAccount {

    private Long id;
    private Bank bank;
    private String accountName;
    private Double balance;
    
}
