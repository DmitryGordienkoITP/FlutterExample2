import 'package:intl/intl.dart';

class CalculationRequest {
  DateTime departureDate;
  String productId;
  String? factoryId;
  String? departureStationId;
  String destinationStationId;
  int fractureType;
  List<String> fractureStationsIds = [];
  CalculationRequest({
    required this.departureDate,
    required this.productId,
    required this.factoryId,
    required this.departureStationId,
    required this.destinationStationId,
    required this.fractureType,
    required this.fractureStationsIds,
  });

  toMap() {
    return {
      'departureDate': DateFormat('yyyy-MM-dd').format(departureDate),
      'productId': productId,
      'factoryId': factoryId,
      'departureStationId': departureStationId,
      'destinationStationId': destinationStationId,
      'fractureType': fractureType,
      'fractureStationsIds': fractureStationsIds
    };
  }
}
