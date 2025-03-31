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

  User({
    required this.name,
    required this.email,
    required this.dateOfBirth,
    required this.phoneNumber,
  });

  factory User.initial() {
    return User(
      name: '',
      email: '',
      dateOfBirth: DateTime.now(),
      phoneNumber: '',
    );
  }
}
