package sg.flow.entities.utils;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

public enum CardType {
    CREDIT("CREDIT"),
    DEBIT("DEBIT"),
    PREPAID("PREPAID"),
    CORPORATE("CORPORATE"),
    ATM("ATM"),
    OTHERS("OTHERS");

    private final String value;

    CardType(String value) {
        this.value = value;
    }

    @JsonValue
    public String getValue() {
        return value;
    }

    @JsonCreator
    public static CardType fromValue(String value) {
        for (CardType type : CardType.values()) {
            if (type.value.equalsIgnoreCase(value)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown enum type " + value);
    }
}
