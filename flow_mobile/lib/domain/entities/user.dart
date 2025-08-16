import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String name,
    required String email,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String nickname,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.initial() {
    return User(
      name: '',
      email: '',
      dateOfBirth: DateTime.now(),
      phoneNumber: '',
      nickname: '',
    );
  }
}