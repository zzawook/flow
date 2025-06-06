package sg.flow.controllers

import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RestController
import sg.flow.models.user.UpdateUserProfile
import sg.flow.models.user.UserProfile
import sg.flow.services.UserServices.UserService

@RestController
class UserController(private val userService: UserService) {

    @GetMapping("/user/getUserProfile")
    suspend fun getUserProfile(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<UserProfile> = ResponseEntity.ok(userService.getUserProfile(userId))

    @GetMapping("/user/getUserPreferenceJson")
    suspend fun getUserPreferenceJson(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<String> = ResponseEntity.ok(userService.getUserPreferenceJson(userId))

    @PostMapping("/user/updateUserProfile")
    suspend fun updateUserProfile(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestBody userProfile: UpdateUserProfile
    ): ResponseEntity<UserProfile> =
            ResponseEntity.ok(userService.updateUserProfile(userId, userProfile))
}
