package sg.toss_sg.models.user;

import lombok.Data;

@Data
public class UpdateUserProfile {
    
    private String email;
    private String phoneNumber;

    public UpdateUserProfile(String email, String phoneNumber) {
        this.email = email;
        this.phoneNumber = phoneNumber;
    }
}
