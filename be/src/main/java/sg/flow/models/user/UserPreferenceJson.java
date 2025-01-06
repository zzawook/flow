package sg.flow.models.user;

import lombok.Data;

@Data
public class UserPreferenceJson {
    
    private String preferenceJson;

    public UserPreferenceJson(String json) {
        this.preferenceJson = json;
    }
}
