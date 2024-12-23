package sg.toss_sg.models.user;

import java.time.LocalDate;

import lombok.Data;

@Data
public class UserProfile {
    
    private String name;
    private String emailString;
    private String phoneNumber;
    private LocalDate dateOfBirth;
    private String identificationNumber;

    public UserProfile(String name, String emailString, String phoneNumber, LocalDate dateOfBirth,
            String identificationNumber) {
        this.name = name;
        this.emailString = emailString;
        this.phoneNumber = phoneNumber;
        this.dateOfBirth = dateOfBirth;
        this.identificationNumber = identificationNumber;
    }
}
