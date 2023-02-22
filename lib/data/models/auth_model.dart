// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AuthModel {
  final String token;
  final DateTime exp;
  final String refresh;
  AuthModel({
    required this.token,
    required this.exp,
    required this.refresh,
  });

  AuthModel copyWith({
    String? token,
    DateTime? exp,
    String? refresh,
  }) {
    return AuthModel(
      token: token ?? this.token,
      exp: exp ?? this.exp,
      refresh: refresh ?? this.refresh,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'token': token,
      'exp': exp.toIso8601String(),
      'refresh': refresh,
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      token: map['token'] as String,
      exp: DateTime.parse(map['exp']).toLocal(),
      refresh: map['refresh'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AuthModel(token: $token, exp: $exp, refresh: $refresh)';

  @override
  bool operator ==(covariant AuthModel other) {
    if (identical(this, other)) return true;

    return other.token == token && other.exp == exp && other.refresh == refresh;
  }

  @override
  int get hashCode => token.hashCode ^ exp.hashCode ^ refresh.hashCode;
}
