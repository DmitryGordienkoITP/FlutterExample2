import 'package:injectable/injectable.dart';

import '../../data/data_providers/preferences/preferences_provider.dart';
import '../../data/models/preferences_model.dart';

@Singleton(scope: 'baseAccess')
class PreferencesService {
  PreferencesModel? _prefs;

  final PreferencesProvider _preferencesProvider;

  PreferencesService(this._preferencesProvider) {
    initAsync();
  }

  PreferencesModel get preferences => _prefs!;

  Future<void> initAsync() async {
    _prefs = await _preferencesProvider.get();
    if (_prefs == null) {
      _prefs = PreferencesModel();
      await _saveToStorage();
    }
  }

  Future<void> save(PreferencesModel prefs) async {
    _prefs = prefs;
    await _preferencesProvider.set(_prefs!);
  }

  Future<void> _saveToStorage() async {
    await _preferencesProvider.set(_prefs!);
  }
}
