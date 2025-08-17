import 'package:flow_mobile/domain/entity/user.dart';
import 'package:flow_mobile/generated/user/user.pbgrpc.dart';
import 'package:grpc/grpc_connection_interface.dart';

class UserApiService {
  final UserServiceClient client;

  UserApiService(ClientChannel channel) : client = UserServiceClient(channel);

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

  Future<UserProfile> updateUserProfile(User user, {String settingJson = ''}) async {
    final request = UpdateUserProfileRequest();
    request.name = user.name;
    request.email = user.email;
    request.phoneNumber = user.phoneNumber;
    // if (settingJson.isNotEmpty) {
    //   request.settingJson = settingJson;
    // }
    // request.address = user.address;
    // request.nickname = user.nickname;

    try {
      final response = await client.updateUserProfile(request);
      return response;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }
}
