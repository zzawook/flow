package sg.toss_sg.entities;

import org.springframework.data.annotation.Id;

import jakarta.persistence.Table;
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
