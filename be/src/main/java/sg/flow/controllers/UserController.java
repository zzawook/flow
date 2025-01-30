package sg.flow.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import sg.flow.models.user.UpdateUserProfile;
import sg.flow.models.user.UserProfile;
import sg.flow.services.UserServices.UserService;

@Controller
public class UserController {

    private final String USER = "/user";

    @Autowired
    private UserService userService;

    @GetMapping(USER + "/getUserProfile")
    public ResponseEntity<UserProfile> getUserProfile(@AuthenticationPrincipal(expression = "userId") Integer userId) {
        return ResponseEntity.ok(userService.getUserProfile(userId));
    }

    @GetMapping(USER + "/getUserPreferenceJson")
    public ResponseEntity<String> getUserPreferenceJson(
            @AuthenticationPrincipal(expression = "userId") Integer userId) {
        return ResponseEntity.ok(userService.getUserPreferenceJson(userId));
    }

    @PostMapping(USER + "/updateUserProfile")
    public ResponseEntity<UserProfile> updateUserProfile(@AuthenticationPrincipal(expression = "userId") Integer userId,
            @RequestBody UpdateUserProfile userProfile) {
        return ResponseEntity.ok(userService.updateUserProfile(userId, userProfile));
    }
}
