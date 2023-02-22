// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../core/common/enums/user_role_enum.dart';

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      role: UserRole.values[map['role']],
    );
  }

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
