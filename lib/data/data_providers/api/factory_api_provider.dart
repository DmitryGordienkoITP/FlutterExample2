import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../core/common/enums/sort_types/factory_sort_type.dart';
import '../../models/factory_model.dart';
import '../../models/paging.dart';
import '../../../core/environment/app_environment.dart';
import 'base_api_provider.dart';

@Injectable(scope: 'fullAccess')
class FactoryAPIProvider extends BaseAPIProvider {
  final _authApiUrl = '${AppEnvironment.apiUrl}/factory/lookup';

  Future<List<FactoryModel>> get({String? productId}) async {
    String sort = FactorySortType.name;

    var url = _authApiUrl;
    url = '$url?sort=$sort';
    url = productId == null ? url : '$url&productIds=$productId';

    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    var paging = Paging.fromMap<FactoryModel>(responseData);

    final items = responseData['items'] as List<dynamic>;

    for (var el in items) {
      final factory = FactoryModel.fromMap(el);
      paging.items.add(factory);
    }
    return paging.items;
  }
}
