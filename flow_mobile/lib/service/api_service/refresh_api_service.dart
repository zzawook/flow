import 'package:flow_mobile/domain/entity/bank.dart';
import 'package:flow_mobile/generated/refresh/v1/refresh.pbgrpc.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:fixnum/fixnum.dart' as fx;

class RefreshApiService {
  final RefreshServiceClient _channel;

  RefreshApiService(ClientChannel channel)
    : _channel = RefreshServiceClient(
        channel,
        interceptors: [getIt<GrpcInterceptor>()],
      );

  Future<CanStartRefreshSessionResponse> canStartRefreshSession(
    int bankId,
  ) async {
    final request = CanStartRefreshSessionRequest();
    request.institutionId = fx.Int64(bankId);
    try {
      final response = await _channel.canStartRefreshSession(request);
      return response;
    } catch (e) {
      throw Exception('Failed to check refresh session: $e');
    }
  }

  Future<GetBanksForLinkResponse> getBanksForLink() async {
    final request = GetBanksForLinkRequest(countryCode: "SGP");
    try {
      final response = await _channel.getBanksForLink(request);
      return response;
    } catch (e) {
      throw Exception('Failed to get banks for link: $e');
    }
  }

  Future<GetRelinkUrlResponse> getLinkUrl(Bank bank) async {
    final request = GetRelinkUrlRequest(institutionId: fx.Int64(bank.bankId));
    try {
      final response = await _channel.getRelinkUrl(request);
      return response;
    } catch (e) {
      throw Exception('Failed to get link URL: $e');
    }
  }

  Future<GetInstitutionAuthenticationResultResponse> getInstitutionAuthenticationResult(Bank bank) async {
    final request = GetInstitutionAuthenticationResultRequest(institutionId: fx.Int64(bank.bankId));
    try {
      final response = await _channel.getInstitutionAuthenticationResult(request);
      return response;
    } catch (e) {
      throw Exception('Failed to get institution authentication result: $e');
    }
  }
}
