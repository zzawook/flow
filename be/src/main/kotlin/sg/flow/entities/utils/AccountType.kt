package sg.flow.entities.utils

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonValue

enum class AccountType(private val value: String) {
    SAVINGS("SAVINGS"),
    CURRENT("CURRENT"),
    TIME_DEPOSIT("TIME DEPOSIT"),
    BONDS("BONDS"),
    FUNDS("FUNDS"),
    RETIREMENT("RETIREMENT"),
    SECURITIES("SECURITIES"),
    STOCKS("STOCKS"),
    MORTGAGE("MORTGAGE"),
    PERSONAL_LOAN("PERSONAL LOAN"),
    REVOLVING_LOAN("REVOLVING LOAN"),
    CREDIT_CARD("CREDIT_CARD"),
    DEBIT_CARD("DEBIT_CARD"),
    FIXED_DEPOSIT("FIXED_DEPOSIT"),
    FOREIGN_CURRENCY("FOREIGN_CURRENCY"),
    OTHERS("OTHERS"),
    UNKNOWN("UNKNOWN");

    @get:JsonValue
    val getValue: String
        get() = value

    companion object {
        @JvmStatic
        @JsonCreator
        fun fromValue(value: String): AccountType {
            return values().firstOrNull { it.value.equals(value, ignoreCase = true) }
                    ?: throw IllegalArgumentException("Unknown enum type $value")
        }
    }
}
