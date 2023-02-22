// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CountryModel {
  final String name;
  final String code;
  final String internationalCode;
  CountryModel({
    required this.name,
    required this.code,
    required this.internationalCode,
  });

  CountryModel copyWith({
    String? name,
    String? code,
    String? internationalCode,
  }) {
    return CountryModel(
      name: name ?? this.name,
      code: code ?? this.code,
      internationalCode: internationalCode ?? this.internationalCode,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'code': code,
      'internationalCode': internationalCode,
    };
  }

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      name: map['name'] as String,
      code: map['code'] as String,
      internationalCode: map['internationalCode'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CountryModel.fromJson(String source) =>
      CountryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CountryModel(name: $name, code: $code, internationalCode: $internationalCode)';

  @override
  bool operator ==(covariant CountryModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.code == code &&
        other.internationalCode == internationalCode;
  }

  @override
  int get hashCode =>
      name.hashCode ^ code.hashCode ^ internationalCode.hashCode;
}
