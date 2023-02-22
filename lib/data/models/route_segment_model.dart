// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'country_model.dart';

class RouteSegment {
  String countryCode;
  String countryInternationalCode;
  CountryModel country;
  double ladenCost;
  double emptyCost;
  int ladenDuration;
  int emptyDuration;
  double tariff;
  RouteSegment({
    required this.countryCode,
    required this.countryInternationalCode,
    required this.country,
    required this.ladenCost,
    required this.emptyCost,
    required this.ladenDuration,
    required this.emptyDuration,
    required this.tariff,
  });

  RouteSegment copyWith({
    String? countryCode,
    String? countryInternationalCode,
    CountryModel? country,
    double? ladenCost,
    double? emptyCost,
    int? ladenDuration,
    int? emptyDuration,
    double? tariff,
  }) {
    return RouteSegment(
      countryCode: countryCode ?? this.countryCode,
      countryInternationalCode:
          countryInternationalCode ?? this.countryInternationalCode,
      country: country ?? this.country,
      ladenCost: ladenCost ?? this.ladenCost,
      emptyCost: emptyCost ?? this.emptyCost,
      ladenDuration: ladenDuration ?? this.ladenDuration,
      emptyDuration: emptyDuration ?? this.emptyDuration,
      tariff: tariff ?? this.tariff,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'countryCode': countryCode,
      'countryInternationalCode': countryInternationalCode,
      'country': country.toMap(),
      'ladenCost': ladenCost,
      'emptyCost': emptyCost,
      'ladenDuration': ladenDuration,
      'emptyDuration': emptyDuration,
      'tariff': tariff,
    };
  }

  factory RouteSegment.fromMap(Map<String, dynamic> map) {
    return RouteSegment(
      countryCode: map['countryCode'] as String,
      countryInternationalCode: map['countryInternationalCode'] as String,
      country: CountryModel.fromMap(map['country'] as Map<String, dynamic>),
      ladenCost: map['ladenCost'] + .0 as double,
      emptyCost: map['emptyCost'] + .0 as double,
      ladenDuration: map['ladenDuration'] as int,
      emptyDuration: map['emptyDuration'] as int,
      tariff: map['tariff'] + .0 as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory RouteSegment.fromJson(String source) =>
      RouteSegment.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'RouteSegment(countryCode: $countryCode, countryInternationalCode: $countryInternationalCode, country: $country, ladenCost: $ladenCost, emptyCost: $emptyCost, ladenDuration: $ladenDuration, emptyDuration: $emptyDuration, tariff: $tariff)';
  }

  @override
  bool operator ==(covariant RouteSegment other) {
    if (identical(this, other)) return true;

    return other.countryCode == countryCode &&
        other.countryInternationalCode == countryInternationalCode &&
        other.country == country &&
        other.ladenCost == ladenCost &&
        other.emptyCost == emptyCost &&
        other.ladenDuration == ladenDuration &&
        other.emptyDuration == emptyDuration &&
        other.tariff == tariff;
  }

  @override
  int get hashCode {
    return countryCode.hashCode ^
        countryInternationalCode.hashCode ^
        country.hashCode ^
        ladenCost.hashCode ^
        emptyCost.hashCode ^
        ladenDuration.hashCode ^
        emptyDuration.hashCode ^
        tariff.hashCode;
  }
}
