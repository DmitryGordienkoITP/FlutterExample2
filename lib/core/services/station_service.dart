import 'package:injectable/injectable.dart';

import '../../data/models/station_model.dart';
import '../../data/data_providers/api/station_api_provider.dart';

@Singleton(scope: 'baseAccess')
class StationService {
  List<StationModel> stations = [];

  String lastTransshipmentStationsCountryCode = '';
  List<StationModel> lastTranshipmentStations = [];

  final StationAPIProvider _stationApi;

  StationService(this._stationApi);

  Future<List<StationModel>> getAll({bool force = false}) async {
    if (force || stations.isEmpty) {
      stations = await _stationApi.getAll();
    }
    return stations;
  }

  Future<List<StationModel>> getTransshipment(String countryCode,
      {bool force = false}) async {
    final updateNeeded = force ||
        lastTranshipmentStations.isEmpty ||
        countryCode != lastTransshipmentStationsCountryCode;

    if (updateNeeded) {
      lastTranshipmentStations =
          await _stationApi.getTransshipment(countryCode);
    }
    return lastTranshipmentStations;
  }
}
