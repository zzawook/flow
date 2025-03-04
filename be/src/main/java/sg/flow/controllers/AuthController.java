package sg.flow.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;

import sg.flow.models.auth.SignInRequest;
import sg.flow.models.auth.TokenSet;
import sg.flow.services.AuthServices.AuthService;

@Controller
public class AuthController {

    private final String AUTH = "/auth";

    @Autowired
    AuthService authService;

    @PostMapping(AUTH + "/signin")
    public ResponseEntity<TokenSet> signIn(@RequestBody SignInRequest request) {
        TokenSet tokenSet = authService.authenticateUser(request);
        return ResponseEntity.ok(tokenSet);
    }
}
