package sg.flow.models.transfer;

import lombok.Builder;
import lombok.Data;
import sg.flow.entities.Bank;

@Data
@Builder
public class TransferRecepient {
    
    private String name;
    private Bank bank;
    private String accountNumber;

    public TransferRecepient(String name, Bank bank, String accountNumber) {
        this.name = name;
        this.bank = bank;
        this.accountNumber = accountNumber;
    }
}
