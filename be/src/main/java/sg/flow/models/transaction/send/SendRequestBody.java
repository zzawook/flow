package sg.flow.models.transaction.send;

import lombok.Data;
import sg.flow.entities.Account;

@Data
public class SendRequestBody {

    private Double amount;
    private String currency;
    private String description;
    private Account fromAccount;
    private Account toAccount;
    private String transactionType;

    public SendRequestBody(String jsonString) {
        this.parseJson(jsonString);
    }

    private void parseJson(String jsonString) {
        //TODO: Implement this method
    }

    public SendRequestBody(Double amount, String currency, String description, Account fromAccount, Account toAccount, String transactionType) {
        this.amount = amount;
        this.currency = currency;
        this.description = description;
        this.fromAccount = fromAccount;
        this.toAccount = toAccount;
        this.transactionType = transactionType;
    }
}
