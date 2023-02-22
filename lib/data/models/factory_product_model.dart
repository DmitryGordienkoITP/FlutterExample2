// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'product_model.dart';

class FactoryProductModel {
  final String productId;
  ProductModel? product;
  final double price;
  final DateTime priceUpdatedAt;
  final bool isActive;
  FactoryProductModel({
    required this.productId,
    this.product,
    required this.price,
    required this.priceUpdatedAt,
    required this.isActive,
  });

  FactoryProductModel copyWith({
    String? productId,
    ProductModel? product,
    double? price,
    DateTime? priceUpdatedAt,
    bool? isActive,
  }) {
    return FactoryProductModel(
      productId: productId ?? this.productId,
      product: product ?? this.product,
      price: price ?? this.price,
      priceUpdatedAt: priceUpdatedAt ?? this.priceUpdatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'productId': productId,
      'product': product?.toMap(),
      'price': price,
      'priceUpdatedAt': priceUpdatedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  factory FactoryProductModel.fromMap(Map<String, dynamic> map) {
    return FactoryProductModel(
      productId: map['productId'] as String,
      product: map['product'] != null
          ? ProductModel.fromMap(map['product'] as Map<String, dynamic>)
          : null,
      price: map['price'] + .0 as double,
      priceUpdatedAt: DateTime.parse(map['priceUpdatedAt']).toLocal(),
      isActive: map['isActive'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory FactoryProductModel.fromJson(String source) =>
      FactoryProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FactoryProductModel(productId: $productId, product: $product, price: $price, priceUpdatedAt: $priceUpdatedAt, isActive: $isActive)';
  }

  @override
  bool operator ==(covariant FactoryProductModel other) {
    if (identical(this, other)) return true;

    return other.productId == productId &&
        other.product == product &&
        other.price == price &&
        other.priceUpdatedAt == priceUpdatedAt &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return productId.hashCode ^
        product.hashCode ^
        price.hashCode ^
        priceUpdatedAt.hashCode ^
        isActive.hashCode;
  }
}
