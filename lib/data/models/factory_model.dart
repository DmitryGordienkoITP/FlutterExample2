// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'factory_product_model.dart';
import 'station_model.dart';

class FactoryModel {
  final String id;
  final String name;
  final String code;
  List<StationModel> stations = [];
  List<FactoryProductModel> products = [];
  FactoryModel({
    required this.id,
    required this.name,
    required this.code,
    required this.stations,
    required this.products,
  });

  bool isLike(String searchString) {
    final filter = searchString.toLowerCase();
    return name.toLowerCase().contains(filter);
  }

  FactoryModel copyWith({
    String? id,
    String? name,
    String? code,
    List<StationModel>? stations,
    List<FactoryProductModel>? products,
  }) {
    return FactoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      stations: stations ?? this.stations,
      products: products ?? this.products,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'code': code,
      'stations': stations.map((x) => x.toMap()).toList(),
      'products': products.map((x) => x.toMap()).toList(),
    };
  }

  factory FactoryModel.fromMap(Map<String, dynamic> map) {
    return FactoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      code: map['code'] as String,
      stations: map['stations'] != null
          ? List<StationModel>.from(
              (map['stations'] as List<dynamic>).map<StationModel>(
                (x) => StationModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      products: map['products'] != null
          ? List<FactoryProductModel>.from(
              (map['products'] as List<dynamic>).map<FactoryProductModel>(
                (x) => FactoryProductModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryModel.fromJson(String source) =>
      FactoryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FactoryModel(id: $id, name: $name, code: $code, stations: $stations, products: $products)';
  }

  @override
  bool operator ==(covariant FactoryModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.code == code &&
        listEquals(other.stations, stations) &&
        listEquals(other.products, products);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        stations.hashCode ^
        products.hashCode;
  }
}
