import 'dart:convert';

import 'package:injectable/injectable.dart';

import '../../../core/common/enums/sort_types/station_sort_type.dart';
import '../../models/paging.dart';
import '../../models/station_model.dart';
import '../../../core/environment/app_environment.dart';
import 'base_api_provider.dart';

@Injectable(scope: 'baseAccess')
class StationAPIProvider extends BaseAPIProvider {
  final _authApiUrl = '${AppEnvironment.apiUrl}/station/lookup';

  Future<List<StationModel>> getAll() async {
    String sort = StationSortType.name;

    var url = '$_authApiUrl/all';
    url = '$url?take=999999';
    url = '$url&sort=$sort';

    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    var paging = Paging.fromMap<StationModel>(responseData);

    final items = responseData['items'] as List<dynamic>;

    for (var el in items) {
      final station = StationModel.fromMap(el);
      paging.items.add(station);
    }
    return paging.items;
  }

  Future<List<StationModel>> getTransshipment(String countryCode) async {
    String sort = StationSortType.name;

    var url = '$_authApiUrl/fracture';
    url = '$url?take=999999';
    url = '$url&countryCode=$countryCode';
    url = '$url&sort=$sort';

    final response = await securedHttp.get(Uri.parse(url));
    final responseData = json.decode(response.body);
    var paging = Paging.fromMap<StationModel>(responseData);

    final items = responseData['items'] as List<dynamic>;

    for (var el in items) {
      final station = StationModel.fromMap(el);
      paging.items.add(station);
    }
    return paging.items;
  }
}
