package sg.flow.entities.utils;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum AccountType {
    SAVINGS("SAVINGS"),
    CURRENT("CURRENT"),
    FIXED_DEPOSIT("FIXED_DEPOSIT"),
    FOREIGN_CURRENCY("FOREIGN_CURRENCY"),
    OTHERS("OTHERS");

    private final String value;

    AccountType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @JsonCreator
    public static AccountType fromValue(String value) {
        for (AccountType type : AccountType.values()) {
            if (type.value.equalsIgnoreCase(value)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown enum type " + value);
    }
}
