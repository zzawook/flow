package sg.toss_sg.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import sg.toss_sg.models.user.UpdateUserProfile;
import sg.toss_sg.services.UserService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;



@Controller
public class UserController {
    
    private final String USER = "/user";

    @Autowired
    private UserService userService;

    @GetMapping(USER + "/getUserProfile")
    public String getUserProfile() {
        return userService.getUserProfile();
    }
    
    @GetMapping(USER + "/getUserSettingJson")
    public String getUserSettingJson() {
        return userService.getUserSettingJson();
    }
    
    @PostMapping(USER + "/updateUserProfile")
    public String updateUserProfile(@RequestBody UpdateUserProfile userProfile) {
        return userService.updateUserProfile(userProfile);
    }
}
