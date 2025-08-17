import 'package:flow_mobile/generated/refresh/v1/refresh.pbgrpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class RefreshApiService {
  final RefreshServiceClient _channel;

  RefreshApiService(ClientChannel channel)
      : _channel = RefreshServiceClient(channel);

  Future<CanStartRefreshSessionResponse> canStartRefreshSession(String bankId) async {
    final request = CanStartRefreshSessionRequest();
    request.institutionId = bankId;
    try {
      final response = await _channel.canStartRefreshSession(request);
      return response;
    } catch (e) {
      throw Exception('Failed to check refresh session: $e');
    }
  }
}
