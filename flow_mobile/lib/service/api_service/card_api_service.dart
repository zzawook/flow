import 'dart:developer';

import 'package:flow_mobile/domain/entity/card.dart';
import 'package:flow_mobile/generated/card/v1/card.pbgrpc.dart';
import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc.dart';

class CardApiService {
  CardServiceClient client;

  CardApiService(ClientChannel channel)
    : client = CardServiceClient(
        channel,
        interceptors: [getIt<GrpcInterceptor>()],
      );

  Future<GetCardsResponse> fetchCards() async {
    try {
      final request = GetCardsRequest();
      final response = await client.getCards(request);
      return response;
    } catch (e) {
      log('Error fetching cards: $e');
      return GetCardsResponse();
    }
  }

  Future<TransactionHistoryList> fetchCardTransaction(Card card, int limit, String? oldestTransactionId) async {
    try {
      final request = GetCardTransactionsRequest(
        cardNumber: card.cardNumber,
        bankId: card.bank.bankId.toString(),
        oldestTransactionId: oldestTransactionId,
        limit: limit
      );

      final response = await client.getCardTransactions(request);
      return response;
    } catch (e) {
      log("Error fetching transactions for card: ${card.cardNumber}: $e");
      return TransactionHistoryList();
    }
  }
}
