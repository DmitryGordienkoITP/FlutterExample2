// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'delivery_option_details_model.dart';
import 'factory_model.dart';
import 'station_model.dart';

class DeliveryOptionModel {
  String id;
  double price;
  double transshipmentPrice;
  String departureId;
  StationModel departure;
  String destinationId;
  StationModel destination;
  String? transshipmentId;
  StationModel? transshipment;
  String factoryId;
  FactoryModel factory;
  bool isFailed;

  DeliveryOptionDetails? details1;
  DeliveryOptionDetails? details2;

  DeliveryOptionModel({
    required this.id,
    required this.price,
    required this.transshipmentPrice,
    required this.departureId,
    required this.departure,
    required this.destinationId,
    required this.destination,
    required this.transshipmentId,
    this.transshipment,
    required this.factoryId,
    required this.factory,
    required this.isFailed,
    this.details1,
    this.details2,
  });

  DeliveryOptionModel copyWith({
    String? id,
    double? price,
    double? transshipmentPrice,
    String? departureId,
    StationModel? departure,
    String? destinationId,
    StationModel? destination,
    String? transshipmentId,
    StationModel? transshipment,
    String? factoryId,
    FactoryModel? factory,
    bool? isFailed,
    DeliveryOptionDetails? details1,
    DeliveryOptionDetails? details2,
  }) {
    return DeliveryOptionModel(
      id: id ?? this.id,
      price: price ?? this.price,
      transshipmentPrice: transshipmentPrice ?? this.transshipmentPrice,
      departureId: departureId ?? this.departureId,
      departure: departure ?? this.departure,
      destinationId: destinationId ?? this.destinationId,
      destination: destination ?? this.destination,
      transshipmentId: transshipmentId ?? this.transshipmentId,
      transshipment: transshipment ?? this.transshipment,
      factoryId: factoryId ?? this.factoryId,
      factory: factory ?? this.factory,
      isFailed: isFailed ?? this.isFailed,
      details1: details1 ?? this.details1,
      details2: details2 ?? this.details2,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'price': price,
      'transshipmentPrice': transshipmentPrice,
      'departureId': departureId,
      'departure': departure.toMap(),
      'destinationId': destinationId,
      'destination': destination.toMap(),
      'transshipmentId': transshipmentId,
      'transshipment': transshipment?.toMap(),
      'factoryId': factoryId,
      'factory': factory.toMap(),
      'isFailed': isFailed,
    };
  }

  factory DeliveryOptionModel.fromMap(Map<String, dynamic> map) {
    return DeliveryOptionModel(
      id: map['id'] as String,
      price: map['price'] + .0 as double,
      transshipmentPrice: map['fractureDestinationPrice'] + .0 as double,
      departureId: map['departureId'] as String,
      departure: StationModel.fromMap(map['departure'] as Map<String, dynamic>),
      destinationId: map['destinationId'] as String,
      destination:
          StationModel.fromMap(map['destination'] as Map<String, dynamic>),
      transshipmentId:
          map['fractureId'] != null ? map['factoryId'] as String : null,
      transshipment: map['fracture'] != null
          ? StationModel.fromMap(map['fracture'] as Map<String, dynamic>)
          : null,
      factoryId: map['factoryId'] as String,
      factory: FactoryModel.fromMap(map['factory'] as Map<String, dynamic>),
      isFailed: map['isFailed'] as bool,
      details1: map['details1'] != null
          ? DeliveryOptionDetails.fromMap(
              map['details1'] as Map<String, dynamic>)
          : null,
      details2: map['details2'] != null
          ? DeliveryOptionDetails.fromMap(
              map['details2'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryOptionModel.fromJson(String source) =>
      DeliveryOptionModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryOptionModel(id: $id, price: $price, transshipmentPrice: $transshipmentPrice, departureId: $departureId, departure: $departure, destinationId: $destinationId, destination: $destination, transshipmentId: $transshipmentId, transshipment: $transshipment, factoryId: $factoryId, factory: $factory, isFailed: $isFailed)';
  }

  @override
  bool operator ==(covariant DeliveryOptionModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.price == price &&
        other.transshipmentPrice == transshipmentPrice &&
        other.departureId == departureId &&
        other.departure == departure &&
        other.destinationId == destinationId &&
        other.destination == destination &&
        other.transshipmentId == transshipmentId &&
        other.transshipment == transshipment &&
        other.factoryId == factoryId &&
        other.factory == factory &&
        other.isFailed == isFailed &&
        other.details1 == details1 &&
        other.details2 == details2;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        price.hashCode ^
        transshipmentPrice.hashCode ^
        departureId.hashCode ^
        departure.hashCode ^
        destinationId.hashCode ^
        destination.hashCode ^
        transshipmentId.hashCode ^
        transshipment.hashCode ^
        factoryId.hashCode ^
        factory.hashCode ^
        isFailed.hashCode ^
        details1.hashCode ^
        details2.hashCode;
  }
}
