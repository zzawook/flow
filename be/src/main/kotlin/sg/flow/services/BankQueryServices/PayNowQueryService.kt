package sg.flow.services.BankQueryServices

import org.springframework.stereotype.Service
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult

@Service
class PayNowQueryService {

    suspend fun getRecepientByContact(keyword: String): TransferRecepient {
        // TODO: Implement actual logic
        throw UnsupportedOperationException("Unimplemented method 'getRecepientByContact'")
    }

    suspend fun sendTransaction(sendRequestBody: TransferRequestBody): TransferResult {
        // TODO: Implement actual logic
        throw UnsupportedOperationException("Unimplemented method 'sendTransaction'")
    }
}
