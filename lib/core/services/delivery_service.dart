import 'dart:async';
import 'dart:io';

import 'package:injectable/injectable.dart';

import '../../data/data_providers/api/delivery_api_provider.dart';
import '../../data/data_providers/signals/signalr_provider.dart';
import '../../data/models/delivery_model.dart';
import '../../data/models/factory_model.dart';
import '../../data/models/paging.dart';
import '../../data/models/product_model.dart';
import '../../data/models/station_model.dart';
import '../common/enums/delivery_status_type.dart';
import '../common/enums/transhipment_selection_type.dart';
import '../common/extensions/delivery_status_type_extension.dart';
import '../common/helpers/toast_helper.dart';

@Singleton(scope: 'fullAccess')
class DeliveryService {
  final List<DeliveryModel> _deliveries = [];

  final DeliveryAPIProvider _deliveryApi;
  final SignalRProvider _signalR;

  final _deliveriesStreamController = StreamController<List<DeliveryModel>>();
  late Stream<List<DeliveryModel>> _stream;

  Stream<List<DeliveryModel>> get deliveriesStream => _stream;

  DeliveryService(this._deliveryApi, this._signalR) {
    _stream = _deliveriesStreamController.stream.asBroadcastStream();
    _deliveriesStreamController.add([]);
    initSignalRHandler();
  }

  Future<void> initSignalRHandler() async {
    _signalR.registerHandler('DeliveryCalc', (message) async {
      if (message == null) return;

      final status = DeliveryStatusType.values[message[0]];
      DeliveryModel delivery = DeliveryModel.fromMap(message[1]);
      delivery = await getSingle(delivery.id);
      updateDelivery(delivery);
      if (!status.isMuted) {
        final msg =
            'Статус обновлен: "${status.ruString}". Расчет: "${delivery.product.publicName}" в ${delivery.destinationStation.name}';
        ToastHelper.showAppToast(msg);
      }
    });
  }

  Future<DeliveryModel> create({
    required DateTime departureDate,
    required ProductModel product,
    required FactoryModel? factory,
    required StationModel? departureStation,
    required StationModel destinationStation,
    required TransshipmentSelectionType transshipmentSelectionType,
    required List<StationModel> transshipmentStations,
  }) async {
    final delivery = await _deliveryApi.create(
        departureDate: departureDate,
        productId: product.id,
        factoryId: factory?.id,
        departureStationId: departureStation?.id,
        destinationStationId: destinationStation.id,
        fractureType: transshipmentSelectionType.index,
        transshipments: transshipmentStations.map((e) => e.id).toList());

    _deliveries.insert(0, delivery);
    _updateStream();
    return delivery;
  }

  Future<Paging<DeliveryModel>> get({int? pageIndex, int? pageSize}) async {
    final data =
        await _deliveryApi.get(pageIndex: pageIndex, pageSize: pageSize);
    if (pageIndex == null || pageIndex == 0) {
      _deliveries.clear();
    }
    _deliveries.addAll(data.items);
    _updateStream();
    return data;
  }

  Future<DeliveryModel> getSingle(String deliveryId) async {
    final delivery = await _deliveryApi.getById(deliveryId);
    updateDelivery(delivery);
    return delivery;
  }

  void updateDelivery(DeliveryModel result) {
    final index = _deliveries.indexWhere((element) => element.id == result.id);
    if (index >= 0 && _deliveries[index] != result) {
      _deliveries[index] = result;
      _updateStream();
    }
  }

  Future<File> getAsPdf(String deliveryId) async {
    return await _deliveryApi.getPdfReport(deliveryId);
  }

  Future<DeliveryModel> cancel(String deliveryId) async {
    final result = await _deliveryApi.cancel(deliveryId);
    updateDelivery(result);
    return result;
  }

  _updateStream() {
    _deliveriesStreamController.sink.add(_deliveries);
  }
}
