// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'country_model.dart';

class StationModel {
  final String id;
  final String name;
  final String code;
  String? countryCode;
  CountryModel? country;
  StationModel({
    required this.id,
    required this.name,
    required this.code,
    this.countryCode,
    this.country,
  });

  bool isLike(String searchString) {
    final filter = searchString.toLowerCase();
    return name.toLowerCase().contains(filter);
  }

  StationModel copyWith({
    String? id,
    String? name,
    String? code,
    String? countryCode,
    CountryModel? country,
  }) {
    return StationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      countryCode: countryCode ?? this.countryCode,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'countryCode': countryCode,
      'country': country?.toMap(),
    };
  }

  factory StationModel.fromMap(Map<String, dynamic> map) {
    return StationModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      countryCode:
          map['countryCode'] != null ? map['countryCode'] as String : null,
      country: map['country'] != null
          ? CountryModel.fromMap(map['country'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StationModel.fromJson(String source) =>
      StationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StationModel(id: $id, name: $name, code: $code, countryCode: $countryCode, country: $country)';
  }

  @override
  bool operator ==(covariant StationModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        other.countryCode == countryCode &&
        other.country == country;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        countryCode.hashCode ^
        country.hashCode;
  }
}
