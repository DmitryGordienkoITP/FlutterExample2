// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  final String id;
  /*
  final String etsngCode;
  final String etsngName;
  final String gngCode;
  final String gngName;
  */
  final String publicName;
  ProductModel(
      {required this.id,
      /*
    required this.etsngCode,
    required this.etsngName,
    required this.gngCode,
    required this.gngName,
    */
      required this.publicName});

  bool isLike(String searchString) {
    final filter = searchString.toLowerCase();
    return publicName.toLowerCase().contains(filter);
  }

  ProductModel copyWith(
      {String? id,
      /*
    String? etsngCode,
    String? etsngName,
    String? gngCode,
    String? gngName,
    */
      String? publicName}) {
    return ProductModel(
        id: id ?? this.id,
        /*
      etsngCode: etsngCode ?? this.etsngCode,
      etsngName: etsngName ?? this.etsngName,
      gngCode: gngCode ?? this.gngCode,
      gngName: gngName ?? this.gngName,
      */
        publicName: publicName ?? this.publicName);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      /*
      'etsngCode': etsngCode,
      'etsngName': etsngName,
      'gngCode': gngCode,
      'gngName': gngName,
      */
      'publicName': publicName,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as String,
      /*
      etsngCode: map['etsngCode'] as String,
      etsngName: map['etsngName'] as String,
      gngCode: map['gngCode'] as String,
      gngName: map['gngName'] as String,
      */
      publicName: map['publicName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);
/*
  @override
  String toString() {
    return 'ProductModel(id: $id*, etsngCode: $etsngCode, etsngName: $etsngName, gngCode: $gngCode, gngName: $gngName)';
  }
  */

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        /*
        other.etsngCode == etsngCode &&
        other.etsngName == etsngName &&
        other.gngCode == gngCode &&
        other.gngName == gngName
        */
        other.publicName == publicName;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        /*
        etsngCode.hashCode ^
        etsngName.hashCode ^
        gngCode.hashCode ^
        gngName.hashCode
        */
        publicName.hashCode;
  }
}
