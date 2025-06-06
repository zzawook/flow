package sg.flow.controllers

import org.springframework.http.ResponseEntity
import org.springframework.security.core.annotation.AuthenticationPrincipal
import org.springframework.web.bind.annotation.*
import sg.flow.entities.Bank
import sg.flow.models.transfer.TransferRecepient
import sg.flow.models.transfer.TransferRequestBody
import sg.flow.models.transfer.TransferResult
import sg.flow.services.TransferServices.TransferService

@RestController
@RequestMapping("/transaction/send")
class TransferController(private val transferService: TransferService) {

    @GetMapping("/send/getRelevantRecepient/accountNumber")
    suspend fun getBanksByAccountNumber(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "keyword") keyword: String
    ): ResponseEntity<List<Bank>> =
            ResponseEntity.ok(transferService.getRelevantRecepientByAccountNumber(keyword))

    @GetMapping("/send/getRelevantRecepient/contact")
    suspend fun getRelevantRecepientByContact(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestParam(name = "keyword") keyword: String
    ): ResponseEntity<TransferRecepient> =
            ResponseEntity.ok(transferService.getRelevantRecepientByContact(keyword))

    @GetMapping("/send/getRelevantRecepient")
    suspend fun getRelevantRecepient(
            @AuthenticationPrincipal(expression = "userId") userId: Int
    ): ResponseEntity<List<TransferRecepient>> =
            ResponseEntity.ok(transferService.getRelevantRecepient())

    @PostMapping("/send/sendTransaction")
    suspend fun sendTransaction(
            @AuthenticationPrincipal(expression = "userId") userId: Int,
            @RequestBody sendRequestBody: TransferRequestBody
    ): ResponseEntity<TransferResult> =
            ResponseEntity.ok(transferService.sendTransaction(sendRequestBody))
}
