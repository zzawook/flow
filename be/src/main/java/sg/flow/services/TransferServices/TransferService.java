package sg.flow.services.TransferServices;

import java.util.List;

import sg.flow.entities.Bank;
import sg.flow.models.transfer.TransferRecepient;
import sg.flow.models.transfer.TransferRequestBody;
import sg.flow.models.transfer.TransferResult;

public interface TransferService {

    TransferResult sendTransaction(TransferRequestBody sendRequestBody);

    List<TransferRecepient> getRelevantRecepient();

    List<Bank> getRelevantRecepientByAccountNumber(String accountNumber);

    TransferRecepient getRelevantRecepientByContact(String contact);
    
}
