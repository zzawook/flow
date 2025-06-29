package sg.flow.models.finverse.mappers

import sg.flow.entities.TransactionHistory
import sg.flow.models.finverse.FinverseTransaction

class FinverseTransactionToTransactionHistoryMapper : Mapper<FinverseTransaction, TransactionHistory> {
    override fun map(input: FinverseTransaction): TransactionHistory {
        TODO("Not yet implemented")
    }
}