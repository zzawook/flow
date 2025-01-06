package sg.flow.entities;

import java.time.LocalDate;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Builder.Default;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "users")
public class User {

    @Id
    private Integer id;

    @NotNull
    private String name;

    @NotNull
    private String email;

    @NotNull
    private String identificationNumber; // NRIC or FIN or Singpass ID

    @NotNull
    private String phoneNumber;

    @NotNull
    private LocalDate dateOfBirth;

    @NotNull
    private String address;

    @Default
    private String settingJson = "{}";
}
