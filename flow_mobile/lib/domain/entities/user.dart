import 'package:hive_flutter/adapters.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
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

  User copyWith({String? nickname}) {
    return User(
      name: name,
      email: email,
      dateOfBirth: dateOfBirth,
      phoneNumber: phoneNumber,
      nickname: nickname ?? this.nickname,
    );
  }
}
