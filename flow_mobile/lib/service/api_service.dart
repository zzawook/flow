import 'package:flow_mobile/service/auth_service.dart';
import 'package:flow_mobile/service/connection_service.dart';

class ApiService {
  final ConnectionService connectionService;
  final AuthService authService;
  
  ApiService({required this.connectionService, required this.authService});
}