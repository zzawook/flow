package sg.flow.entities;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "banks")
public class Bank {

    @Id
    private Integer id;

    @NotNull
    private String name;

    @NotNull
    private String bankCode;
}
