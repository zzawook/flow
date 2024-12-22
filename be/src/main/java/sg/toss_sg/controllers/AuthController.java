package sg.toss_sg.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
public class AuthController {
    
    private final String AUTH = "/auth";

    @GetMapping(AUTH + "/signin")
    public String getMethodName(@RequestParam String param) {
        return new String();
    }
    
}
