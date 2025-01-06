package sg.flow.models.transaction.send;

import lombok.Data;
import sg.flow.entities.Bank;

@Data
public class SendRecepient {
    
    private String name;
    private Bank bank;
    private String accountNumber;

    public SendRecepient(String name, Bank bank, String accountNumber) {
        this.name = name;
        this.bank = bank;
        this.accountNumber = accountNumber;
    }
}
