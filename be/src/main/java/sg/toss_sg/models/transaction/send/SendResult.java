package sg.toss_sg.models.transaction.send;

import lombok.Data;

@Data
public class SendResult {
    
    private String transactionId;
    private String status;
    private String message;

    public SendResult(String transactionId, String status, String message) {
        this.transactionId = transactionId;
        this.status = status;
        this.message = message;
    }
}
