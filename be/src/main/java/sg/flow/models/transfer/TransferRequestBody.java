package sg.flow.models.transfer;

import lombok.Data;
import sg.flow.entities.Account;

@Data
public class TransferRequestBody {

    private Double amount;
    private String currency;
    private String description;
    private Account fromAccount;
    private Account toAccount;
    private String transactionType;

    public TransferRequestBody(String jsonString) {
        this.parseJson(jsonString);
    }

    private void parseJson(String jsonString) {
        //TODO: Implement this method
    }

    public TransferRequestBody(Double amount, String currency, String description, Account fromAccount, Account toAccount, String transactionType) {
        this.amount = amount;
        this.currency = currency;
        this.description = description;
        this.fromAccount = fromAccount;
        this.toAccount = toAccount;
        this.transactionType = transactionType;
    }
}
