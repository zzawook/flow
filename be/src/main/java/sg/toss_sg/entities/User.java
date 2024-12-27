package sg.toss_sg.entities;

import java.time.LocalDate;

import org.springframework.data.annotation.Id;
import org.springframework.data.relational.core.mapping.Table;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
@Table(name = "users")
public class User {
   
    @Id
    private Long id;

    private String name;
    private String email;

    private String identificationNumber; // NRIC or FIN or Singpass ID
    private String phoneNumber;
    private LocalDate dateOfBirth;
    private String settingJson;
}
