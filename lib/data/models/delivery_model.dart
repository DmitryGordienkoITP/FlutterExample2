// ignore_for_file: public_member_api_docs, sort_constructors_first, depend_on_referenced_packages
import 'dart:convert';

import 'package:collection/collection.dart';

import '../../core/common/enums/delivery_status_type.dart';
import '../../core/common/enums/transhipment_selection_type.dart';
import 'delivery_option_model.dart';
import 'factory_model.dart';
import 'product_model.dart';
import 'station_model.dart';

class DeliveryModel {
  String id;
  DateTime createdAt;
  DeliveryStatusType deliveryStatus;
  String productId;
  ProductModel product;
  String? factoryId;
  FactoryModel? factory;
  double productAmount;
  DateTime departureDate;
  String? departureStationId;
  StationModel? departureStation;
  String destinationStationId;
  StationModel destinationStation;
  TransshipmentSelectionType transshipmentSelection;
  List<StationModel> transshipmentStations;
  String? errorDescription;
  List<DeliveryOptionModel>? options;
  DeliveryModel({
    required this.id,
    required this.createdAt,
    required this.deliveryStatus,
    required this.productId,
    required this.product,
    this.factoryId,
    this.factory,
    required this.productAmount,
    required this.departureDate,
    this.departureStationId,
    this.departureStation,
    required this.destinationStationId,
    required this.destinationStation,
    required this.transshipmentSelection,
    required this.transshipmentStations,
    this.errorDescription,
    this.options,
  });

  DeliveryModel copyWith({
    String? id,
    DateTime? createdAt,
    DeliveryStatusType? deliveryStatus,
    String? productId,
    ProductModel? product,
    String? factoryId,
    FactoryModel? factory,
    double? productAmount,
    DateTime? departureDate,
    String? departureStationId,
    StationModel? departureStation,
    String? destinationStationId,
    StationModel? destinationStation,
    TransshipmentSelectionType? transshipmentSelection,
    List<StationModel>? transshipmentStations,
    String? errorDescription,
    List<DeliveryOptionModel>? options,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      productId: productId ?? this.productId,
      product: product ?? this.product,
      factoryId: factoryId ?? this.factoryId,
      factory: factory ?? this.factory,
      productAmount: productAmount ?? this.productAmount,
      departureDate: departureDate ?? this.departureDate,
      departureStationId: departureStationId ?? this.departureStationId,
      departureStation: departureStation ?? this.departureStation,
      destinationStationId: destinationStationId ?? this.destinationStationId,
      destinationStation: destinationStation ?? this.destinationStation,
      transshipmentSelection:
          transshipmentSelection ?? this.transshipmentSelection,
      transshipmentStations:
          transshipmentStations ?? this.transshipmentStations,
      errorDescription: errorDescription ?? this.errorDescription,
      options: options ?? this.options,
    );
  }

  String get transshipmentsString {
    switch (transshipmentSelection) {
      case TransshipmentSelectionType.none:
        return 'Без перевалки';
      case TransshipmentSelectionType.all:
        return 'Все варианты';
      case TransshipmentSelectionType.selected:
        if (transshipmentStations.isEmpty) {
          return 'Ошибка';
        } else {
          return transshipmentStations.map((e) => e.name).join(', ').toString();
        }
      default:
        return 'Ошибка';
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'deliveryStatus': deliveryStatus.index,
      'productId': productId,
      'product': product.toMap(),
      'factoryId': factoryId,
      'factory': factory?.toMap(),
      'productAmount': productAmount,
      'departureDate': departureDate.millisecondsSinceEpoch,
      'departureStationId': departureStationId,
      'departureStation': departureStation?.toMap(),
      'destinationStationId': destinationStationId,
      'destinationStation': destinationStation.toMap(),
      'fractureType': transshipmentSelection.index,
      'fractureStations': transshipmentStations.map((x) => x.toMap()).toList(),
      'errorDescription': errorDescription,
      'options': options?.map((x) => x.toMap()).toList(),
    };
  }

  factory DeliveryModel.fromMap(Map<String, dynamic> map) {
    return DeliveryModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['createdAt']).toLocal(),
      deliveryStatus: DeliveryStatusType.values[map['status']],
      productId: map['productId'] as String,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      factoryId: map['factoryId'] != null ? map['factoryId'] as String : null,
      factory: map['factory'] != null
          ? FactoryModel.fromMap(map['factory'] as Map<String, dynamic>)
          : null,
      productAmount: map['productAmount'] + .0 as double,
      departureDate: DateTime.parse(map['departureDate']).toLocal(),
      departureStationId: map['departureStationId'] != null
          ? map['departureStationId'] as String
          : null,
      departureStation: map['departureStation'] != null
          ? StationModel.fromMap(
              map['departureStation'] as Map<String, dynamic>)
          : null,
      destinationStationId: map['destinationStationId'] as String,
      destinationStation: StationModel.fromMap(
          map['destinationStation'] as Map<String, dynamic>),
      transshipmentSelection:
          TransshipmentSelectionType.values[map['fractureType']],
      transshipmentStations: map['fractureStations'] != null
          ? List<StationModel>.from(
              (map['fractureStations'] as List<dynamic>).map<StationModel>(
                (x) => StationModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : [],
      errorDescription: map['errorDescription'] != null
          ? map['errorDescription'] as String
          : null,
      options: map['options'] != null
          ? List<DeliveryOptionModel>.from(
              (map['options'] as List<dynamic>).map<DeliveryOptionModel?>(
                (x) => DeliveryOptionModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeliveryModel.fromJson(String source) =>
      DeliveryModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeliveryModel(id: $id, createdAt: $createdAt, deliveryStatus: $deliveryStatus, productId: $productId, product: $product, factoryId: $factoryId, factory: $factory, productAmount: $productAmount, departureDate: $departureDate, departureStationId: $departureStationId, departureStation: $departureStation, destinationStationId: $destinationStationId, destinationStation: $destinationStation, transshipmentSelection: $transshipmentSelection, transshipmentStations: $transshipmentStations, errorDescription: $errorDescription, options: $options)';
  }

  @override
  bool operator ==(covariant DeliveryModel other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;

    return other.id == id &&
        other.createdAt == createdAt &&
        other.deliveryStatus == deliveryStatus &&
        other.productId == productId &&
        other.product == product &&
        other.factoryId == factoryId &&
        other.factory == factory &&
        other.productAmount == productAmount &&
        other.departureDate == departureDate &&
        other.departureStationId == departureStationId &&
        other.departureStation == departureStation &&
        other.destinationStationId == destinationStationId &&
        other.destinationStation == destinationStation &&
        other.transshipmentSelection == transshipmentSelection &&
        listEquals(other.transshipmentStations, transshipmentStations) &&
        other.errorDescription == errorDescription &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        createdAt.hashCode ^
        deliveryStatus.hashCode ^
        productId.hashCode ^
        product.hashCode ^
        factoryId.hashCode ^
        factory.hashCode ^
        productAmount.hashCode ^
        departureDate.hashCode ^
        departureStationId.hashCode ^
        departureStation.hashCode ^
        destinationStationId.hashCode ^
        destinationStation.hashCode ^
        transshipmentSelection.hashCode ^
        transshipmentStations.hashCode ^
        errorDescription.hashCode ^
        options.hashCode;
  }
}
