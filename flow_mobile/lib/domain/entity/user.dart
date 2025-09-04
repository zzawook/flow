import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final DateTime dateOfBirth;

  @HiveField(3)
  final String phoneNumber;

  @HiveField(4)
  final String nickname;

  User({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.nickname,
  });

  factory User.initial() {
    return User(
      name: '',
      email: '',
      dateOfBirth: DateTime.now(),
      phoneNumber: '',
      nickname: '',
    );
  }

  User copyWith({String? nickname, String? name, String? email, DateTime? dateOfBirth, String? phoneNumber}) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      nickname: nickname ?? this.nickname,
    );
  }
}
