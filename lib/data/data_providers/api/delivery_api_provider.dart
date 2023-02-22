import 'dart:convert';
import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/common/enums/sort_direction_type.dart';
import '../../models/delivery_model.dart';
import '../../models/paging.dart';
import '../../models/requests/calculation_request.dart';
import '../../../core/environment/app_environment.dart';
import 'base_api_provider.dart';

@Injectable(scope: 'fullAccess')
class DeliveryAPIProvider extends BaseAPIProvider {
  final _apiUrl = '${AppEnvironment.apiUrl}/delivery';

  static const _defaultPageSize = 5;
  static const _defaultPageIndex = 0;

  Future<DeliveryModel> create({
    required DateTime departureDate,
    required String? factoryId,
    required String productId,
    required String? departureStationId,
    required String destinationStationId,
    required int fractureType,
    required List<String> transshipments,
  }) async {
    var url = _apiUrl;

    final reqModel = CalculationRequest(
      departureDate: departureDate,
      productId: productId,
      factoryId: factoryId,
      departureStationId: departureStationId,
      destinationStationId: destinationStationId,
      fractureType: fractureType,
      fractureStationsIds: transshipments,
    );

    final reqBody = json.encode(reqModel.toMap());

    final response = await securedHttp.post(Uri.parse(url), body: reqBody);

    final responseData = json.decode(response.body);
    final delivery = DeliveryModel.fromMap(responseData);

    return delivery;
  }

  Future<Paging<DeliveryModel>> get({int? pageIndex, int? pageSize}) async {
    const sortDir = SortDirectionType.desc;

    pageIndex ??= _defaultPageIndex;
    pageSize ??= _defaultPageSize;

    var url = '$_apiUrl/my';
    url = '$url?sortDir=${sortDir.index}';

    url = '$url&pageIndex=$pageIndex';
    url = '$url&pageSize=$pageSize';

    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    var paging = Paging.fromMap<DeliveryModel>(responseData);

    final items = responseData['items'] as List<dynamic>;

    for (var el in items) {
      final station = DeliveryModel.fromMap(el);
      paging.items.add(station);
    }
    return paging;
  }

  Future<DeliveryModel> getById(String deliveryId) async {
    var url = '$_apiUrl/$deliveryId';
    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    final model = DeliveryModel.fromMap(responseData);
    return model;
  }

  Future<File> getPdfReport(String deliveryId) async {
    var url = '$_apiUrl/$deliveryId/pdf';
    final response = await securedHttp.get(Uri.parse(url));
    final filename = response.headers['content-disposition']!
        .split('; ')
        .firstWhere((element) => element.startsWith('filename'))
        .split('=')[1];

    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    final filePath = '${appDocDirectory.path}/$filename';
    final file = await File(filePath).writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<DeliveryModel> cancel(String deliveryId) async {
    var url = '$_apiUrl/$deliveryId/cancel';
    final response = await securedHttp.patch(Uri.parse(url));
    return DeliveryModel.fromJson(response.body);
  }
}
