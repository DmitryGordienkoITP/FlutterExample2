import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/preferences_model.dart';

@Singleton(scope: 'baseAccess')
class PreferencesProvider {
  static const prefsKey = 'prefs';

  Future<PreferencesModel?> get() async {
    final storage = await SharedPreferences.getInstance();
    final prefs = storage.getString(prefsKey);
    if (prefs == null) return null;
    return PreferencesModel.fromJson(prefs);
  }

  Future<void> set(PreferencesModel prefs) async {
    final storage = await SharedPreferences.getInstance();
    storage.setString(prefsKey, prefs.toJson());
  }
}
