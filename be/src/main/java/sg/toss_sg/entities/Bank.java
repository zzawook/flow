package sg.toss_sg.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "banks")
public class Bank {
    
    @Id
    private Long id;

    private String name;
    private String bank_code;
}
