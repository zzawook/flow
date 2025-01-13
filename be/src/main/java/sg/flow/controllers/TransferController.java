package sg.flow.controllers;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.RequiredArgsConstructor;
import sg.flow.entities.Bank;
import sg.flow.models.transfer.TransferRecepient;
import sg.flow.models.transfer.TransferRequestBody;
import sg.flow.models.transfer.TransferResult;
import sg.flow.services.TransferServices.TransferService;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;

@RestController
@RequiredArgsConstructor
@RequestMapping("transaction/send")
public class TransferController {

    private final String SEND = "/send";

    @Autowired
    private final TransferService transferService;

    @GetMapping(SEND + "/getRelevantRecepient/accountNumber")
    public ResponseEntity<List<Bank>> getBanksByAccountNumber(
            @AuthenticationPrincipal(expression = "userId") Integer userId,
            @RequestParam(name = "keyword") String keyword) {
        return ResponseEntity.ok(transferService.getRelevantRecepientByAccountNumber(keyword));
    }

    @GetMapping(SEND + "/getRelevantRecepient/contact")
    public ResponseEntity<TransferRecepient> getRelevantRecepientByContact(
            @AuthenticationPrincipal(expression = "userId") Integer userId,
            @RequestParam(name = "keyword") String keyword) {
        return ResponseEntity.ok(transferService.getRelevantRecepientByContact(keyword));
    }

    @GetMapping(SEND + "/getRelevantRecepient")
    public ResponseEntity<List<TransferRecepient>> getRelevantRecepient(
            @AuthenticationPrincipal(expression = "userId") Integer userId) {
        return ResponseEntity.ok(transferService.getRelevantRecepient());
    }

    @PostMapping(SEND + "/sendTransaction")
    public ResponseEntity<TransferResult> sendTransaction(
            @AuthenticationPrincipal(expression = "userId") Integer userId, @RequestBody String jsonBody) {
        TransferRequestBody sendRequestBody = new TransferRequestBody(jsonBody);
        return ResponseEntity.ok(transferService.sendTransaction(sendRequestBody));
    }
}
