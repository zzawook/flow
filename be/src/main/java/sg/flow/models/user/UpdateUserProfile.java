package sg.flow.models.user;

import lombok.Data;

@Data
public class UpdateUserProfile {

    private String email;
    private String phoneNumber;
    private String address;

}
