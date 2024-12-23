package sg.toss_sg.entities;

import org.springframework.data.annotation.Id;

import jakarta.persistence.Table;
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

    private User owner;
    private String card_number;
    private Bank issuing_bank;
    private Account linked_account;
    private CardType card_type;
}
