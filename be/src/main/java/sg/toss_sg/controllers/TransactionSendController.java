package sg.toss_sg.controllers;

import org.springframework.stereotype.Controller;

@Controller
public class TransactionSendController extends TransactionController {
    
    private final String SEND = super.TRANSACTION + "/send";
}
