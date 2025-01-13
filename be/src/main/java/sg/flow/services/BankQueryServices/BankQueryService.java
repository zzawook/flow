package sg.flow.services.BankQueryServices;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import sg.flow.entities.Bank;
import sg.flow.models.transaction.TransactionHistoryList;
import sg.flow.models.transfer.TransferRecepient;

@Service
public class BankQueryService {

    private final DBSQueryService dbsQueryService;
    private final OCBCQueryService ocbcQueryService;
    private final UOBQueryService uobQueryService;

    private List<IBankQueryService> bankQueryServices;

    public BankQueryService(DBSQueryService dbsQueryService, OCBCQueryService ocbcQueryService, UOBQueryService uobQueryService) {
        this.dbsQueryService = dbsQueryService;
        this.ocbcQueryService = ocbcQueryService;
        this.uobQueryService = uobQueryService;

        bankQueryServices = new ArrayList<IBankQueryService>();
        bankQueryServices.add(dbsQueryService);
        bankQueryServices.add(ocbcQueryService);
        bankQueryServices.add(uobQueryService);
    }

    public TransactionHistoryList getTransactionHistoryBetween(int userId, Bank bank, String accountNumber, LocalDate startDate, LocalDate endDate) {
        IBankQueryService bankQueryService = getBankQueryService(bank);
        return bankQueryService.getTransactionHistoryBetween(userId, accountNumber, startDate, endDate);
    }

    private IBankQueryService getBankQueryService(Bank bank) {
        switch(bank.getName().toUpperCase()) {
            case "DBS":
                return dbsQueryService;
            case "OCBC":
                return ocbcQueryService;
            case "UOB":
                return uobQueryService;
            default:
                throw new UnsupportedOperationException("Unimplemented bank");
        }
    }

    public List<Bank> getBanksWithAccountNumber(String accountNumber) {
        List<Bank> bankQueryServices = new ArrayList<Bank>();
        for (IBankQueryService service : this.bankQueryServices) {
            if (service.hasAccountNumber(accountNumber)) {
                bankQueryServices.add(service.getBank());
            }
        }
        return bankQueryServices;
    }

}
