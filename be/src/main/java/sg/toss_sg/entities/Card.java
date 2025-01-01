package sg.toss_sg.entities;

import java.time.LocalDate;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import sg.toss_sg.entities.utils.CardType;

@Data
@AllArgsConstructor
@Builder
@Table(name = "cards")
public class Card {

    @Id
    private Long id;

    @NotNull
    private User owner;
    
    @NotNull
    private String cardNumber;

    @NotNull
    private Bank issuingBank;

    @NotNull
    private Account linkedAccount;

    @NotNull
    private CardType cardType;

    @NotNull
    private String cvv;

    @NotNull
    private LocalDate expiryDate;

    @NotNull
    private String cardHolderName;

    @NotNull
    private String pin;

    @NotNull
    private String cardStatus;

    @NotNull
    private String addressLine1;

    @NotNull
    private String addressLine2;

    @NotNull
    private String city;

    @NotNull
    private String state;

    @NotNull
    private String country;

    @NotNull
    private String zipCode;

    @NotNull
    private String phone;

    @NotNull
    private Double dailyLimit;

    @NotNull
    private Double monthlyLimit;
}
