import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/generated/user/v1/user.pbgrpc.dart';
import 'package:flow_mobile/initialization/service_registry.dart';
import 'package:flow_mobile/service/api_service/grpc_interceptor.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:flow_mobile/generated/google/protobuf/timestamp.pb.dart' as gp;

class UserApiService {
  final UserServiceClient client;

  UserApiService(ClientChannel channel) : client = UserServiceClient(channel, 
    interceptors: [getIt<GrpcInterceptor>()]);

  Future<UserProfile> getUserDetails(String userId) async {
    final request = GetUserProfileRequest();
    try {
      final response = await client.getUserProfile(request);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<UserProfile> getUserProfile() async {
    final request = GetUserProfileRequest();
    try {
      final response = await client.getUserProfile(request);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch user profile: $e');
    }
  }

  Future<GetUserPreferenceJsonResponse> getUserPreferenceJson() async {
    final request = GetUserPreferenceJsonRequest();
    try {
      final response = await client.getUserPreferenceJson(request);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch user preference JSON: $e');
    }
  }

  Future<UserProfile> updateUserProfile(User user, {String settingsJson = ''}) async {
    final request = UpdateUserProfileRequest();
    request.name = user.name;
    request.email = user.email;
    request.phoneNumber = user.phoneNumber;
    if (settingsJson.isNotEmpty) {
      request.settingsJson = settingsJson;
    }

    try {
      final response = await client.updateUserProfile(request);
      return response;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  gp.Timestamp ts(DateTime dt) => gp.Timestamp.fromDateTime(dt.toUtc());

  Future<SetConstantUserFieldsResponse> setConstantUserFields(
    DateTime dateOfBirth,
    bool isGenderMale,
  ) async {
    final request = SetConstantUserFieldsRequest()
      ..dateOfBirth = ts(dateOfBirth)
      ..genderIsMale = isGenderMale;

    try {
      final response = await client.setConstantUserFields(request);
      return response;
    } catch (e) {
      throw Exception('Failed to set constant user fields: $e');
    }
  }
}
