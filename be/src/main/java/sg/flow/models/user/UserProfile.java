package sg.flow.models.user;

import java.time.LocalDate;

import lombok.Data;

@Data
public class UserProfile {
    
    private String name;
    private String email;
    private String phoneNumber;
    private LocalDate dateOfBirth;
    private String identificationNumber;
    private String address;

    public UserProfile(String name, String email, String phoneNumber, LocalDate dateOfBirth,
            String identificationNumber, String address) {
        this.name = name;
        this.email = email;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.identificationNumber = identificationNumber;
        this.address = address;
    }
}
