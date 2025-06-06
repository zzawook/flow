package sg.flow.entities.utils

import com.fasterxml.jackson.annotation.JsonCreator
import com.fasterxml.jackson.annotation.JsonValue

enum class CardType(private val value: String) {
    CREDIT("CREDIT"),
    DEBIT("DEBIT"),
    PREPAID("PREPAID"),
    CORPORATE("CORPORATE"),
    ATM("ATM"),
    OTHERS("OTHERS");

    @get:JsonValue
    val getValue: String
        get() = value

    companion object {
        @JvmStatic
        @JsonCreator
        fun fromValue(value: String): CardType {
            return values().firstOrNull { it.value.equals(value, ignoreCase = true) }
                    ?: throw IllegalArgumentException("Unknown enum type $value")
        }
    }
}
