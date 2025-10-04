import 'dart:developer';

import 'package:flow_mobile/generated/card/v1/card.pbgrpc.dart';
import 'package:grpc/grpc.dart';

class CardApiService {
  CardServiceClient client;

  CardApiService(ClientChannel channel) : client = CardServiceClient(channel);

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
}
