package sg.flow.models.account

import sg.flow.entities.Bank

data class BriefAccount(val id: Long, val balance: Double, val accountName: String, val bank: Bank)
