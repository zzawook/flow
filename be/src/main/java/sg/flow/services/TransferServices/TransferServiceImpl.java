package sg.flow.services.TransferServices;

import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.flow.entities.Bank;
import sg.flow.models.transfer.TransferRecepient;
import sg.flow.models.transfer.TransferRequestBody;
import sg.flow.models.transfer.TransferResult;
import sg.flow.services.BankQueryServices.BankQueryService;
import sg.flow.services.BankQueryServices.PayNowQueryService;

@Service
@RequiredArgsConstructor
public class TransferServiceImpl implements TransferService {
    
    PayNowQueryService payNowQueryService;
    BankQueryService bankQueryService;

    @Override
    public TransferResult sendTransaction(TransferRequestBody sendRequestBody) {
        TransferResult transferResult = payNowQueryService.sendTransaction(sendRequestBody);
        return transferResult;
    }

    private boolean validateTransaction(TransferRequestBody sendRequestBody) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'validateTransaction'");
    }


    @Override
    public List<TransferRecepient> getRelevantRecepient() {
        List<TransferRecepient> recentTransactionTargets = getRecentTransactionTargets();

        // TODO: More logics here

        return recentTransactionTargets;
    }

    private List<TransferRecepient> getRecentTransactionTargets() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getRecentTransactionTargets'");
    }


    @Override
    public List<Bank> getRelevantRecepientByAccountNumber(String accountNumber) {
        return bankQueryService.getBanksWithAccountNumber(accountNumber);
    }


    @Override
    public TransferRecepient getRelevantRecepientByContact(String contact) {
        return payNowQueryService.getRecepientByContact(contact);
    }
}
