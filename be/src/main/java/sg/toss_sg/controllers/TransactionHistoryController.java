package sg.toss_sg.controllers;

import org.springframework.stereotype.Controller;

@Controller
public class TransactionHistoryController extends TransactionController{
    
    private final String HISTORY = super.TRANSACTION + "/history";
}
