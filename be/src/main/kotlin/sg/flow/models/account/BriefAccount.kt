package sg.flow.models.account

import sg.flow.entities.Bank

data class BriefAccount(val id: Long, val balance: Double, val accountName: String, val accountNumber: String, val accountType: String, val bank: Bank)

