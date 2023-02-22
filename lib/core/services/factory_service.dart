import 'package:injectable/injectable.dart';

import '../../data/data_providers/api/factory_api_provider.dart';
import '../../data/models/factory_model.dart';

@Singleton(scope: 'fullAccess')
class FactoryService {
  List<FactoryModel> factories = [];

  final FactoryAPIProvider _factoryApi;

  FactoryService(this._factoryApi);

  Future<List<FactoryModel>> get(
      {bool force = false, String? productId}) async {
    if (force || factories.isEmpty) {
      final result = await _factoryApi.get(productId: productId);
      factories = result;
    }
    return factories;
  }
}
