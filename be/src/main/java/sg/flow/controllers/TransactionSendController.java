package sg.flow.controllers;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.websocket.SendResult;
import lombok.RequiredArgsConstructor;
import sg.flow.models.transaction.send.SendRecepient;
import sg.flow.models.transaction.send.SendRequestBody;
import sg.flow.services.TransactionServices.TransactionService;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;


@RestController
@RequiredArgsConstructor
@RequestMapping("transaction/send")
public class TransactionSendController extends TransactionController {
    
    private final String SEND = "/send";

    @Autowired
    private final TransactionService transactionService;

    @GetMapping(SEND + "/getRelevantRecepient")
    public SendRecepient getRelevantRecepient(@RequestParam String keyword) {
        return transactionService.getRelevantRecepient(keyword);
    }

    @PostMapping(SEND + "/sendTransaction")
    public SendResult sendTransaction(@RequestBody String jsonBody) {
        SendRequestBody sendRequestBody = new SendRequestBody(jsonBody);
        return transactionService.sendTransaction(sendRequestBody);
    }
}
