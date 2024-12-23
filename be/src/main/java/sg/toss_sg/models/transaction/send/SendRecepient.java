package sg.toss_sg.models.transaction.send;

import lombok.Data;
import sg.toss_sg.entities.Bank;

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
